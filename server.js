const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const db = require('./server/db');
const emailHandler = require('./api/send-email');

const app = express();
const PORT = process.env.PORT || 3000;

// Configuración de middlewares
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Helper para convertir booleano a entero (0/1) y viceversa
const toBool = val => Boolean(val === 1 || val === true || val === 'true');
const toInt = val => (val ? 1 : 0);

// ==========================================
// 1. CONFIGURACIÓN Y ASISTENTE (SETUP)
// ==========================================

function getEmpresaConfig() {
  const row = db.prepare('SELECT * FROM configuracion_empresa ORDER BY id ASC LIMIT 1').get();
  if (!row) return null;
  return {
    id: row.id,
    nombreEmpresa: row.nombre_empresa,
    slogan: row.slogan,
    nit: row.nit,
    telefono: row.telefono,
    email: row.email,
    direccion: row.direccion,
    ciudad: row.ciudad,
    logoBase64: row.logo_base64,
    smtpHost: row.smtp_host,
    smtpPort: row.smtp_port,
    smtpUser: row.smtp_user,
    smtpPass: row.smtp_pass,
    smtpApiUrl: row.smtp_api_url,
    portalHostUrl: row.portal_host_url,
    colorPrimario: row.color_primario,
    colorSecundario: row.color_secundario,
    isSetupCompleted: toBool(row.is_setup_completed),
  };
}

