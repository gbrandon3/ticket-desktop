const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { DatabaseSync } = require('node:sqlite');

test('API de respaldo: descarga autenticada y restauración de usuarios y SMTP', async () => {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'santi-recovery-test-'));
  process.env.TICKETS_DB_PATH = path.join(directory, 'source.sqlite');
  process.env.TICKETS_BACKUP_DIR = path.join(directory, 'backups');
  process.env.TICKETS_SECRET_KEY_FILE = path.join(directory, 'smtp.key');
  const app = require('../app');
  const db = require('../db');
  const server = app.listen(0);
  await new Promise(resolve => server.once('listening', resolve));
  const base = `http://127.0.0.1:${server.address().port}/api`;
  const post = (route, body, token) => fetch(base + route, { method: 'POST',
    headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
    body: JSON.stringify(body),
  });
  try {
    await post('/setup', { empresa: { nombreEmpresa: 'Demostración' },
      admin: { nombre: 'Demo', email: 'demo@example.com', password: 'demo-password' } });
    const login = await (await post('/auth/login', { email: 'demo@example.com', password: 'demo-password' })).json();
    const token = login.token;
    assert.ok(token);
    await post('/config', { nombreEmpresa: 'Empresa de prueba', smtpUser: 'smtp@example.com', smtpPass: 'smtp-demo-password' }, token);
    const download = await post('/backups', {}, token);
    assert.equal(download.status, 200);
    const bytes = Buffer.from(await download.arrayBuffer());
    assert.equal(bytes.subarray(0, 15).toString(), 'SQLite format 3');
    const copy = path.join(directory, 'restored.sqlite');
    fs.writeFileSync(copy, bytes);
    const restored = new DatabaseSync(copy);
    try {
      assert.ok(require('../security').verifyPassword('demo-password', restored.prepare('SELECT password FROM usuarios').get().password));
      const config = restored.prepare('SELECT nombre_empresa, smtp_pass FROM configuracion_empresa').get();
      assert.equal(config.nombre_empresa, 'Empresa de prueba');
      assert.equal(require('../secrets').decrypt(config.smtp_pass), 'smtp-demo-password');
      assert.equal(restored.prepare('PRAGMA integrity_check').get().integrity_check, 'ok');
    } finally { restored.close(); }
    const files = fs.readdirSync(process.env.TICKETS_BACKUP_DIR);
    assert.ok(files.some(name => name.endsWith('.sqlite.key')));
    const history = await (await fetch(base + '/historial-cambios', { headers: { Authorization: `Bearer ${token}` } })).json();
    assert.ok(history.data.some(row => row.ruta === '/api/backups'));
  } finally {
    await new Promise(resolve => server.close(resolve));
    db.close();
    for (const folder of [process.env.TICKETS_BACKUP_DIR, directory]) {
      if (!fs.existsSync(folder)) continue;
      for (const file of fs.readdirSync(folder, { withFileTypes: true })) {
        if (file.isFile()) fs.unlinkSync(path.join(folder, file.name));
      }
    }
    if (fs.existsSync(process.env.TICKETS_BACKUP_DIR)) fs.rmdirSync(process.env.TICKETS_BACKUP_DIR);
    fs.rmdirSync(directory);
  }
});
