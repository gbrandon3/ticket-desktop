const { test, before, after } = require('node:test');
const assert = require('node:assert/strict');
process.env.TICKETS_DB_PATH = ':memory:';
const app = require('../app');
const db = require('../db');
const { verifyPassword } = require('../security');
let server, base, adminToken, technicianToken, orderId;

async function request(path, method = 'GET', body, token) {
  const response = await fetch(base + '/api' + path, {
    method,
    headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  return { status: response.status, body: await response.json() };
}

before(async () => {
  server = app.listen(0);
  await new Promise(resolve => server.once('listening', resolve));
  base = `http://127.0.0.1:${server.address().port}`;
});
after(async () => { await new Promise(resolve => server.close(resolve)); db.close(); });

test('API: configuración, sesiones, permisos, persistencia y cierre', async () => {
  assert.equal((await request('/usuarios')).status, 401);
  const account = { nombre: 'Admin', email: 'admin@test.com', password: 'correct-password', documento: '', telefono: '' };
  assert.equal((await request('/setup', 'POST', {
    empresa: { nombreEmpresa: 'Test' }, admin: account,
    tecnico: { ...account, email: 'technician@test.com' },
  })).status, 200);
  assert.equal((await request('/setup', 'POST', { empresa: {}, admin: account })).status, 409);
  const stored = db.prepare('SELECT password FROM usuarios WHERE email = ?').get(account.email).password;
  assert.ok(stored.startsWith('scrypt:'));
  assert.ok(verifyPassword(account.password, stored));
  const login = await request('/auth/login', 'POST', { email: account.email, password: account.password });
  assert.equal(login.status, 200);
  assert.equal(login.body.usuario.password, undefined);
  adminToken = login.body.token;
  assert.equal((await request('/auth/login', 'POST', { email: account.email, password: 'wrong-password' })).status, 401);
  await request('/config', 'POST', { smtpUser: 'mail@test.com', smtpPass: 'smtp-secret' }, adminToken);
  assert.ok(db.prepare('SELECT smtp_pass FROM configuracion_empresa').get().smtp_pass.startsWith('enc:'));
  assert.equal((await request('/config', 'GET', null, adminToken)).body.data.smtpPass, '********');
  assert.notEqual((await request('/config')).body.data.smtpUser, 'mail@test.com');
  await request('/config', 'POST', { smtpPass: '********' }, adminToken);
  assert.equal(require('../secrets').decrypt(db.prepare('SELECT smtp_pass FROM configuracion_empresa').get().smtp_pass), 'smtp-secret');
  technicianToken = (await request('/auth/login', 'POST', { email: 'technician@test.com', password: account.password })).body.token;
  assert.equal((await request('/config', 'POST', {}, technicianToken)).status, 403);
  assert.equal((await request('/usuarios', 'POST', { ...account, email: 'new@test.com', rol: 'admin' }, technicianToken)).status, 403);
  assert.equal((await request('/usuarios/2', 'PUT', { ...account, email: 'technician@test.com', rol: 'admin', currentPassword: 'incorrect' }, technicianToken)).status, 403);
  assert.equal((await request('/usuarios/2', 'PUT', { ...account, email: 'technician@test.com', rol: 'admin', password: '', activo: true }, technicianToken)).status, 200);
  assert.equal(db.prepare('SELECT rol FROM usuarios WHERE id = 2').get().rol, 'tecnico');
  const payload = {
    cliente: { tipoDocumento: 'CC', numeroDocumento: '123', nombreCompleto: 'Client', telefono: '123', direccion: 'Street' },
    equipo: { tipoEquipo: 'PORTATIL', marca: 'Test', modelo: 'Test', numeroSerie: 'S123' },
    orden: { codigoOrden: 'ORD-TEST123', tipoServicio: 'PREVENTIVO', categoriaFalla: 'HARDWARE', prioridad: 'MEDIA', titulo: 'Test', descripcion: 'Test', fechaIngreso: new Date().toISOString() },
  };
  assert.equal((await request('/ordenes', 'POST', payload, technicianToken)).status, 403);
  const created = await request('/ordenes', 'POST', payload, adminToken);
  assert.equal(created.status, 200);
  orderId = created.body.ordenId;
  assert.match(created.body.codigoOrden, /^ORD-\d{4}-\d+-[A-F0-9]{32}$/);
  assert.equal((await request('/ordenes', 'POST', payload, adminToken)).status, 409);
  assert.equal((await request('/ordenes', 'POST', { ...payload, cliente: { ...payload.cliente, numeroDocumento: 'other', nombreCompleto: 'Other' } }, adminToken)).status, 409);
  assert.equal(db.prepare('SELECT COUNT(*) AS c FROM clientes').get().c, 1);
  assert.equal((await request(`/ordenes/${orderId}/actividades`, 'POST', { procedimientosRealizados: 'Trabajo', costoManoObra: -100 }, adminToken)).status, 400);
  assert.equal((await request(`/ordenes/${orderId}/ot`, 'POST', { diagnosticoPreliminar: '' }, adminToken)).status, 400);
  assert.equal((await request('/ordenes', 'GET', null, technicianToken)).body.data.length, 0);
  assert.equal((await request(`/ordenes/${orderId}/tecnico`, 'PUT', { tecnicoId: 2 }, technicianToken)).status, 403);
  assert.equal((await request(`/ordenes/${orderId}/estado`, 'PUT', { nuevoEstado: 'LISTO_ENTREGA' }, adminToken)).status, 409);
  for (const nuevoEstado of ['EN_DIAGNOSTICO', 'EN_TALLER', 'LISTO_ENTREGA']) {
    assert.equal((await request(`/ordenes/${orderId}/estado`, 'PUT', { nuevoEstado }, adminToken)).status, 200);
  }
  const acta = { personaRecibeNombre: 'Client', personaRecibeDocumento: '123', checkConformidad: true };
  assert.equal((await request(`/ordenes/${orderId}/acta`, 'POST', acta, adminToken)).status, 409);
  assert.equal((await request(`/ordenes/${orderId}/ot`, 'POST', { diagnosticoPreliminar: 'Diagnóstico', estadoCarcasa: 'Bien', pinContrasena: '' }, adminToken)).status, 200);
  const photoUpload = await request(`/ordenes/${orderId}/fotos`, 'POST', {
    etapa: 'RECEPCION',
    rutaOBytesBase64: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
    notaTecnica: 'Evidencia inicial'
  }, adminToken);
  assert.equal(photoUpload.status, 200);
  assert.ok(photoUpload.body.ruta && photoUpload.body.ruta.startsWith('/uploads/'));
  const staticPhoto = await fetch(base + photoUpload.body.ruta);
  assert.equal(staticPhoto.status, 200);
  assert.equal((await request(`/fotos/${photoUpload.body.id}`, 'DELETE', null, adminToken)).status, 200);
  assert.equal((await request(`/ordenes/${orderId}/acta`, 'POST', acta, adminToken)).status, 409);
  assert.equal((await request(`/ordenes/${orderId}/actividades`, 'POST', { procedimientosRealizados: 'Limpieza y pruebas', costoManoObra: 100 }, adminToken)).status, 200);
  assert.equal((await request(`/ordenes/${orderId}/acta`, 'POST', {
    personaRecibeNombre: 'Client', personaRecibeDocumento: '123', checkConformidad: true,
  }, adminToken)).status, 200);
  assert.equal(db.prepare('SELECT estado_equipo FROM equipos WHERE id = (SELECT equipo_id FROM ordenes WHERE id = ?)').get(orderId).estado_equipo, 'OPERATIVO');
  assert.equal((await request(`/ordenes/${orderId}/ot`, 'POST', {}, adminToken)).status, 409);
  assert.equal((await request('/consulta-publica?q=TEST')).body.data.tipo, 'no_encontrado');
  assert.equal((await request('/consulta-publica?q=123')).body.data.tipo, 'no_encontrado');
  const publicOrder = await request('/consulta-publica?q=' + created.body.codigoOrden);
  assert.equal(publicOrder.body.data.tipo, 'ticket');
  assert.equal(publicOrder.body.data.orden.cliente, null);
  assert.equal(publicOrder.body.data.formatoOt?.pinContrasena, undefined);
  const history = await request('/historial-cambios', 'GET', null, adminToken);
  assert.equal(history.status, 200);
  assert.ok(history.body.data.some(row => row.ruta === `/api/ordenes/${orderId}/acta`));
  assert.ok(history.body.data.every(row => row.usuarioNombre === 'Admin'));
  assert.equal((await request('/historial-cambios', 'GET', null, technicianToken)).status, 403);
  const auditCount = db.prepare('SELECT COUNT(*) AS count FROM auditoria_cambios').get().count;
  // A failed insert must roll back the preceding client update.
  payload.cliente.nombreCompleto = 'Must roll back';
  payload.orden.tecnicoId = 99999;
  assert.equal((await request('/ordenes', 'POST', payload, adminToken)).status, 500);
  assert.equal(db.prepare('SELECT nombre_completo FROM clientes WHERE numero_documento = ?').get('123').nombre_completo, 'Client');
  assert.equal(db.prepare('SELECT COUNT(*) AS count FROM auditoria_cambios').get().count, auditCount);
  await request('/auth/logout', 'POST', {}, adminToken);
  assert.equal((await request('/usuarios', 'GET', null, adminToken)).status, 401);
});