app.get('/api/config', (req, res) => {
  try {
    const config = getEmpresaConfig();
    res.json({ success: true, data: config });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/config', (req, res) => {
  try {
    const b = req.body;
    let row = db.prepare('SELECT id FROM configuracion_empresa ORDER BY id ASC LIMIT 1').get();
    if (!row) {
      db.prepare(`
        INSERT INTO configuracion_empresa (
          nombre_empresa, portal_host_url, is_setup_completed
        ) VALUES ('Santi Inc', 'http://localhost:3000', 0)
      `).run();
      row = db.prepare('SELECT id FROM configuracion_empresa ORDER BY id ASC LIMIT 1').get();
    }
    db.prepare(`
      UPDATE configuracion_empresa SET
        nombre_empresa = ?, slogan = ?, nit = ?, telefono = ?, email = ?,
        direccion = ?, ciudad = ?, logo_base64 = ?, smtp_host = ?,
        smtp_port = ?, smtp_user = ?, smtp_pass = ?, smtp_api_url = ?,
        portal_host_url = ?, color_primario = ?, color_secundario = ?
      WHERE id = ?
    `).run(
      b.nombreEmpresa || 'Santi Inc',
      b.slogan || null,
      b.nit || null,
      b.telefono || null,
      b.email || null,
      b.direccion || null,
      b.ciudad || null,
      b.logoBase64 || null,
      b.smtpHost || 'smtp.gmail.com',
      b.smtpPort ? parseInt(b.smtpPort, 10) : 465,
      b.smtpUser || null,
      b.smtpPass || null,
      b.smtpApiUrl || null,
      b.portalHostUrl || 'http://localhost:3000',
      b.colorPrimario || '#0F172A',
      b.colorSecundario || '#0284C7',
      row.id
    );
    res.json({ success: true, message: 'Configuración actualizada con éxito' });
  } catch (err) {
    console.error('Error actualizando configuracion_empresa:', err);
    res.status(500).json({ success: false, error: err.message });
  }
});

app.get('/api/setup/status', (req, res) => {
  try {
    const config = getEmpresaConfig();
    res.json({ success: true, isSetupCompleted: config ? config.isSetupCompleted : false, empresa: config });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/setup', (req, res) => {
  try {
    const { empresa, admin, operador, tecnico } = req.body;
    if (!admin || !admin.email || !admin.password) {
      return res.status(400).json({ success: false, error: 'Credenciales del administrador incompletas' });
    }

    // 1. Actualizar configuración de la empresa y marcar is_setup_completed = 1
    db.prepare(`
      UPDATE configuracion_empresa SET
        nombre_empresa = ?, nit = ?, telefono = ?, email = ?,
        direccion = ?, ciudad = ?, is_setup_completed = 1
      WHERE id = (SELECT id FROM configuracion_empresa ORDER BY id ASC LIMIT 1)
    `).run(
      empresa.nombreEmpresa || 'Santi Inc',
      empresa.nit || '',
      empresa.telefono || '',
      empresa.email || '',
      empresa.direccion || '',
      empresa.ciudad || ''
    );

    // 2. Insertar Administrador
    db.prepare(`
      INSERT INTO usuarios (nombre, email, password, documento, telefono, rol, activo)
      VALUES (?, ?, ?, ?, ?, 'admin', 1)
      ON CONFLICT(email) DO UPDATE SET
        nombre = excluded.nombre,
        password = excluded.password,
        documento = excluded.documento,
        telefono = excluded.telefono,
        rol = 'admin',
        activo = 1
    `).run(
      admin.nombre || 'Administrador',
      admin.email.trim().toLowerCase(),
      admin.password.trim(),
      admin.documento || '',
      admin.telefono || ''
    );

    // 3. Operador opcional
    if (operador && operador.email && operador.password) {
      db.prepare(`
        INSERT INTO usuarios (nombre, email, password, documento, telefono, rol, activo)
        VALUES (?, ?, ?, ?, ?, 'solicitante', 1)
        ON CONFLICT(email) DO UPDATE SET
          nombre = excluded.nombre,
          password = excluded.password,
          documento = excluded.documento,
          telefono = excluded.telefono
      `).run(
        operador.nombre || 'Operador',
        operador.email.trim().toLowerCase(),
        operador.password.trim(),
        operador.documento || '',
        operador.telefono || ''
      );
    }

    // 4. Técnico opcional
    if (tecnico && tecnico.email && tecnico.password) {
      db.prepare(`
        INSERT INTO usuarios (nombre, email, password, documento, telefono, rol, activo)
        VALUES (?, ?, ?, ?, ?, 'tecnico', 1)
        ON CONFLICT(email) DO UPDATE SET
          nombre = excluded.nombre,
          password = excluded.password,
          documento = excluded.documento,
          telefono = excluded.telefono
      `).run(
        tecnico.nombre || 'Técnico',
        tecnico.email.trim().toLowerCase(),
        tecnico.password.trim(),
        tecnico.documento || '',
        tecnico.telefono || ''
      );
    }

    res.json({ success: true, message: 'Setup inicial completado correctamente' });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// ==========================================
// 2. AUTENTICACIÓN Y USUARIOS
// ==========================================

function formatUsuario(row) {
  if (!row) return null;
  return {
    id: row.id,
    nombre: row.nombre,
    email: row.email,
    password: row.password,
    documento: row.documento,
    telefono: row.telefono,
    rol: row.rol,
    activo: toBool(row.activo),
    createdAt: row.created_at,
  };
}

app.post('/api/auth/login', (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ success: false, error: 'Correo y contraseña requeridos' });
    }
    const cleanEmail = email.trim().toLowerCase();
    const cleanPass = password.trim();

    const row = db.prepare('SELECT * FROM usuarios WHERE email = ? AND password = ? AND activo = 1').get(cleanEmail, cleanPass);
    if (!row) {
      return res.status(401).json({ success: false, error: 'Credenciales inválidas o usuario inactivo' });
    }
    res.json({ success: true, usuario: formatUsuario(row) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.get('/api/usuarios', (req, res) => {
  try {
    const { rol } = req.query;
    let rows;
    if (rol && rol !== 'TODOS') {
      rows = db.prepare('SELECT * FROM usuarios WHERE rol = ? ORDER BY nombre ASC').all(rol);
    } else {
      rows = db.prepare('SELECT * FROM usuarios ORDER BY nombre ASC').all();
    }
    res.json({ success: true, data: rows.map(formatUsuario) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/usuarios', (req, res) => {
  try {
    const u = req.body;
    const stmt = db.prepare(`
      INSERT INTO usuarios (nombre, email, password, documento, telefono, rol, activo)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `);
    const info = stmt.run(
      u.nombre,
      u.email.trim().toLowerCase(),
      u.password,
      u.documento || '',
      u.telefono || '',
      u.rol,
      toInt(u.activo !== undefined ? u.activo : true)
    );
    const row = db.prepare('SELECT * FROM usuarios WHERE id = ?').get(info.lastInsertRowid);
    res.json({ success: true, data: formatUsuario(row) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.put('/api/usuarios/:id', (req, res) => {
  try {
    const u = req.body;
    const id = parseInt(req.params.id, 10);
    db.prepare(`
      UPDATE usuarios SET
        nombre = ?, email = ?, password = ?, documento = ?, telefono = ?, rol = ?, activo = ?
      WHERE id = ?
    `).run(
      u.nombre,
      u.email.trim().toLowerCase(),
      u.password,
      u.documento,
      u.telefono,
      u.rol,
      toInt(u.activo),
      id
    );
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.put('/api/usuarios/:id/toggle-activo', (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    const { activo } = req.body;
    db.prepare('UPDATE usuarios SET activo = ? WHERE id = ?').run(toInt(activo), id);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.delete('/api/usuarios/:id', (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    db.prepare('DELETE FROM usuarios WHERE id = ?').run(id);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// ==========================================
// 3. CLIENTES
// ==========================================

function formatCliente(row) {
  if (!row) return null;
  return {
    id: row.id,
    tipoDocumento: row.tipo_documento,
    numeroDocumento: row.numero_documento,
    nombreCompleto: row.nombre_completo,
    telefono: row.telefono,
    email: row.email,
    direccion: row.direccion,
    createdAt: row.created_at,
  };
}

app.get('/api/clientes', (req, res) => {
  try {
    const { q } = req.query;
    let rows;
    if (q && q.trim().length > 0) {
      const term = `%${q.trim()}%`;
      rows = db.prepare(`
        SELECT * FROM clientes
        WHERE nombre_completo LIKE ? OR numero_documento LIKE ? OR telefono LIKE ? OR email LIKE ?
        ORDER BY nombre_completo ASC
      `).all(term, term, term, term);
    } else {
      rows = db.prepare('SELECT * FROM clientes ORDER BY nombre_completo ASC').all();
    }
    res.json({ success: true, data: rows.map(formatCliente) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.get('/api/clientes/documento/:doc', (req, res) => {
  try {
    const row = db.prepare('SELECT * FROM clientes WHERE numero_documento = ?').get(req.params.doc.trim());
    res.json({ success: true, data: formatCliente(row) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/clientes', (req, res) => {
  try {
    const c = req.body;
    let row = db.prepare('SELECT * FROM clientes WHERE numero_documento = ?').get(c.numeroDocumento.trim());
    if (row) {
      db.prepare(`
        UPDATE clientes SET
          tipo_documento = ?, nombre_completo = ?, telefono = ?, email = ?, direccion = ?
        WHERE id = ?
      `).run(c.tipoDocumento, c.nombreCompleto, c.telefono, c.email || null, c.direccion, row.id);
      row = db.prepare('SELECT * FROM clientes WHERE id = ?').get(row.id);
    } else {
      const info = db.prepare(`
        INSERT INTO clientes (tipo_documento, numero_documento, nombre_completo, telefono, email, direccion)
        VALUES (?, ?, ?, ?, ?, ?)
      `).run(c.tipoDocumento, c.numeroDocumento.trim(), c.nombreCompleto, c.telefono, c.email || null, c.direccion);
      row = db.prepare('SELECT * FROM clientes WHERE id = ?').get(info.lastInsertRowid);
    }
    res.json({ success: true, data: formatCliente(row) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.get('/api/clientes/:id/equipos', (req, res) => {
  try {
    const clienteId = parseInt(req.params.id, 10);
    const rows = db.prepare('SELECT * FROM equipos WHERE cliente_id = ? ORDER BY id DESC').all(clienteId);
    res.json({ success: true, data: rows.map(formatEquipo) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.get('/api/clientes/:id/ordenes', (req, res) => {
  try {
    const clienteId = parseInt(req.params.id, 10);
    const rows = db.prepare('SELECT * FROM ordenes WHERE cliente_id = ? ORDER BY id DESC').all(clienteId);
    res.json({ success: true, data: rows.map(formatOrden) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// ==========================================
// 4. EQUIPOS
// ==========================================

function formatEquipo(row) {
  if (!row) return null;
  return {
    id: row.id,
    clienteId: row.cliente_id,
    tipoEquipo: row.tipo_equipo,
    marca: row.marca,
    modelo: row.modelo,
    numeroSerie: row.numero_serie,
    sistemaOperativo: row.sistema_operativo,
    procesador: row.procesador,
    memoriaRam: row.memoria_ram,
    almacenamiento: row.almacenamiento,
    tarjetaGrafica: row.tarjeta_grafica,
    estadoEquipo: row.estado_equipo,
    createdAt: row.created_at,
  };
}

app.get('/api/equipos', (req, res) => {
  try {
    const { tipo, estado, busqueda, clienteId } = req.query;
    let sql = 'SELECT e.*, c.nombre_completo as cliente_nombre FROM equipos e JOIN clientes c ON e.cliente_id = c.id WHERE 1=1';
    const params = [];

    if (clienteId) {
      sql += ' AND e.cliente_id = ?';
      params.push(parseInt(clienteId, 10));
    }
    if (tipo && tipo !== 'TODOS') {
      sql += ' AND e.tipo_equipo = ?';
      params.push(tipo);
    }
    if (estado && estado !== 'TODOS') {
      sql += ' AND e.estado_equipo = ?';
      params.push(estado);
    }
    if (busqueda && busqueda.trim().length > 0) {
      const term = `%${busqueda.trim()}%`;
      sql += ' AND (e.numero_serie LIKE ? OR e.marca LIKE ? OR e.modelo LIKE ? OR c.nombre_completo LIKE ?)';
      params.push(term, term, term, term);
    }
    sql += ' ORDER BY e.id DESC';

    const rows = db.prepare(sql).all(...params);
    res.json({ success: true, data: rows.map(formatEquipo) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.get('/api/equipos/:id/historial', (req, res) => {
  try {
    const equipoId = parseInt(req.params.id, 10);
    const rows = db.prepare('SELECT * FROM ordenes WHERE equipo_id = ? ORDER BY id DESC').all(equipoId);
    res.json({ success: true, data: rows.map(formatOrden) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.put('/api/equipos/:id/estado', (req, res) => {
  try {
    const equipoId = parseInt(req.params.id, 10);
    const { nuevoEstado } = req.body;
    db.prepare('UPDATE equipos SET estado_equipo = ? WHERE id = ?').run(nuevoEstado, equipoId);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// ==========================================
// 5. ÓRDENES / INCIDENCIAS
// ==========================================

function formatOrden(row) {
  if (!row) return null;
  const cliente = row.cliente_id ? db.prepare('SELECT * FROM clientes WHERE id = ?').get(row.cliente_id) : null;
  const equipo = row.equipo_id ? db.prepare('SELECT * FROM equipos WHERE id = ?').get(row.equipo_id) : null;
  const tecnico = row.tecnico_id ? db.prepare('SELECT * FROM usuarios WHERE id = ?').get(row.tecnico_id) : null;

  return {
    id: row.id,
    codigoOrden: row.codigo_orden,
    clienteId: row.cliente_id,
    equipoId: row.equipo_id,
    tecnicoId: row.tecnico_id,
    solicitanteId: row.solicitante_id,
    tipoServicio: row.tipo_servicio,
    categoriaFalla: row.categoria_falla,
    prioridad: row.prioridad,
    titulo: row.titulo,
    descripcion: row.descripcion,
    estado: row.estado,
    fechaIngreso: row.fecha_ingreso,
    fechaLimiteSla: row.fecha_limite_sla,
    fechaCierre: row.fecha_cierre,
    cliente: formatCliente(cliente),
    equipo: formatEquipo(equipo),
    tecnico: formatUsuario(tecnico),
  };
}

app.get('/api/ordenes', (req, res) => {
  try {
    const { busqueda, estado, tipo, tecnicoId, solicitanteId } = req.query;
    let sql = 'SELECT * FROM ordenes WHERE 1=1';
    const params = [];

    if (estado && estado !== 'TODOS') {
      sql += ' AND estado = ?';
      params.push(estado);
    }
    if (tipo && tipo !== 'TODOS') {
      sql += ' AND tipo_servicio = ?';
      params.push(tipo);
    }
    if (tecnicoId) {
      sql += ' AND tecnico_id = ?';
      params.push(parseInt(tecnicoId, 10));
    }
    if (solicitanteId) {
      sql += ' AND solicitante_id = ?';
      params.push(parseInt(solicitanteId, 10));
    }
    if (busqueda && busqueda.trim().length > 0) {
      const term = `%${busqueda.trim()}%`;
      sql += ' AND (codigo_orden LIKE ? OR titulo LIKE ? OR descripcion LIKE ?)';
      params.push(term, term, term);
    }
    sql += ' ORDER BY id DESC';

    const rows = db.prepare(sql).all(...params);
    res.json({ success: true, data: rows.map(formatOrden) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.get('/api/ordenes/:id', (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    const row = db.prepare('SELECT * FROM ordenes WHERE id = ?').get(id);
    if (!row) {
      return res.status(404).json({ success: false, error: 'Orden no encontrada' });
    }
    res.json({ success: true, data: formatOrden(row) });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/ordenes', (req, res) => {
  try {
    const { cliente, equipo, orden, fotoIngresoBase64 } = req.body;

    // 1. Guardar o actualizar Cliente
    let cRow = db.prepare('SELECT * FROM clientes WHERE numero_documento = ?').get(cliente.numeroDocumento.trim());
    let clienteId;
    if (cRow) {
      clienteId = cRow.id;
      db.prepare(`
        UPDATE clientes SET
          tipo_documento = ?, nombre_completo = ?, telefono = ?, email = ?, direccion = ?
        WHERE id = ?
      `).run(cliente.tipoDocumento, cliente.nombreCompleto, cliente.telefono, cliente.email || null, cliente.direccion, clienteId);
    } else {
      const infoC = db.prepare(`
        INSERT INTO clientes (tipo_documento, numero_documento, nombre_completo, telefono, email, direccion)
        VALUES (?, ?, ?, ?, ?, ?)
      `).run(cliente.tipoDocumento, cliente.numeroDocumento.trim(), cliente.nombreCompleto, cliente.telefono, cliente.email || null, cliente.direccion);
      clienteId = infoC.lastInsertRowid;
    }

    // 2. Guardar o actualizar Equipo
    let eRow = null;
    if (equipo.numeroSerie && equipo.numeroSerie.trim().isNotEmpty) {
      eRow = db.prepare('SELECT * FROM equipos WHERE numero_serie = ?').get(equipo.numeroSerie.trim());
    }
    let equipoId;
    if (eRow) {
      equipoId = eRow.id;
      db.prepare(`
        UPDATE equipos SET
          cliente_id = ?, tipo_equipo = ?, marca = ?, modelo = ?,
          sistema_operativo = ?, procesador = ?, memoria_ram = ?, almacenamiento = ?,
          tarjeta_grafica = ?, estado_equipo = 'EN_TALLER'
        WHERE id = ?
      `).run(
        clienteId, equipo.tipoEquipo, equipo.marca, equipo.modelo,
        equipo.sistemaOperativo || null, equipo.procesador || null,
        equipo.memoriaRam || null, equipo.almacenamiento || null,
        equipo.tarjetaGrafica || null, equipoId
      );
    } else {
      const infoE = db.prepare(`
        INSERT INTO equipos (
          cliente_id, tipo_equipo, marca, modelo, numero_serie,
          sistema_operativo, procesador, memoria_ram, almacenamiento,
          tarjeta_grafica, estado_equipo
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'EN_TALLER')
      `).run(
        clienteId, equipo.tipoEquipo, equipo.marca, equipo.modelo,
        equipo.numeroSerie || `SN-${Date.now()}`,
        equipo.sistemaOperativo || null, equipo.procesador || null,
        equipo.memoriaRam || null, equipo.almacenamiento || null,
        equipo.tarjetaGrafica || null
      );
      equipoId = infoE.lastInsertRowid;
    }

    // 3. Generar código consecutivo de orden
    const year = new Date().getFullYear();
    const countRow = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE codigo_orden LIKE ?").get(`ORD-${year}-%`);
    const nextNum = (countRow.c + 1).toString().padStart(4, '0');
    const codigoOrden = orden.codigoOrden || `ORD-${year}-${nextNum}`;

    // 4. Insertar Orden
    const infoO = db.prepare(`
      INSERT INTO ordenes (
        codigo_orden, cliente_id, equipo_id, tecnico_id, solicitante_id,
        tipo_servicio, categoria_falla, prioridad, titulo, descripcion,
        estado, fecha_ingreso, fecha_limite_sla
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `).run(
      codigoOrden, clienteId, equipoId,
      orden.tecnicoId || null, orden.solicitanteId || null,
      orden.tipoServicio, orden.categoriaFalla, orden.prioridad,
      orden.titulo, orden.descripcion,
      orden.estado || 'RECIBIDO',
      orden.fechaIngreso || new Date().toISOString(),
      orden.fechaLimiteSla || null
    );
    const ordenId = infoO.lastInsertRowid;

    // 5. Foto de ingreso opcional
    if (fotoIngresoBase64) {
      db.prepare(`
        INSERT INTO fotos_evidencia (orden_id, etapa, ruta_o_bytes_base64, nota_tecnica, fecha_captura)
        VALUES (?, 'RECEPCION', ?, 'Foto de ingreso al radicar orden', datetime('now'))
      `).run(ordenId, fotoIngresoBase64);
    }

    res.json({ success: true, codigoOrden, ordenId });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.put('/api/ordenes/:id/estado', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const { nuevoEstado } = req.body;
    if (nuevoEstado === 'ENTREGADO_CERRADO') {
      db.prepare("UPDATE ordenes SET estado = ?, fecha_cierre = datetime('now') WHERE id = ?").run(nuevoEstado, ordenId);
    } else {
      db.prepare('UPDATE ordenes SET estado = ? WHERE id = ?').run(nuevoEstado, ordenId);
    }
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.put('/api/ordenes/:id/tecnico', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const { tecnicoId } = req.body;
    db.prepare('UPDATE ordenes SET tecnico_id = ? WHERE id = ?').run(tecnicoId ? parseInt(tecnicoId, 10) : null, ordenId);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// ==========================================
// 6. FORMATOS SENA (OT, ACTIVIDADES, REPUESTOS, FOTOS, ACTA)
// ==========================================

// Formato OT
app.get('/api/ordenes/:id/ot', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const row = db.prepare('SELECT * FROM formato_ot WHERE orden_id = ?').get(ordenId);
    if (!row) return res.json({ success: true, data: null });

    let chips = [];
    try {
      chips = JSON.parse(row.herramientas_chips || '[]');
    } catch (_) {}

    res.json({
      success: true,
      data: {
        id: row.id,
        ordenId: row.orden_id,
        diagnosticoPreliminar: row.diagnostico_preliminar,
        herramientasChips: chips,
        tiempoEstimadoEntrega: row.tiempo_estimado_entrega,
        accesorioCargador: toBool(row.accesorio_cargador),
        accesorioCablePoder: toBool(row.accesorio_cable_poder),
        accesorioMouse: toBool(row.accesorio_mouse),
        accesorioMaletin: toBool(row.accesorio_maletin),
        encendidoInicial: toBool(row.encendido_inicial),
        estadoCarcasa: row.estado_carcasa,
        pinContrasena: row.pin_contrasena,
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/ordenes/:id/ot', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const ot = req.body;
    const existing = db.prepare('SELECT id FROM formato_ot WHERE orden_id = ?').get(ordenId);

    const chipsJson = JSON.stringify(ot.herramientasChips || []);

    if (existing) {
      db.prepare(`
        UPDATE formato_ot SET
          diagnostico_preliminar = ?, herramientas_chips = ?, tiempo_estimado_entrega = ?,
          accesorio_cargador = ?, accesorio_cable_poder = ?, accesorio_mouse = ?,
          accesorio_maletin = ?, encendido_inicial = ?, estado_carcasa = ?, pin_contrasena = ?
        WHERE id = ?
      `).run(
        ot.diagnosticoPreliminar, chipsJson, ot.tiempoEstimadoEntrega || null,
        toInt(ot.accesorioCargador), toInt(ot.accesorioCablePoder), toInt(ot.accesorioMouse),
        toInt(ot.accesorioMaletin), toInt(ot.encendidoInicial), ot.estadoCarcasa, ot.pinContrasena,
        existing.id
      );
    } else {
      db.prepare(`
        INSERT INTO formato_ot (
          orden_id, diagnostico_preliminar, herramientas_chips, tiempo_estimado_entrega,
          accesorio_cargador, accesorio_cable_poder, accesorio_mouse, accesorio_maletin,
          encendido_inicial, estado_carcasa, pin_contrasena
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `).run(
        ordenId, ot.diagnosticoPreliminar, chipsJson, ot.tiempoEstimadoEntrega || null,
        toInt(ot.accesorioCargador), toInt(ot.accesorioCablePoder), toInt(ot.accesorioMouse),
        toInt(ot.accesorioMaletin), toInt(ot.encendidoInicial), ot.estadoCarcasa, ot.pinContrasena
      );
    }
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Formato Actividades
app.get('/api/ordenes/:id/actividades', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const row = db.prepare('SELECT * FROM formato_actividades WHERE orden_id = ?').get(ordenId);
    if (!row) return res.json({ success: true, data: null });

    res.json({
      success: true,
      data: {
        id: row.id,
        ordenId: row.orden_id,
        procedimientosRealizados: row.procedimientos_realizados,
        pastaTermica: toBool(row.pasta_termica),
        alcoholIsopropilico: toBool(row.alcohol_isopropilico),
        sopleteadoContactos: toBool(row.sopleteado_contactos),
        brochaAntiestatica: toBool(row.brocha_antiestatica),
        panoMicrofibra: toBool(row.pano_microfibra),
        depuracionTemporales: toBool(row.depuracion_temporales),
        optimizacionInicio: toBool(row.optimizacion_inicio),
        escaneoMalware: toBool(row.escaneo_malware),
        actualizacionDrivers: toBool(row.actualizacion_drivers),
        comprobacionDisco: toBool(row.comprobacion_disco),
        qaEstresTermico: toBool(row.qa_estres_termico),
        qaPuertos: toBool(row.qa_puertos),
        qaConectividad: toBool(row.qa_conectividad),
        qaBateria: toBool(row.qa_bateria),
        qaTecladoTouchpad: toBool(row.qa_teclado_touchpad),
        costoManoObra: row.costo_mano_obra || 0,
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/ordenes/:id/actividades', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const act = req.body;
    const existing = db.prepare('SELECT id FROM formato_actividades WHERE orden_id = ?').get(ordenId);

    if (existing) {
      db.prepare(`
        UPDATE formato_actividades SET
          procedimientos_realizados = ?, pasta_termica = ?, alcohol_isopropilico = ?,
          sopleteado_contactos = ?, brocha_antiestatica = ?, pano_microfibra = ?,
          depuracion_temporales = ?, optimizacion_inicio = ?, escaneo_malware = ?,
          actualizacion_drivers = ?, comprobacion_disco = ?, qa_estres_termico = ?,
          qa_puertos = ?, qa_conectividad = ?, qa_bateria = ?, qa_teclado_touchpad = ?,
          costo_mano_obra = ?
        WHERE id = ?
      `).run(
        act.procedimientosRealizados, toInt(act.pastaTermica), toInt(act.alcoholIsopropilico),
        toInt(act.sopleteadoContactos), toInt(act.brochaAntiestatica), toInt(act.panoMicrofibra),
        toInt(act.depuracionTemporales), toInt(act.optimizacionInicio), toInt(act.escaneoMalware),
        toInt(act.actualizacionDrivers), toInt(act.comprobacionDisco), toInt(act.qaEstresTermico),
        toInt(act.qaPuertos), toInt(act.qaConectividad), toInt(act.qaBateria), toInt(act.qaTecladoTouchpad),
        act.costoManoObra || 0, existing.id
      );
    } else {
      db.prepare(`
        INSERT INTO formato_actividades (
          orden_id, procedimientos_realizados, pasta_termica, alcohol_isopropilico,
          sopleteado_contactos, brocha_antiestatica, pano_microfibra, depuracion_temporales,
          optimizacion_inicio, escaneo_malware, actualizacion_drivers, comprobacion_disco,
          qa_estres_termico, qa_puertos, qa_conectividad, qa_bateria, qa_teclado_touchpad,
          costo_mano_obra
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `).run(
        ordenId, act.procedimientosRealizados, toInt(act.pastaTermica), toInt(act.alcoholIsopropilico),
        toInt(act.sopleteadoContactos), toInt(act.brochaAntiestatica), toInt(act.panoMicrofibra),
        toInt(act.depuracionTemporales), toInt(act.optimizacionInicio), toInt(act.escaneoMalware),
        toInt(act.actualizacionDrivers), toInt(act.comprobacionDisco), toInt(act.qaEstresTermico),
        toInt(act.qaPuertos), toInt(act.qaConectividad), toInt(act.qaBateria), toInt(act.qaTecladoTouchpad),
        act.costoManoObra || 0
      );
    }
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Repuestos
app.get('/api/ordenes/:id/repuestos', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const rows = db.prepare('SELECT * FROM repuestos_orden WHERE orden_id = ? ORDER BY id ASC').all(ordenId);
    res.json({
      success: true,
      data: rows.map(r => ({
        id: r.id,
        ordenId: r.orden_id,
        referencia: r.referencia,
        cantidad: r.cantidad,
        precioUnitario: r.precio_unitario,
        subtotal: r.cantidad * r.precio_unitario,
      })),
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/ordenes/:id/repuestos', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const r = req.body;
    const info = db.prepare(`
      INSERT INTO repuestos_orden (orden_id, referencia, cantidad, precio_unitario)
      VALUES (?, ?, ?, ?)
    `).run(ordenId, r.referencia, r.cantidad || 1, r.precioUnitario || 0);
    res.json({ success: true, id: info.lastInsertRowid });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.delete('/api/repuestos/:id', (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    db.prepare('DELETE FROM repuestos_orden WHERE id = ?').run(id);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Fotos
app.get('/api/ordenes/:id/fotos', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const rows = db.prepare('SELECT * FROM fotos_evidencia WHERE orden_id = ? ORDER BY id ASC').all(ordenId);
    res.json({
      success: true,
      data: rows.map(f => ({
        id: f.id,
        ordenId: f.orden_id,
        etapa: f.etapa,
        rutaOBytesBase64: f.ruta_o_bytes_base64,
        notaTecnica: f.nota_tecnica,
        fechaCaptura: f.fecha_captura,
      })),
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/ordenes/:id/fotos', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const f = req.body;
    const info = db.prepare(`
      INSERT INTO fotos_evidencia (orden_id, etapa, ruta_o_bytes_base64, nota_tecnica, fecha_captura)
      VALUES (?, ?, ?, ?, ?)
    `).run(ordenId, f.etapa, f.rutaOBytesBase64, f.notaTecnica || null, f.fechaCaptura || new Date().toISOString());
    res.json({ success: true, id: info.lastInsertRowid });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.delete('/api/fotos/:id', (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    db.prepare('DELETE FROM fotos_evidencia WHERE id = ?').run(id);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Acta de Entrega
app.get('/api/ordenes/:id/acta', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const row = db.prepare('SELECT * FROM formato_acta_entrega WHERE orden_id = ?').get(ordenId);
    if (!row) return res.json({ success: true, data: null });
    res.json({
      success: true,
      data: {
        id: row.id,
        ordenId: row.orden_id,
        estadoOperatividad: row.estado_operatividad,
        observaciones: row.observaciones,
        recomendacionesCuidado: row.recomendaciones_cuidado,
        garantiaDias: row.garantia_dias,
        personaRecibeNombre: row.persona_recibe_nombre,
        personaRecibeDocumento: row.persona_recibe_documento,
        checkConformidad: toBool(row.check_conformidad),
        firmaDigitalBase64: row.firma_digital_base64,
        fechaEntrega: row.fecha_entrega,
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/ordenes/:id/acta', (req, res) => {
  try {
    const ordenId = parseInt(req.params.id, 10);
    const a = req.body;
    const existing = db.prepare('SELECT id FROM formato_acta_entrega WHERE orden_id = ?').get(ordenId);

    if (existing) {
      db.prepare(`
        UPDATE formato_acta_entrega SET
          estado_operatividad = ?, observaciones = ?, recomendaciones_cuidado = ?,
          garantia_dias = ?, persona_recibe_nombre = ?, persona_recibe_documento = ?,
          check_conformidad = ?, firma_digital_base64 = ?
        WHERE id = ?
      `).run(
        a.estadoOperatividad || 'OPERATIVO', a.observaciones || null, a.recomendacionesCuidado || null,
        a.garantiaDias || 30, a.personaRecibeNombre, a.personaRecibeDocumento,
        toInt(a.checkConformidad), a.firmaDigitalBase64 || null, existing.id
      );
    } else {
      db.prepare(`
        INSERT INTO formato_acta_entrega (
          orden_id, estado_operatividad, observaciones, recomendaciones_cuidado,
          garantia_dias, persona_recibe_nombre, persona_recibe_documento,
          check_conformidad, firma_digital_base64
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `).run(
        ordenId, a.estadoOperatividad || 'OPERATIVO', a.observaciones || null, a.recomendacionesCuidado || null,
        a.garantiaDias || 30, a.personaRecibeNombre, a.personaRecibeDocumento,
        toInt(a.checkConformidad), a.firmaDigitalBase64 || null
      );
    }

    // Cerrar automáticamente la orden
    db.prepare("UPDATE ordenes SET estado = 'ENTREGADO_CERRADO', fecha_cierre = datetime('now') WHERE id = ?").run(ordenId);

    res.json({ success: true, message: 'Acta guardada y orden cerrada con éxito' });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// ==========================================
// 7. MÉTRICAS Y DASHBOARD
// ==========================================

app.get('/api/metrics/dashboard', (req, res) => {
  try {
    const total = db.prepare('SELECT COUNT(*) as c FROM ordenes').get().c;
    const enTaller = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE estado IN ('RECIBIDO', 'EN_DIAGNOSTICO', 'EN_TALLER')").get().c;
    const listos = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE estado = 'LISTO_ENTREGA'").get().c;
    const cerrados = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE estado = 'ENTREGADO_CERRADO'").get().c;

    res.json({
      success: true,
      data: {
        totalTickets: total,
        ticketsEnTaller: enTaller,
        ticketsListos: listos,
        ticketsEntregados: cerrados,
        cumplimientoSlaPorcentaje: 100.0,
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.get('/api/metrics/admin', (req, res) => {
  try {
    const total = db.prepare('SELECT COUNT(*) as c FROM ordenes').get().c;
    const sinAsignar = db.prepare('SELECT COUNT(*) as c FROM ordenes WHERE tecnico_id IS NULL').get().c;
    const preventivos = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE tipo_servicio = 'PREVENTIVO'").get().c;
    const correctivos = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE tipo_servicio = 'CORRECTIVO'").get().c;

    const tecnicos = db.prepare("SELECT id, nombre FROM usuarios WHERE rol = 'tecnico'").all();
    const cargaTecnicos = tecnicos.map(t => {
      const activas = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE tecnico_id = ? AND estado != 'ENTREGADO_CERRADO'").get(t.id).c;
      const cerradas = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE tecnico_id = ? AND estado = 'ENTREGADO_CERRADO'").get(t.id).c;
      return { tecnicoId: t.id, nombre: t.nombre, ordenesActivas: activas, ordenesCerradas: cerradas };
    });

    res.json({
      success: true,
      data: {
        total,
        vencidos: 0,
        sinAsignar,
        preventivos,
        correctivos,
        tiempoPromedioHoras: 0.0,
        cargaTecnicos,
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// ==========================================
// 8. CONSULTA PÚBLICA (PORTAL CLIENTES)
// ==========================================

app.get('/api/consulta-publica', (req, res) => {
  try {
    const q = (req.query.q || '').trim();
    if (!q) {
      return res.json({ success: true, data: { tipo: 'no_encontrado' } });
    }

    // 1. Buscar por Código de Orden exacto o parcial
    const ordenRow = db.prepare('SELECT * FROM ordenes WHERE codigo_orden = ? OR codigo_orden LIKE ?').get(q, `%${q}%`);
    if (ordenRow) {
      return res.json({ success: true, data: { tipo: 'orden', orden: formatOrden(ordenRow) } });
    }

    // 2. Buscar por Documento de Cliente
    const clienteRow = db.prepare('SELECT * FROM clientes WHERE numero_documento = ?').get(q);
    if (clienteRow) {
      const equipos = db.prepare('SELECT * FROM equipos WHERE cliente_id = ?').all(clienteRow.id).map(formatEquipo);
      const ordenes = db.prepare('SELECT * FROM ordenes WHERE cliente_id = ? ORDER BY id DESC').all(clienteRow.id).map(formatOrden);
      return res.json({
        success: true,
        data: {
          tipo: 'cliente',
          cliente: formatCliente(clienteRow),
          equipos,
          ordenes,
        },
      });
    }

    // 3. Buscar por Número de Serie de Equipo
    const equipoRow = db.prepare('SELECT * FROM equipos WHERE numero_serie = ? OR numero_serie LIKE ?').get(q, `%${q}%`);
    if (equipoRow) {
      const clienteDelEquipo = db.prepare('SELECT * FROM clientes WHERE id = ?').get(equipoRow.cliente_id);
      const historial = db.prepare('SELECT * FROM ordenes WHERE equipo_id = ? ORDER BY id DESC').all(equipoRow.id).map(formatOrden);
      return res.json({
        success: true,
        data: {
          tipo: 'equipo',
          equipo: formatEquipo(equipoRow),
          cliente: formatCliente(clienteDelEquipo),
          historial,
        },
      });
    }

    res.json({ success: true, data: { tipo: 'no_encontrado' } });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// ==========================================
// 9. AUDITORÍA DE NOTIFICACIONES
// ==========================================

app.get('/api/auditoria', (req, res) => {
  try {
    const rows = db.prepare('SELECT * FROM notificaciones_auditoria ORDER BY id DESC LIMIT 50').all();
    res.json({
      success: true,
      data: rows.map(n => ({
        id: n.id,
        destinatario: n.destinatario,
        asunto: n.asunto,
        evento: n.evento,
        estado: n.estado,
        fechaEnvio: n.fecha_envio,
      })),
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/auditoria', (req, res) => {
  try {
    const { destinatario, asunto, evento, estado, fechaEnvio } = req.body;
    db.prepare(`
      INSERT INTO notificaciones_auditoria (destinatario, asunto, evento, estado, fecha_envio)
      VALUES (?, ?, ?, ?, ?)
    `).run(destinatario, asunto, evento, estado, fechaEnvio || new Date().toISOString());
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// ==========================================
// 10. TIPOS DE FALLA
// ==========================================

app.get('/api/tipos-falla', (req, res) => {
  try {
    const { tipoServicio } = req.query;
    let rows;
    if (tipoServicio) {
      rows = db.prepare('SELECT * FROM tipos_falla WHERE tipo_servicio = ? AND activo = 1 ORDER BY nombre ASC').all(tipoServicio);
    } else {
      rows = db.prepare('SELECT * FROM tipos_falla WHERE activo = 1 ORDER BY nombre ASC').all();
    }
    res.json({
      success: true,
      data: rows.map(t => ({
        id: t.id,
        tipoServicio: t.tipo_servicio,
        nombre: t.nombre,
        descripcion: t.descripcion,
        activo: toBool(t.activo),
      })),
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.post('/api/tipos-falla', (req, res) => {
  try {
    const { tipoServicio, nombre, descripcion } = req.body;
    const info = db.prepare(`
      INSERT INTO tipos_falla (tipo_servicio, nombre, descripcion, activo)
      VALUES (?, ?, ?, 1)
    `).run(tipoServicio, nombre.trim(), descripcion || null);
    res.json({
      success: true,
      data: { id: info.lastInsertRowid, tipoServicio, nombre, descripcion, activo: true },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.delete('/api/tipos-falla/:id', (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    db.prepare('DELETE FROM tipos_falla WHERE id = ?').run(id);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// ==========================================
// 11. ENVÍO DE CORREOS SMTP (NODEMAILER)
// ==========================================

app.post('/api/send-email', async (req, res) => {
  try {
    await emailHandler(req, res);
  } catch (err) {
    console.error('Error enviando email:', err);
    if (!res.headersSent) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
});

// ==========================================
// 12. SERVIR WEB ESTÁTICA SI EXISTE BUILD
// ==========================================

const webBuildPath = path.join(__dirname, 'build', 'web');
if (fs.existsSync(webBuildPath)) {
  app.use(express.static(webBuildPath));
  app.get('*', (req, res, next) => {
    if (req.path.startsWith('/api/')) return next();
    res.sendFile(path.join(webBuildPath, 'index.html'));
  });
} else {
  app.get('/', (req, res) => {
    res.send(`
      <!DOCTYPE html>
      <html>
        <head><title>Santi Inc - Servidor Central SQLite</title></head>
        <body style="font-family: sans-serif; text-align: center; padding: 40px; background: #0f172a; color: white;">
          <h1 style="color: #38bdf8;">🚀 Servidor Central SQLite de Santi Inc Activo</h1>
          <p>Puerto: <strong>${PORT}</strong></p>
          <p>Base de datos: <code>data/tickets.sqlite</code></p>
          <div style="background: #1e293b; display: inline-block; padding: 20px; border-radius: 8px; text-align: left;">
            <p>✅ API REST disponible en: <code>http://localhost:${PORT}/api/</code></p>
            <p>✅ Servicio de Correo SMTP: <code>/api/send-email</code></p>
            <p>✅ Consulta Pública: <code>/api/consulta-publica?q=...</code></p>
          </div>
        </body>
      </html>
    `);
  });
}

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`\n======================================================`);
  console.log(`  🚀 SERVIDOR CENTRAL SQLITE ACTIVO EN:`);
  console.log(`  👉 http://localhost:${PORT}`);
  console.log(`  📂 Base de Datos: data/tickets.sqlite`);
  console.log(`  📡 API REST & Microservicio de Correo Listos`);
  console.log(`======================================================\n`);
});
