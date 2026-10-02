const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { execFileSync } = require('node:child_process');
const { DatabaseSync } = require('node:sqlite');
process.env.TICKETS_DB_PATH = ':memory:';
const { encrypt, decrypt } = require('../secrets');

test('SMTP: cifrado autenticado y detección de alteraciones', () => {
  const encrypted = encrypt('smtp-password');
  assert.notEqual(encrypted, 'smtp-password');
  assert.equal(decrypt(encrypted), 'smtp-password');
  const parts = encrypted.split(':');
  parts[2] = '0'.repeat(32);
  assert.throws(() => decrypt(parts.join(':')));
});

test('Respaldo: snapshot consistente y apertura restaurada', () => {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'santi-backup-test-'));
  const source = path.join(directory, 'source.sqlite');
  const backups = path.join(directory, 'backups');
  const keyFile = path.join(directory, 'smtp.key');
  fs.writeFileSync(keyFile, Buffer.alloc(32, 7));
  const db = new DatabaseSync(source);
  try {
    db.exec("PRAGMA journal_mode = WAL; CREATE TABLE sample (value TEXT); INSERT INTO sample VALUES ('persisted');");
    execFileSync(process.execPath, [path.join(__dirname, '..', 'backup.js')], {
      env: { ...process.env, TICKETS_DB_PATH: source, TICKETS_BACKUP_DIR: backups, TICKETS_SECRET_KEY_FILE: keyFile },
    });
    const copy = path.join(backups, fs.readdirSync(backups).find(name => name.endsWith('.sqlite')));
    assert.deepEqual(fs.readFileSync(copy + '.key'), fs.readFileSync(keyFile));
    const restored = new DatabaseSync(copy);
    try {
      assert.equal(restored.prepare('SELECT value FROM sample').get().value, 'persisted');
      assert.equal(restored.prepare('PRAGMA integrity_check').get().integrity_check, 'ok');
    } finally { restored.close(); }
    fs.unlinkSync(copy);
    fs.unlinkSync(copy + '.key');
  } finally {
    db.close();
    fs.unlinkSync(keyFile);
    for (const suffix of ['', '-wal', '-shm']) {
      if (fs.existsSync(source + suffix)) fs.unlinkSync(source + suffix);
    }
    if (fs.existsSync(backups)) fs.rmdirSync(backups);
    fs.rmdirSync(directory);
  }
});

test('Respaldo automático: al iniciar, repetición y parada', async () => {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'santi-schedule-test-'));
  const source = path.join(directory, 'source.sqlite');
  const backups = path.join(directory, 'backups');
  const db = new DatabaseSync(source);
  db.exec('CREATE TABLE sample (value TEXT)');
  db.close();
  const saved = { ...process.env };
  let stop;
  try {
    process.env.TICKETS_DB_PATH = source;
    process.env.TICKETS_BACKUP_DIR = backups;
    process.env.TICKETS_SECRET_KEY_FILE = path.join(directory, 'nonexistent.key');
    process.env.BACKUP_INTERVAL_HOURS = '0.00002';
    const scheduler = require('../backup-scheduler');
    stop = scheduler.startBackupSchedule();
    assert.equal(scheduler.status.enabled, true);
    await new Promise(resolve => setTimeout(resolve, 180));
    stop();
    const count = fs.readdirSync(backups).length;
    assert.ok(count >= 2);
    await new Promise(resolve => setTimeout(resolve, 100));
    assert.equal(fs.readdirSync(backups).length, count);
  } finally {
    stop?.();
    for (const key of ['TICKETS_DB_PATH', 'TICKETS_BACKUP_DIR', 'TICKETS_SECRET_KEY_FILE', 'BACKUP_INTERVAL_HOURS']) {
      if (saved[key] === undefined) delete process.env[key]; else process.env[key] = saved[key];
    }
    if (fs.existsSync(backups)) {
      for (const file of fs.readdirSync(backups)) fs.unlinkSync(path.join(backups, file));
      fs.rmdirSync(backups);
    }
    fs.unlinkSync(source);
    fs.rmdirSync(directory);
  }
});
