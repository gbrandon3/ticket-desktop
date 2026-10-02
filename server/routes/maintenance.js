const db = require('../db');
const { runBackup, status } = require('../backup-scheduler');

module.exports = app => {
  app.get('/api/historial-cambios', (req, res) => {
    const limit = Math.max(1, Math.min(200, Number(req.query.limit) || 100));
    const offset = Math.max(0, Number(req.query.offset) || 0);
    const rows = db.prepare(`SELECT id, usuario_id AS usuarioId, usuario_nombre AS usuarioNombre,
      metodo, ruta, fecha FROM auditoria_cambios ORDER BY id DESC LIMIT ? OFFSET ?`).all(Math.floor(limit), Math.floor(offset));
    res.json({ success: true, data: rows });
  });

  app.get('/api/backups/status', (req, res) => res.json({ success: true, data: status }));
  app.post('/api/backups', (req, res, next) => {
    try {
      const destination = runBackup();
      require('../change-audit').recordChange(req);
      res.download(destination);
    } catch (error) { next(error); }
  });
};
