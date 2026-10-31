const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');

test('Admin puede eliminar órdenes sin borrar el cliente ni el equipo', async () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'santi-delete-test-'));
  const dbPath = path.join(tmpDir, 'test.sqlite');
  process.env.TICKETS_DB_PATH = dbPath;

  delete require.cache[require.resolve('../db')];
  delete require.cache[require.resolve('../orm')];
  delete require.cache[require.resolve('../orm/schema')];
  delete require.cache[require.resolve('../security')];
  delete require.cache[require.resolve('../app')];

  const app = require('../app');
  const server = app.listen(0);
  const port = server.address().port;
  const baseUrl = `http://127.0.0.1:${port}`;

  try {
    // 1. Setup inicial con Admin y Técnico
    const setupRes = await fetch(`${baseUrl}/api/setup`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        empresa: { nombreEmpresa: 'Test Inc' },
        admin: {
          nombre: 'Admin Boss',
          email: 'admin@test.com',
          password: 'Password123!',
          documento: '1001',
          telefono: '3001112233',
        },
        tecnico: {
          nombre: 'Tecnico One',
          email: 'tecnico@test.com',
          password: 'Password123!',
          documento: '2001',
          telefono: '3004445566',
        },
      }),
    });
    assert.equal(setupRes.status, 200);

    // 2. Login Admin y Login Técnico
    const adminLogin = await (
      await fetch(`${baseUrl}/api/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: 'admin@test.com', password: 'Password123!' }),
      })
    ).json();
    const adminToken = adminLogin.token;

    const tecLogin = await (
      await fetch(`${baseUrl}/api/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: 'tecnico@test.com', password: 'Password123!' }),
      })
    ).json();
    const tecToken = tecLogin.token;

    // 3. Crear Orden con Cliente y Equipo
    const createOrderRes = await (
      await fetch(`${baseUrl}/api/ordenes`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${adminToken}`,
        },
        body: JSON.stringify({
          cliente: {
            tipoDocumento: 'CC',
            numeroDocumento: '12345678',
            nombreCompleto: 'Cliente Juan Perez',
            telefono: '3109876543',
            direccion: 'Calle 10 # 20-30',
          },
          equipo: {
            tipoEquipo: 'PORTATIL',
            marca: 'Dell',
            modelo: 'Latitude 5420',
            numeroSerie: 'SN-TEST-9988',
          },
          orden: {
            titulo: 'Mantenimiento Preventivo',
            descripcion: 'Limpieza interna y cambio de pasta térmica',
            tipoServicio: 'PREVENTIVO',
            categoriaFalla: 'MANTENIMIENTO',
            prioridad: 'MEDIA',
          },
        }),
      })
    ).json();
    if (!createOrderRes.success) {
      console.log('CREATE ORDER ERROR:', createOrderRes);
    }
    assert.equal(createOrderRes.success, true);
    const ordenId = createOrderRes.ordenId;
    assert.ok(ordenId > 0);

    // 4. Agregar formatos hijos (OT y Actividades)
    const otResRaw = await fetch(`${baseUrl}/api/ordenes/${ordenId}/ot`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${adminToken}`,
      },
      body: JSON.stringify({
        diagnosticoPreliminar: 'Equipo con pasta seca',
        herramientasChips: [],
        tiempoEstimadoEntrega: '24 horas',
      }),
    });
    const otRes = await otResRaw.json();
    if (!otRes.success) {
      console.log('OT FAIL:', otResRaw.status, otRes);
    }
    assert.equal(otRes.success, true);

    // 5. El técnico intenta eliminar la orden -> Debe ser rechazada con 403
    const tecDeleteRes = await fetch(`${baseUrl}/api/ordenes/${ordenId}`, {
      method: 'DELETE',
      headers: {
        Authorization: `Bearer ${tecToken}`,
      },
    });
    assert.equal(tecDeleteRes.status, 403);

    // 6. El Admin elimina la orden -> Debe ser exitoso
    const adminDeleteRes = await fetch(`${baseUrl}/api/ordenes/${ordenId}`, {
      method: 'DELETE',
      headers: {
        Authorization: `Bearer ${adminToken}`,
      },
    });
    assert.equal(adminDeleteRes.status, 200);
    const adminDeleteJson = await adminDeleteRes.json();
    assert.equal(adminDeleteJson.success, true);

    // 7. Verificar que la orden ya no existe (404)
    const getOrderRes = await fetch(`${baseUrl}/api/ordenes/${ordenId}`, {
      headers: { Authorization: `Bearer ${adminToken}` },
    });
    assert.equal(getOrderRes.status, 404);

    // 8. Verificar que el CLIENTE y el EQUIPO SIGUEN EXISTIENDO
    const db = require('../db');
    const clienteEnDb = db.prepare('SELECT * FROM clientes WHERE numero_documento = ?').get('12345678');
    assert.ok(clienteEnDb, 'El cliente debe seguir existiendo intacto');
    assert.equal(clienteEnDb.nombre_completo, 'Cliente Juan Perez');

    const equipoEnDb = db.prepare('SELECT * FROM equipos WHERE numero_serie = ?').get('SN-TEST-9988');
    assert.ok(equipoEnDb, 'El equipo debe seguir existiendo intacto');
    assert.equal(equipoEnDb.modelo, 'Latitude 5420');

    // 9. Verificar que los registros hijos de la orden fueron limpiados
    const otEnDb = db.prepare('SELECT * FROM formato_ot WHERE orden_id = ?').get(ordenId);
    assert.equal(otEnDb, undefined, 'El formato OT de la orden eliminada no debe existir');
  } finally {
    server.close();
    delete process.env.TICKETS_DB_PATH;
    try {
      fs.rmSync(tmpDir, { recursive: true, force: true });
    } catch (_) {}
  }
});
