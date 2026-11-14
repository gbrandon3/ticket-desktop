const { orm, schema } = require('../orm');
const emailHandler = require('../../api/send-email');

module.exports = app => {
  app.post('/api/send-email', async (req, res) => {
    try {
      const config = orm.select().from(schema.configuracionEmpresa).limit(1).get();
      const dbPass = config?.smtpPass ? require('../secrets').decrypt(config.smtpPass) : null;
      req.body = {
        ...req.body,
        host: req.body?.host || config?.smtpHost || 'smtp.gmail.com',
        port: req.body?.port || config?.smtpPort || 465,
        user: req.body?.user || config?.smtpUser || config?.email,
        pass: (req.body?.pass && req.body.pass !== '********') ? req.body.pass : dbPass,
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
