const emailHandler = require('../../api/send-email');

module.exports = app => {
  app.post('/api/send-email', async (req, res) => {
    try {
      await emailHandler(req, res);
    } catch (err) {
      console.error('Error enviando email:', err);
      if (!res.headersSent) {
        res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
      }
    }
  });
};
