const db = require('./db');

db.exec(`
  CREATE TABLE IF NOT EXISTS auditoria_cambios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE SET NULL,
    usuario_nombre TEXT NOT NULL,
    metodo TEXT NOT NULL,
    ruta TEXT NOT NULL,
    fecha TEXT NOT NULL DEFAULT (datetime('now'))
  );
  CREATE INDEX IF NOT EXISTS idx_auditoria_fecha ON auditoria_cambios(fecha);
`);

function recordChange(req) {
  if (!req.user || req.path.startsWith('/api/auth/') || req.path === '/api/auditoria') return;
  const actor = db.prepare('SELECT nombre FROM usuarios WHERE id = ?').get(req.user.id);
  db.prepare(`INSERT INTO auditoria_cambios (usuario_id, usuario_nombre, metodo, ruta)
    VALUES (?, ?, ?, ?)`).run(actor ? req.user.id : null, actor?.nombre || 'Usuario eliminado', req.method, req.originalUrl.split('?')[0]);
}

module.exports = { recordChange };
