const crypto = require('node:crypto');
const { eq, and } = require('drizzle-orm');
const { orm, schema } = require('./orm');

const sessions = new Map();
const revokedTokens = new Set();
const revokedUsersBefore = new Map();
const attempts = new Map();
const SESSION_MS = 24 * 60 * 60 * 1000;
const SESSION_SECRET = process.env.SESSION_SECRET || process.env.SUPABASE_ANON_KEY || 'santi-inc-session-hmac-secret-2026';

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
  for (const row of orm.select({ id: schema.usuarios.id, password: schema.usuarios.password }).from(schema.usuarios).all()) {
    if (row.password.startsWith('scrypt:')) continue;
    const salt = crypto.randomBytes(16).toString('hex');
    const digest = crypto.scryptSync(row.password, salt, 64).toString('hex');
    orm.update(schema.usuarios).set({ password: `scrypt:${salt}:${digest}` })
      .where(eq(schema.usuarios.id, row.id)).run();
  }
}

function createSession(userId) {
  const issuedAt = Date.now();
  const expires = issuedAt + SESSION_MS;
  const nonce = crypto.randomBytes(8).toString('hex');
  const payload = Buffer.from(JSON.stringify({ u: Number(userId), i: issuedAt, e: expires, n: nonce })).toString('base64url');
  const sig = crypto.createHmac('sha256', SESSION_SECRET).update(payload).digest('base64url');
  const token = `${payload}.${sig}`;
  sessions.set(token, { userId: Number(userId), expires });
  return token;
}

function parseSessionToken(token) {
  if (!token || typeof token !== 'string') return null;
  if (revokedTokens.has(token)) return null;
  const existing = sessions.get(token);
  if (existing) {
    if (existing.expires <= Date.now()) {
      sessions.delete(token);
      return null;
    }
    return existing;
  }
  const parts = token.split('.');
  if (parts.length !== 2) return null;
  const [payload, sig] = parts;
  const expectedSig = crypto.createHmac('sha256', SESSION_SECRET).update(payload).digest('base64url');
  const sigBuf = Buffer.from(sig);
  const expBuf = Buffer.from(expectedSig);
  if (sigBuf.length !== expBuf.length || !crypto.timingSafeEqual(sigBuf, expBuf)) return null;
  try {
    const data = JSON.parse(Buffer.from(payload, 'base64url').toString('utf8'));
    if (!data.u || !data.e || data.e <= Date.now()) return null;
    const minIssued = revokedUsersBefore.get(Number(data.u));
    if (minIssued && (!data.i || data.i <= minIssued)) return null;
    return { userId: Number(data.u), expires: Number(data.e) };
  } catch (_) {
    return null;
  }
}

function revokeSession(token) {
  if (token) {
    sessions.delete(token);
    revokedTokens.add(token);
  }
}

function revokeUserSessions(id, keepToken) {
  revokedUsersBefore.set(Number(id), Date.now());
  for (const [token, session] of sessions) {
    if (session.userId === id && token !== keepToken) {
      sessions.delete(token);
      revokedTokens.add(token);
    }
  }
}

function securityMiddleware(req, res, next) {
  const now = Date.now();
  for (const [token, session] of sessions) if (session.expires <= now) sessions.delete(token);
  for (const [key, entry] of attempts) if (entry.until <= now) attempts.delete(key);
  const fail = (status, error) => res.status(status).json({ success: false, error });
  if (['/auth/login', '/auth/recover-password', '/setup', '/consulta-publica'].includes(req.path)) {
    const clientIp = (req.headers['x-forwarded-for'] || req.ip || '127.0.0.1').toString().split(',')[0].trim();
    const key = `${clientIp}:${req.path}`;
    const entry = attempts.get(key) || { count: 0, until: now + 15 * 60 * 1000 };
    attempts.set(key, entry);
    if (++entry.count > 100) return fail(429, 'Demasiados intentos; intente más tarde');
  }
  if (req.path === '/setup' && req.method === 'POST') {
    const config = orm.select({ completed: schema.configuracionEmpresa.isSetupCompleted })
      .from(schema.configuracionEmpresa).get();
    if (config?.completed) return fail(409, 'La configuración inicial ya está completada');
    return next();
  }
  if ((['/auth/login', '/auth/recover-password'].includes(req.path) && req.method === 'POST') ||
      (['/setup/status', '/consulta-publica', '/config'].includes(req.path) && req.method === 'GET')) return next();
  const token = req.headers.authorization?.startsWith('Bearer ') ? req.headers.authorization.slice(7) : null;
  const session = parseSessionToken(token);
  if (!session) return fail(401, 'Inicie sesión para continuar');
  req.user = orm.select({ id: schema.usuarios.id, rol: schema.usuarios.rol, activo: schema.usuarios.activo })
    .from(schema.usuarios).where(eq(schema.usuarios.id, session.userId)).get();
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
        const current = orm.select({ password: schema.usuarios.password }).from(schema.usuarios)
          .where(eq(schema.usuarios.id, req.user.id)).get();
        if (!verifyPassword(req.body.currentPassword, current.password)) return fail(403, 'La contraseña actual no es correcta');
      }
    }
  }
  if (req.user.rol === 'tecnico' && write && (['/ordenes', '/clientes', '/setup'].includes(req.path) || req.path.endsWith('/tecnico') || req.path.startsWith('/equipos'))) {
    return fail(403, 'El técnico no puede registrar ingresos');
  }
  if (req.method === 'PUT' && req.path === '/usuarios/' + req.user.id && req.body.password) {
    const current = orm.select({ password: schema.usuarios.password }).from(schema.usuarios)
      .where(eq(schema.usuarios.id, req.user.id)).get();
    if (!verifyPassword(req.body.currentPassword, current.password)) return fail(403, 'La contraseña actual no es correcta');
  }
  next();
}

function sessionUser(token) {
  const session = parseSessionToken(token);
  if (!session || session.expires <= Date.now()) return null;
  return orm.select({ id: schema.usuarios.id, rol: schema.usuarios.rol }).from(schema.usuarios)
    .where(and(eq(schema.usuarios.id, session.userId), eq(schema.usuarios.activo, true))).get();
}

module.exports = { sessionUser, hashPassword, verifyPassword, migratePasswords, createSession, revokeSession, revokeUserSessions, securityMiddleware };
