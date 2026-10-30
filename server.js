// Punto de entrada. Las rutas y reglas del backend viven en server/.
const app = require('./server/app');

if (require.main === module) {
  const stopBackups = (!process.env.VERCEL && !process.env.DATABASE_URL)
    ? require('./server/backup-scheduler').startBackupSchedule()
    : () => {};
  const port = Number(process.env.PORT || 3000);
  const server = app.listen(port, () => console.log('Santi Inc disponible en http://localhost:' + port));
  for (const signal of ['SIGINT', 'SIGTERM']) {
    process.on(signal, () => server.close(() => {
      stopBackups();
      try { require('./server/db').close(); } catch (_) {}
      process.exit(0);
    }));
  }
}

module.exports = app;
