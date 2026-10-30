const { eq, asc } = require('drizzle-orm');
const { orm, schema } = require('./orm');

const toBool = val => val === 1 || val === true || val === 'true';

function getEmpresaConfig() {
  const row = orm
    .select()
    .from(schema.configuracionEmpresa)
    .orderBy(asc(schema.configuracionEmpresa.id))
    .limit(1)
    .get();
  if (!row) return null;
  return {
    id: row.id,
    nombreEmpresa: row.nombreEmpresa ?? row.nombre_empresa,
    slogan: row.slogan,
    nit: row.nit,
    telefono: row.telefono,
    email: row.email,
    direccion: row.direccion,
    ciudad: row.ciudad,
    logoBase64: row.logoBase64 ?? row.logo_base64,
    smtpHost: row.smtpHost ?? row.smtp_host,
    smtpPort: row.smtpPort ?? row.smtp_port,
    smtpUser: row.smtpUser ?? row.smtp_user,
    smtpPass: (row.smtpPass ?? row.smtp_pass) ? '********' : null,
    smtpApiUrl: row.smtpApiUrl ?? row.smtp_api_url,
    portalHostUrl: row.portalHostUrl ?? row.portal_host_url,
    colorPrimario: row.colorPrimario ?? row.color_primario,
    colorSecundario: row.colorSecundario ?? row.color_secundario,
    isSetupCompleted: toBool(row.isSetupCompleted ?? row.is_setup_completed),
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
    createdAt: row.createdAt ?? row.created_at,
  };
}

function formatCliente(row) {
  if (!row) return null;
  return {
    id: row.id,
    tipoDocumento: row.tipoDocumento ?? row.tipo_documento,
    numeroDocumento: row.numeroDocumento ?? row.numero_documento,
    nombreCompleto: row.nombreCompleto ?? row.nombre_completo,
    telefono: row.telefono,
    email: row.email,
    direccion: row.direccion,
    createdAt: row.createdAt ?? row.created_at,
  };
}

function formatEquipo(row) {
  if (!row) return null;
  return {
    id: row.id,
    clienteId: row.clienteId ?? row.cliente_id,
    tipoEquipo: row.tipoEquipo ?? row.tipo_equipo,
    marca: row.marca,
    modelo: row.modelo,
    numeroSerie: row.numeroSerie ?? row.numero_serie,
    sistemaOperativo: row.sistemaOperativo ?? row.sistema_operativo,
    procesador: row.procesador,
    memoriaRam: row.memoriaRam ?? row.memoria_ram,
    almacenamiento: row.almacenamiento,
    tarjetaGrafica: row.tarjetaGrafica ?? row.tarjeta_grafica,
    estadoEquipo: row.estadoEquipo ?? row.estado_equipo,
    createdAt: row.createdAt ?? row.created_at,
  };
}

function formatOrden(row) {
  if (!row) return null;
  const clienteId = row.clienteId ?? row.cliente_id;
  const equipoId = row.equipoId ?? row.equipo_id;
  const tecnicoId = row.tecnicoId ?? row.tecnico_id;

  const cliente = clienteId
    ? orm.select().from(schema.clientes).where(eq(schema.clientes.id, clienteId)).get()
    : null;
  const equipo = equipoId
    ? orm.select().from(schema.equipos).where(eq(schema.equipos.id, equipoId)).get()
    : null;
  const tecnico = tecnicoId
    ? orm.select().from(schema.usuarios).where(eq(schema.usuarios.id, tecnicoId)).get()
    : null;

  return {
    id: row.id,
    codigoOrden: row.codigoOrden ?? row.codigo_orden,
    clienteId,
    equipoId,
    tecnicoId,
    solicitanteId: row.solicitanteId ?? row.solicitante_id,
    tipoServicio: row.tipoServicio ?? row.tipo_servicio,
    categoriaFalla: row.categoriaFalla ?? row.categoria_falla,
    prioridad: row.prioridad,
    titulo: row.titulo,
    descripcion: row.descripcion,
    estado: row.estado,
    fechaIngreso: row.fechaIngreso ?? row.fecha_ingreso,
    fechaLimiteSla: row.fechaLimiteSla ?? row.fecha_limite_sla,
    fechaCierre: row.fechaCierre ?? row.fecha_cierre,
    cliente: formatCliente(cliente),
    equipo: formatEquipo(equipo),
    tecnico: formatUsuario(tecnico),
  };
}

module.exports = {
  getEmpresaConfig,
  formatUsuario,
  formatCliente,
  formatEquipo,
  formatOrden,
  toBool,
};
