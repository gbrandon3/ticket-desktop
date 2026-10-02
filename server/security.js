const crypto = require('node:crypto');
const db = require('./db');

const sessions = new Map();
const attempts = new Map();
const SESSION_MS = 8 * 60 * 60 * 1000;

function hashPassword(password) {
  if (typeof password !== 'string' || password.length < 8 || password.length > 256) {
    throw Object.assign(new Error('La contraseña debe tener entre 8 y 256 caracteres'), { status: 400 });
  }
  const salt = crypto.randomBytes(16).toString('hex');
  return `scrypt:${salt}:${crypto.scryptSync(password, salt, 64).toString('hex')}`;
}

function verifyPassword(password, stored) {
  if (typeof password !== 'string' || password.length > 256 || !stored) return false;
  const [scheme, salt, digest] = stored.split(':');
  if (scheme !== 'scrypt' || !salt || !digest) return false;
  const expected = Buffer.from(digest, 'hex');
  const actual = crypto.scryptSync(password, salt, 64);
  return expected.length === actual.length && crypto.timingSafeEqual(expected, actual);
}

function migratePasswords() {
  // Existing short passwords are migrated without requiring a reset.
  for (const row of db.prepare('SELECT id, password FROM usuarios').all()) {
    if (row.password.startsWith('scrypt:')) continue;
    const salt = crypto.randomBytes(16).toString('hex');
    const digest = crypto.scryptSync(row.password, salt, 64).toString('hex');
    db.prepare('UPDATE usuarios SET password = ? WHERE id = ?').run(`scrypt:${salt}:${digest}`, row.id);
  }
}

function createSession(userId) {
  const token = crypto.randomBytes(32).toString('hex');
  sessions.set(token, { userId, expires: Date.now() + SESSION_MS });
  return token;
}

function revokeSession(token) { sessions.delete(token); }
function revokeUserSessions(id, keepToken) {
  for (const [token, session] of sessions) if (session.userId === id && token !== keepToken) sessions.delete(token);
}

function securityMiddleware(req, res, next) {
  const now = Date.now();
  for (const [token, session] of sessions) if (session.expires <= now) sessions.delete(token);
  for (const [key, entry] of attempts) if (entry.until <= now) attempts.delete(key);
  const fail = (status, error) => res.status(status).json({ success: false, error });
  if (['/auth/login', '/setup', '/consulta-publica'].includes(req.path)) {
    const key = `${req.ip}:${req.path}`;
    const entry = attempts.get(key) || { count: 0, until: now + 15 * 60 * 1000 };
    attempts.set(key, entry);
    if (++entry.count > (req.path === '/consulta-publica' ? 100 : 20)) return fail(429, 'Demasiados intentos; intente más tarde');
  }
  if (req.path === '/setup' && req.method === 'POST') {
    const config = db.prepare('SELECT is_setup_completed FROM configuracion_empresa LIMIT 1').get();
    if (config?.is_setup_completed) return fail(409, 'La configuración inicial ya está completada');
    return next();
  }
  if ((req.path === '/auth/login' && req.method === 'POST') ||
      (['/setup/status', '/consulta-publica', '/config'].includes(req.path) && req.method === 'GET')) return next();
  const token = req.headers.authorization?.startsWith('Bearer ') ? req.headers.authorization.slice(7) : null;
  const session = sessions.get(token);
  if (!session) return fail(401, 'Inicie sesión para continuar');
  req.user = db.prepare('SELECT id, rol, activo FROM usuarios WHERE id = ?').get(session.userId);
  if (!req.user?.activo) return fail(401, 'Sesión inválida');
  if (!['admin', 'solicitante', 'tecnico'].includes(req.user.rol)) return fail(403, 'Rol inválido');
  const admin = req.user.rol === 'admin';
  const write = req.method !== 'GET';
  if (!admin && ((req.path === '/config' && write) || req.path.startsWith('/metrics/admin') ||
      req.path.startsWith('/auditoria') && !write || req.path.startsWith('/tipos-falla') && write ||
      req.path.startsWith('/historial-cambios') || req.path.startsWith('/backups'))) {
    return fail(403, 'Se requieren permisos de administrador');
  }
  if (!admin && req.path.startsWith('/usuarios')) {
    if (req.method === 'GET' && req.path === '/usuarios') {
      // The users route restricts the list to technicians.
    } else if (!(req.method === 'PUT' && req.path === `/usuarios/${req.user.id}`)) {
      return fail(403, 'Se requieren permisos de administrador');
    } else {
      req.body.rol = req.user.rol;
      req.body.activo = true;
      if (req.body.password) {
        const current = db.prepare('SELECT password FROM usuarios WHERE id = ?').get(req.user.id);
        if (!verifyPassword(req.body.currentPassword, current.password)) return fail(403, 'La contraseña actual no es correcta');
      }
    }
  }
  if (req.user.rol === 'tecnico' && write && (['/ordenes', '/clientes', '/setup'].includes(req.path) || req.path.endsWith('/tecnico') || req.path.startsWith('/equipos'))) {
    return fail(403, 'El técnico no puede registrar ingresos');
  }
  if (req.method === 'PUT' && req.path === '/usuarios/' + req.user.id && req.body.password) {
    const current = db.prepare('SELECT password FROM usuarios WHERE id = ?').get(req.user.id);
    if (!verifyPassword(req.body.currentPassword, current.password)) return fail(403, 'La contraseña actual no es correcta');
  }
  next();
}

function sessionUser(token) {
  const session = sessions.get(token);
  if (!session || session.expires <= Date.now()) return null;
  return db.prepare('SELECT id, rol FROM usuarios WHERE id = ? AND activo = 1').get(session.userId);
}

module.exports = { sessionUser, hashPassword, verifyPassword, migratePasswords, createSession, revokeSession, revokeUserSessions, securityMiddleware };
