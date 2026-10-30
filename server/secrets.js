const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { eq } = require('drizzle-orm');
const { orm, schema } = require('./orm');

let key;
function getKey() {
  if (key) return key;
  if (process.env.TICKETS_DB_PATH === ':memory:' && !process.env.VERCEL) return key = crypto.randomBytes(32);
  if (process.env.VERCEL) {
    return key = crypto.createHash('sha256').update(process.env.SUPABASE_ANON_KEY || 'santi-inc-master-key-2026').digest();
  }
  const location = process.env.TICKETS_SECRET_KEY_FILE || path.join(__dirname, '..', 'data', 'smtp.key');
  try {
    if (!fs.existsSync(location)) {
      fs.mkdirSync(path.dirname(location), { recursive: true });
      fs.writeFileSync(location, crypto.randomBytes(32), { flag: 'wx', mode: 0o600 });
    }
    key = fs.readFileSync(location);
  } catch (_) {
    key = crypto.randomBytes(32);
  }
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

function migrateSecrets() {
  const rows = orm
    .select({ id: schema.configuracionEmpresa.id, smtpPass: schema.configuracionEmpresa.smtpPass })
    .from(schema.configuracionEmpresa)
    .all();
  for (const row of rows) {
    if (row.smtpPass && !row.smtpPass.startsWith('enc:')) {
      orm
        .update(schema.configuracionEmpresa)
        .set({ smtpPass: encrypt(row.smtpPass) })
        .where(eq(schema.configuracionEmpresa.id, row.id))
        .run();
    }
  }
}

module.exports = { encrypt, decrypt, migrateSecrets };
