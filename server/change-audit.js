const db = require('./db');
const { eq } = require('drizzle-orm');
const { orm, schema } = require('./orm');

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
  const actor = orm
    .select({ nombre: schema.usuarios.nombre })
    .from(schema.usuarios)
    .where(eq(schema.usuarios.id, req.user.id))
    .get();
  orm
    .insert(schema.auditoriaCambios)
    .values({
      usuarioId: actor ? req.user.id : null,
      usuarioNombre: actor?.nombre || 'Usuario eliminado',
      metodo: req.method,
      ruta: req.originalUrl.split('?')[0],
    })
    .run();
}

module.exports = { recordChange };
