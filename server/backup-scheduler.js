const { createBackup } = require('./backup');
const status = { enabled: false, intervalHours: 24, lastBackup: null, lastError: null };

function runBackup() {
  try {
    const destination = createBackup();
    status.lastBackup = new Date().toISOString();
    status.lastError = null;
    console.log(`Respaldo creado: ${destination}`);
    return destination;
  } catch (error) {
    status.lastError = error.message;
    throw error;
  }
}

function startBackupSchedule() {
  const hours = Number(process.env.BACKUP_INTERVAL_HOURS ?? 24);
  if (!Number.isFinite(hours) || hours < 0 || hours > 500) throw new Error('BACKUP_INTERVAL_HOURS debe estar entre 0 y 500');
  status.enabled = hours > 0;
  status.intervalHours = hours;
  if (!status.enabled) return () => {};
  const run = () => {
    try { runBackup(); }
    catch (error) { console.error('No se pudo generar el respaldo automático:', error.message); }
  };
  run();
  const timer = setInterval(run, hours * 3600000);
  timer.unref();
  return () => clearInterval(timer);
}

module.exports = { startBackupSchedule, runBackup, status };
