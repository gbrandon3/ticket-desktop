const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const { securityMiddleware, migratePasswords } = require('./security');
const { validationMiddleware, atomicRoute } = require('./validation');
const app = express();
const PORT = process.env.PORT || 3000;
migratePasswords();
require('./secrets').migrateSecrets(require('./db'));
require('./change-audit');
app.disable('x-powered-by');
app.use(cors({ origin(origin, callback) {
  const allowed = (process.env.CORS_ORIGINS || '').split(',').filter(Boolean);
  callback(null, !origin || /^http:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin) || allowed.includes(origin));
} }));
app.use(express.json({ limit: '15mb' }));
const uploadsDir = path.join(__dirname, '..', 'data', 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}
app.use('/uploads', express.static(uploadsDir));
app.use('/api', securityMiddleware, validationMiddleware);
// SQLite writes inside each synchronous route either all commit or all roll back.
for (const method of ['post', 'put', 'delete']) {
  const register = app[method].bind(app);
  app[method] = (route, handler) => register(route, ['/api/send-email', '/api/backups'].includes(route) ? handler : atomicRoute(handler));
}
require('./routes/config')(app);
require('./routes/users')(app);
require('./routes/clients')(app);
require('./routes/equipment')(app);
require('./routes/orders')(app);
require('./routes/workshop')(app);
require('./routes/metrics')(app);
require('./routes/public')(app);
require('./routes/audit')(app);
require('./routes/catalog')(app);
require('./routes/email')(app);
require('./routes/maintenance')(app);
app.post('/api/auth/logout', (req, res) => {
  require('./security').revokeSession(req.headers.authorization?.slice(7));
  res.json({ success: true });
});
const webBuildPath = path.join(__dirname, '..', 'build', 'web');
if (fs.existsSync(webBuildPath)) {
  app.use(express.static(webBuildPath));
  app.use((req, res, next) => {
    if (req.method === 'GET' && !req.path.startsWith('/api/')) {
      return res.sendFile(path.join(webBuildPath, 'index.html'));
    }
    next();
  });
} else {
  app.get('/', (req, res) => {
    res.send(`
      <!DOCTYPE html>
      <html>
        <head><title>Santi Inc - Servidor Central SQLite</title></head>
        <body style="font-family: sans-serif; text-align: center; padding: 40px; background: #0f172a; color: white;">
          <h1 style="color: #38bdf8;">🚀 Servidor Central SQLite de Santi Inc Activo</h1>
          <p>Puerto: <strong>${PORT}</strong></p>
          <p>Base de datos: <code>data/tickets.sqlite</code></p>
          <div style="background: #1e293b; display: inline-block; padding: 20px; border-radius: 8px; text-align: left;">
            <p>✅ API REST disponible en: <code>http://localhost:${PORT}/api/</code></p>
            <p>✅ Servicio de Correo SMTP: <code>/api/send-email</code></p>
            <p>✅ Consulta Pública: <code>/api/consulta-publica?q=...</code></p>
          </div>
        </body>
      </html>
    `);
  });
}
app.use('/api', (req, res) => res.status(404).json({ success: false, error: 'Ruta no encontrada' }));
app.use((err, req, res, next) => {
  console.error('Solicitud fallida:', err.message);
  res.status(err.status || 500).json({ success: false, error: err.status === 400 ? 'JSON inválido' : 'No se pudo completar la operación' });
});
module.exports = app;
