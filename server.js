const http = require('http');
const handler = require('./api/send-email');

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  // Polyfill de conveniencia similar al entorno serverless de Vercel/Express
  res.status = function (code) {
    res.statusCode = code;
    return res;
  };

  res.json = function (data) {
    if (!res.headersSent) {
      res.setHeader('Content-Type', 'application/json');
    }
    res.end(JSON.stringify(data));
    return res;
  };

  const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);

  if (url.pathname === '/api/send-email') {
    let body = '';
    req.on('data', chunk => {
      body += chunk;
    });

    req.on('end', async () => {
      try {
        req.body = body ? JSON.parse(body) : {};
      } catch (err) {
        req.body = {};
      }
      try {
        await handler(req, res);
      } catch (handlerErr) {
        console.error('Error no capturado en handler:', handlerErr);
        if (!res.headersSent) {
          res.status(500).json({ success: false, error: handlerErr.message });
        }
      }
    });
  } else {
    res.status(404).json({ success: false, error: `Ruta no encontrada: ${url.pathname}. Use /api/send-email` });
  }
});

server.listen(PORT, () => {
  console.log(`\n======================================================`);
  console.log(`  🚀 Servidor local de correo SMTP activo en:`);
  console.log(`  👉 http://localhost:${PORT}/api/send-email`);
  console.log(`======================================================\n`);
});
