const db = require('../db');

const emailHandler = require('../../api/send-email');

module.exports = app => {
  app.post('/api/send-email', async (req, res) => {
    try {
      const config = db.prepare('SELECT * FROM configuracion_empresa LIMIT 1').get();
      req.body = { ...req.body, host: config.smtp_host, port: config.smtp_port, user: config.smtp_user, pass: require('../secrets').decrypt(config.smtp_pass) };
      await emailHandler(req, res);
    } catch (err) {
      console.error('Error enviando email:', err);
      if (!res.headersSent) {
        res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
      }
    }
  });
};
