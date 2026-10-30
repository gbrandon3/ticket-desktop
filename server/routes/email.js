const { orm, schema } = require('../orm');
const emailHandler = require('../../api/send-email');

module.exports = app => {
  app.post('/api/send-email', async (req, res) => {
    try {
      const config = orm.select().from(schema.configuracionEmpresa).limit(1).get();
      req.body = {
        ...req.body,
        host: config.smtpHost,
        port: config.smtpPort,
        user: config.smtpUser,
        pass: require('../secrets').decrypt(config.smtpPass),
      };
      await emailHandler(req, res);
    } catch (err) {
      console.error('Error enviando email:', err);
      if (!res.headersSent) {
        res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
      }
    }
  });
};
