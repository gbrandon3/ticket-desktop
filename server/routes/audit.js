const { desc } = require('drizzle-orm');
const { orm, schema } = require('../orm');

module.exports = app => {
  app.get('/api/auditoria', (req, res) => {
    try {
      const rows = orm
        .select()
        .from(schema.notificacionesAuditoria)
        .orderBy(desc(schema.notificacionesAuditoria.id))
        .limit(50)
        .all();
      res.json({
        success: true,
        data: rows.map(n => ({
          id: n.id,
          destinatario: n.destinatario,
          asunto: n.asunto,
          evento: n.evento,
          estado: n.estado,
          fechaEnvio: n.fechaEnvio,
        })),
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/auditoria', (req, res) => {
    try {
      const { destinatario, asunto, evento, estado, fechaEnvio } = req.body;
      orm
        .insert(schema.notificacionesAuditoria)
        .values({
          destinatario,
          asunto,
          evento,
          estado,
          fechaEnvio: fechaEnvio || new Date().toISOString(),
        })
        .run();
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
