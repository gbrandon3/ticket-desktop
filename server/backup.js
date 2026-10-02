const fs = require('node:fs');
const path = require('node:path');
const { DatabaseSync } = require('node:sqlite');

function createBackup({
  source = process.env.TICKETS_DB_PATH || path.join(__dirname, '..', 'data', 'tickets.sqlite'),
  directory = process.env.TICKETS_BACKUP_DIR || path.join(__dirname, '..', 'backups'),
  keyFile = process.env.TICKETS_SECRET_KEY_FILE || path.join(__dirname, '..', 'data', 'smtp.key'),
} = {}) {
  if (!fs.existsSync(source)) throw new Error('No existe la base de datos para respaldar');
  fs.mkdirSync(directory, { recursive: true });
  const destination = path.join(directory, 'tickets-' + new Date().toISOString().replace(/[:.]/g, '-') + '-' + process.hrtime.bigint() + '.sqlite');
  const db = new DatabaseSync(source);
  try {
    db.exec("VACUUM INTO '" + destination.replace(/'/g, "''") + "'");
    if (fs.existsSync(keyFile)) fs.copyFileSync(keyFile, destination + '.key');
    return destination;
  } finally {
    db.close();
  }
}

if (require.main === module) console.log('Respaldo creado: ' + createBackup());
module.exports = { createBackup };
