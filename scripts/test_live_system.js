const https = require('https');

const BASE_URL = 'https://ticket-desktop.vercel.app';

function request(method, path, body = null, headers = {}) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, BASE_URL);
    const reqHeaders = { ...headers };
    let reqBody = null;
    if (body) {
      reqBody = typeof body === 'string' ? body : JSON.stringify(body);
      reqHeaders['Content-Type'] = 'application/json';
      reqHeaders['Content-Length'] = Buffer.byteLength(reqBody);
    }
    const options = {
      hostname: url.hostname,
      port: 443,
      path: url.pathname + url.search,
      method: method,
      headers: reqHeaders,
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', chunk => { data += chunk; });
      res.on('end', () => {
        let json = null;
        try {
          json = JSON.parse(data);
        } catch (_) {}
        resolve({
          statusCode: res.statusCode,
          headers: res.headers,
          raw: data,
          json: json
        });
      });
    });

    req.on('error', reject);
    if (reqBody) req.write(reqBody);
    req.end();
  });
}

async function runTests() {
  console.log('====================================================');
  console.log('🚀 INICIANDO VERIFICACIÓN COMPLETA DE ticket-desktop');
  console.log('====================================================\n');

  let passes = 0;
  let fails = 0;

  function assert(condition, message, detail = '') {
    if (condition) {
      console.log(`  ✅ [PASS] ${message}`);
      passes++;
    } else {
      console.error(`  ❌ [FAIL] ${message} - ${detail}`);
      fails++;
    }
  }

  // 1. Static Assets & Fonts
  console.log('--- 1. Recursos Estáticos y Fuentes de Flutter Web ---');
  const indexRes = await request('GET', '/');
  assert(indexRes.statusCode === 200 && indexRes.raw.includes('<!DOCTYPE html>'), 'GET / (index.html carga correctamente)');

  const fontManifestRes = await request('GET', '/assets/FontManifest.json');
  assert(fontManifestRes.statusCode === 200 && fontManifestRes.raw.includes('MaterialIcons'), 'GET /assets/FontManifest.json accesible');

  const materialFontRes = await request('GET', '/assets/fonts/MaterialIcons-Regular.otf');
  assert(materialFontRes.statusCode === 200 && parseInt(materialFontRes.headers['content-length'] || '0') > 10000, 'GET /assets/fonts/MaterialIcons-Regular.otf (Fuentes Material cargadas)');

  const cupertinoFontRes = await request('GET', '/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf');
  assert(cupertinoFontRes.statusCode === 200 && parseInt(cupertinoFontRes.headers['content-length'] || '0') > 1000, 'GET /assets/packages/cupertino_icons/assets/CupertinoIcons.ttf (Fuentes Cupertino cargadas)');

  // 2. Authentication
  console.log('\n--- 2. Autenticación y Cuentas del Sistema ---');
  let adminToken = null;
  let adminUser = null;

  const adminLogin = await request('POST', '/api/auth/login', {
    email: 'matiasojeda1803@gmail.com',
    password: 'admin123'
  });
  assert(adminLogin.statusCode === 200 && adminLogin.json?.success === true && adminLogin.json?.usuario?.rol === 'admin', 'Login Administrador (matiasojeda1803@gmail.com)');
  if (adminLogin.json?.success) {
    adminToken = adminLogin.json.token;
    adminUser = adminLogin.json.usuario;
  }

  const operadorLogin = await request('POST', '/api/auth/login', {
    email: 'lunapalmera@gmail.com',
    password: 'admin123'
  });
  assert(operadorLogin.statusCode === 200 && operadorLogin.json?.success === true && operadorLogin.json?.usuario?.rol === 'solicitante', 'Login Solicitante/Operador (lunapalmera@gmail.com)');

  const tecnicoLogin = await request('POST', '/api/auth/login', {
    email: 'quitana16@gmail.com',
    password: 'admin123'
  });
  assert(tecnicoLogin.statusCode === 200 && tecnicoLogin.json?.success === true && tecnicoLogin.json?.usuario?.rol === 'tecnico', 'Login Técnico (quitana16@gmail.com)');

  const badLogin = await request('POST', '/api/auth/login', {
    email: 'matiasojeda1803@gmail.com',
    password: 'clave_erronea_para_probar'
  });
  assert(badLogin.statusCode === 401 && badLogin.json?.success === false, 'Rechazo controlado de credenciales incorrectas (401)');

  const authHeader = { 'Authorization': `Bearer ${adminToken}` };

  // 3. System Configuration
  console.log('\n--- 3. Configuración de Empresa (Santi Inc) ---');
  const configRes = await request('GET', '/api/config', null, authHeader);
  assert(configRes.statusCode === 200 && configRes.json?.success === true, 'GET /api/config');
  const config = configRes.json?.data || configRes.json?.empresa || {};
  assert((config.nombre || config.nombreEmpresa || '').toLowerCase().includes('santi'), `Empresa registrada: ${config.nombre || config.nombreEmpresa}`);

  // 4. Users list
  console.log('\n--- 4. Usuarios del Sistema ---');
  const usersRes = await request('GET', '/api/usuarios', null, authHeader);
  assert(usersRes.statusCode === 200 && Array.isArray(usersRes.json?.data) && usersRes.json.data.length >= 3, `Listado de usuarios activo (${usersRes.json?.data?.length} usuarios)`);

  // 5. Clientes
  console.log('\n--- 5. Clientes ---');
  const testDoc = 'TEST-' + Math.floor(Math.random() * 1000000);
  const newClientRes = await request('POST', '/api/clientes', {
    nombreCompleto: 'Juan David Pérez',
    tipoDocumento: 'CC',
    numeroDocumento: testDoc,
    telefono: '3001234567',
    email: 'cliente_prueba@santiinc.com',
    direccion: 'Carrera 5 # 40-20, Montería'
  }, authHeader);
  assert(newClientRes.statusCode === 200 && newClientRes.json?.success === true, 'POST /api/clientes (Registro/actualización de cliente)');
  const clientId = newClientRes.json?.data?.id;

  const clientsList = await request('GET', '/api/clientes', null, authHeader);
  assert(clientsList.statusCode === 200 && Array.isArray(clientsList.json?.data), `GET /api/clientes (${clientsList.json?.data?.length} clientes encontrados)`);

  // 6. Equipos del cliente
  console.log('\n--- 6. Consulta de Equipos ---');
  const equipListRes = await request('GET', `/api/clientes/${clientId}/equipos`, null, authHeader);
  assert(equipListRes.statusCode === 200 && Array.isArray(equipListRes.json?.data), 'GET /api/clientes/:id/equipos');

  // 7. Órdenes / Tickets (Creación integral como Flutter)
  console.log('\n--- 7. Flujo Completo de Órdenes / Tickets ---');
  const randomSerial = 'SN-' + Date.now().toString(36).toUpperCase();
  const orderCode = 'OT-' + Date.now().toString().slice(-6);

  const newOrderPayload = {
    cliente: {
      tipoDocumento: 'CC',
      numeroDocumento: testDoc,
      nombreCompleto: 'Juan David Pérez',
      telefono: '3001234567',
      email: 'cliente_prueba@santiinc.com',
      direccion: 'Carrera 5 # 40-20, Montería'
    },
    equipo: {
      tipoEquipo: 'PORTATIL',
      marca: 'ASUS',
      modelo: 'ZenBook 14',
      numeroSerie: randomSerial,
      sistemaOperativo: 'Windows 11 Pro',
      procesador: 'Intel Core i7 12va Gen',
      memoriaRam: '16GB',
      almacenamiento: '512GB NVMe SSD',
      tarjetaGrafica: 'Intel Iris Xe'
    },
    orden: {
      codigoOrden: orderCode,
      tecnicoId: 3, // Santiago Quintana
      solicitanteId: adminUser?.id || 1,
      tipoServicio: 'REPARACION',
      categoriaFalla: 'HARDWARE',
      prioridad: 'ALTA',
      titulo: 'Fallo en teclado y ventilador ruidoso',
      descripcion: 'El equipo se recalienta a los 10 minutos de encendido y la tecla ESPACIO no responde.',
      estado: 'RECIBIDO'
    }
  };

  const createOrderRes = await request('POST', '/api/ordenes', newOrderPayload, authHeader);
  const orderId = createOrderRes.json?.ordenId;
  const actualOrderCode = createOrderRes.json?.codigoOrden || orderCode;
  assert(createOrderRes.statusCode === 200 && createOrderRes.json?.success === true && orderId, `POST /api/ordenes (Ticket creado: ${actualOrderCode}, ID: ${orderId})`);

  const ordersListRes = await request('GET', '/api/ordenes', null, authHeader);
  assert(ordersListRes.statusCode === 200 && Array.isArray(ordersListRes.json?.data) && ordersListRes.json.data.length > 0, `GET /api/ordenes (${ordersListRes.json?.data?.length} órdenes listadas)`);

  if (orderId) {
    // Detalle de la orden
    const getOrderRes = await request('GET', `/api/ordenes/${orderId}`, null, authHeader);
    assert(getOrderRes.statusCode === 200 && getOrderRes.json?.data?.id === orderId, `GET /api/ordenes/${orderId} (Detalle de la orden)`);

    // Actualizar estado de la orden
    const updateEstadoRes = await request('PUT', `/api/ordenes/${orderId}/estado`, {
      nuevoEstado: 'EN_DIAGNOSTICO',
      notas: 'Revisión técnica en banco de trabajo por técnico asignado'
    }, authHeader);
    assert(updateEstadoRes.statusCode === 200 && updateEstadoRes.json?.success === true, `PUT /api/ordenes/${orderId}/estado (Cambio a EN_DIAGNOSTICO)`);

    // 8. Taller: Formato OT, Actividades, Repuestos, Fotos, Acta
    console.log('\n--- 8. Taller: OT, Actividades, Repuestos y Acta ---');
    const otGetRes = await request('GET', `/api/ordenes/${orderId}/ot`, null, authHeader);
    assert(otGetRes.statusCode === 200 && otGetRes.json?.success === true, `GET /api/ordenes/${orderId}/ot (Formato OT)`);

    const actGetRes = await request('GET', `/api/ordenes/${orderId}/actividades`, null, authHeader);
    assert(actGetRes.statusCode === 200 && actGetRes.json?.success === true, `GET /api/ordenes/${orderId}/actividades`);

    const repGetRes = await request('GET', `/api/ordenes/${orderId}/repuestos`, null, authHeader);
    assert(repGetRes.statusCode === 200 && Array.isArray(repGetRes.json?.data), `GET /api/ordenes/${orderId}/repuestos`);

    const fotosGetRes = await request('GET', `/api/ordenes/${orderId}/fotos`, null, authHeader);
    assert(fotosGetRes.statusCode === 200 && Array.isArray(fotosGetRes.json?.data), `GET /api/ordenes/${orderId}/fotos`);

    const actaGetRes = await request('GET', `/api/ordenes/${orderId}/acta`, null, authHeader);
    assert(actaGetRes.statusCode === 200 && actaGetRes.json?.success === true, `GET /api/ordenes/${orderId}/acta`);
  }

  // 9. Catálogo de Fallas
  console.log('\n--- 9. Catálogos y Auditoría ---');
  const catalogRes = await request('GET', '/api/tipos-falla', null, authHeader);
  assert(catalogRes.statusCode === 200 && Array.isArray(catalogRes.json?.data), `GET /api/tipos-falla (${catalogRes.json?.data?.length || 0} tipos de fallas)`);

  const auditRes = await request('GET', '/api/auditoria', null, authHeader);
  assert(auditRes.statusCode === 200 && Array.isArray(auditRes.json?.data), `GET /api/auditoria (${auditRes.json?.data?.length || 0} eventos de auditoría)`);

  // 10. Consulta Pública de Seguimiento
  console.log('\n--- 10. Consulta Pública de Clientes ---');
  const queryCode = actualOrderCode;
  const publicRes = await request('GET', `/api/consulta-publica?q=${encodeURIComponent(queryCode)}`);
  assert(publicRes.statusCode === 200 && publicRes.json?.success === true && publicRes.json?.data?.orden?.codigoOrden === queryCode, `Consulta pública en tiempo real de la orden (${queryCode})`);

  // 11. Dashboards y Métricas
  console.log('\n--- 11. Métricas y SLA ---');
  const dashRes = await request('GET', '/api/metrics/dashboard', null, authHeader);
  assert(dashRes.statusCode === 200 && dashRes.json?.success === true, 'GET /api/metrics/dashboard');

  const adminMetricsRes = await request('GET', '/api/metrics/admin', null, authHeader);
  assert(adminMetricsRes.statusCode === 200 && adminMetricsRes.json?.success === true, 'GET /api/metrics/admin');

  console.log('\n====================================================');
  console.log(`🎉 RESULTADOS FINALES: ${passes} pruebas exitosas, ${fails} pruebas fallidas.`);
  console.log('====================================================');

  if (fails > 0) {
    process.exit(1);
  }
}

runTests().catch(err => {
  console.error('Error durante la ejecución del test suite:', err);
  process.exit(1);
});
