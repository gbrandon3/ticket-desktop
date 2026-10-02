const db = require('../db');

module.exports = app => {
  app.get('/api/auditoria', (req, res) => {
    try {
      const rows = db.prepare('SELECT * FROM notificaciones_auditoria ORDER BY id DESC LIMIT 50').all();
      res.json({
        success: true,
        data: rows.map(n => ({
          id: n.id,
          destinatario: n.destinatario,
          asunto: n.asunto,
          evento: n.evento,
          estado: n.estado,
          fechaEnvio: n.fecha_envio,
        })),
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/auditoria', (req, res) => {
    try {
      const { destinatario, asunto, evento, estado, fechaEnvio } = req.body;
      db.prepare(`
        INSERT INTO notificaciones_auditoria (destinatario, asunto, evento, estado, fecha_envio)
        VALUES (?, ?, ?, ?, ?)
      `).run(destinatario, asunto, evento, estado, fechaEnvio || new Date().toISOString());
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
