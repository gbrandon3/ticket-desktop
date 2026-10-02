const db = require('./db');
const toBool = val => val === 1 || val === true || val === 'true';
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
    smtpPass: row.smtp_pass ? '********' : null,
    smtpApiUrl: row.smtp_api_url,
    portalHostUrl: row.portal_host_url,
    colorPrimario: row.color_primario,
    colorSecundario: row.color_secundario,
    isSetupCompleted: toBool(row.is_setup_completed),
  };
}

function formatUsuario(row) {
  if (!row) return null;
  return {
    id: row.id,
    nombre: row.nombre,
    email: row.email,
    
    documento: row.documento,
    telefono: row.telefono,
    rol: row.rol,
    activo: toBool(row.activo),
    createdAt: row.created_at,
  };
}

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
module.exports = { getEmpresaConfig, formatUsuario, formatCliente, formatEquipo, formatOrden, toBool };
