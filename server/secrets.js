const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');

let key;
function getKey() {
  if (key) return key;
  if (process.env.TICKETS_DB_PATH === ':memory:') return key = crypto.randomBytes(32);
  const location = process.env.TICKETS_SECRET_KEY_FILE || path.join(__dirname, '..', 'data', 'smtp.key');
  if (!fs.existsSync(location)) {
    fs.mkdirSync(path.dirname(location), { recursive: true });
    fs.writeFileSync(location, crypto.randomBytes(32), { flag: 'wx', mode: 0o600 });
  }
  key = fs.readFileSync(location);
  if (key.length !== 32) throw new Error('La clave SMTP debe contener 32 bytes');
  return key;
}

function encrypt(value) {
  if (!value) return null;
  const iv = crypto.randomBytes(12);
  const cipher = crypto.createCipheriv('aes-256-gcm', getKey(), iv);
  const bytes = Buffer.concat([cipher.update(value, 'utf8'), cipher.final()]);
  return ['enc', iv.toString('hex'), cipher.getAuthTag().toString('hex'), bytes.toString('hex')].join(':');
}

function decrypt(value) {
  if (!value) return null;
  if (!value.startsWith('enc:')) return value;
  const [, iv, tag, data] = value.split(':');
  const cipher = crypto.createDecipheriv('aes-256-gcm', getKey(), Buffer.from(iv, 'hex'));
  cipher.setAuthTag(Buffer.from(tag, 'hex'));
  return Buffer.concat([cipher.update(Buffer.from(data, 'hex')), cipher.final()]).toString('utf8');
}

function migrateSecrets(db) {
  for (const row of db.prepare('SELECT id, smtp_pass FROM configuracion_empresa').all()) {
    if (row.smtp_pass && !row.smtp_pass.startsWith('enc:')) {
      db.prepare('UPDATE configuracion_empresa SET smtp_pass = ? WHERE id = ?').run(encrypt(row.smtp_pass), row.id);
    }
  }
}

module.exports = { encrypt, decrypt, migrateSecrets };
