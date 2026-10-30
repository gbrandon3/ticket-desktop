const { desc } = require('drizzle-orm');
const { orm, schema } = require('../orm');
const { runBackup, status } = require('../backup-scheduler');

module.exports = app => {
  app.get('/api/historial-cambios', (req, res) => {
    const limit = Math.max(1, Math.min(200, Number(req.query.limit) || 100));
    const offset = Math.max(0, Number(req.query.offset) || 0);
    const rows = orm
      .select({
        id: schema.auditoriaCambios.id,
        usuarioId: schema.auditoriaCambios.usuarioId,
        usuarioNombre: schema.auditoriaCambios.usuarioNombre,
        metodo: schema.auditoriaCambios.metodo,
        ruta: schema.auditoriaCambios.ruta,
        fecha: schema.auditoriaCambios.fecha,
      })
      .from(schema.auditoriaCambios)
      .orderBy(desc(schema.auditoriaCambios.id))
      .limit(Math.floor(limit))
      .offset(Math.floor(offset))
      .all();
    res.json({ success: true, data: rows });
  });

  app.get('/api/backups/status', (req, res) => res.json({ success: true, data: status }));
  app.post('/api/backups', (req, res, next) => {
    try {
      const destination = runBackup();
      require('../change-audit').recordChange(req);
      res.download(destination);
    } catch (error) {
      next(error);
    }
  });
};
