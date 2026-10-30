const { sql } = require('drizzle-orm');
const { sqliteTable, integer, text, real, uniqueIndex, index } = require('drizzle-orm/sqlite-core');

const usuarios = sqliteTable('usuarios', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  nombre: text('nombre').notNull(),
  email: text('email').notNull(),
  password: text('password').notNull(),
  documento: text('documento').notNull(),
  telefono: text('telefono').notNull(),
  rol: text('rol').notNull(),
  activo: integer('activo', { mode: 'boolean' }).notNull().default(true),
  createdAt: text('created_at').default(sql`(datetime('now'))`),
}, table => [uniqueIndex('usuarios_email_unique').on(table.email)]);

const clientes = sqliteTable('clientes', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  tipoDocumento: text('tipo_documento').notNull(),
  numeroDocumento: text('numero_documento').notNull(),
  nombreCompleto: text('nombre_completo').notNull(),
  telefono: text('telefono').notNull(),
  email: text('email'),
  direccion: text('direccion').notNull(),
  createdAt: text('created_at').default(sql`(datetime('now'))`),
}, table => [uniqueIndex('clientes_documento_unique').on(table.numeroDocumento)]);

const equipos = sqliteTable('equipos', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  clienteId: integer('cliente_id').notNull().references(() => clientes.id, { onDelete: 'cascade' }),
  tipoEquipo: text('tipo_equipo').notNull(),
  marca: text('marca').notNull(),
  modelo: text('modelo').notNull(),
  numeroSerie: text('numero_serie').notNull(),
  sistemaOperativo: text('sistema_operativo'),
  procesador: text('procesador'),
  memoriaRam: text('memoria_ram'),
  almacenamiento: text('almacenamiento'),
  tarjetaGrafica: text('tarjeta_grafica'),
  estadoEquipo: text('estado_equipo').default('OPERATIVO'),
  createdAt: text('created_at').default(sql`(datetime('now'))`),
});

const ordenes = sqliteTable('ordenes', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  codigoOrden: text('codigo_orden').notNull(),
  clienteId: integer('cliente_id').notNull().references(() => clientes.id),
  equipoId: integer('equipo_id').notNull().references(() => equipos.id),
  tecnicoId: integer('tecnico_id').references(() => usuarios.id),
  solicitanteId: integer('solicitante_id').references(() => usuarios.id),
  tipoServicio: text('tipo_servicio').notNull(),
  categoriaFalla: text('categoria_falla').notNull(),
  prioridad: text('prioridad').notNull(),
  titulo: text('titulo').notNull(),
  descripcion: text('descripcion').notNull(),
  estado: text('estado').default('RECIBIDO'),
  fechaIngreso: text('fecha_ingreso').default(sql`(datetime('now'))`),
  fechaLimiteSla: text('fecha_limite_sla'),
  fechaCierre: text('fecha_cierre'),
}, table => [uniqueIndex('ordenes_codigo_unique').on(table.codigoOrden)]);

const formatoOt = sqliteTable('formato_ot', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  ordenId: integer('orden_id').notNull().references(() => ordenes.id, { onDelete: 'cascade' }),
  diagnosticoPreliminar: text('diagnostico_preliminar'),
  herramientasChips: text('herramientas_chips').default('[]'),
  tiempoEstimadoEntrega: text('tiempo_estimado_entrega'),
  accesorioCargador: integer('accesorio_cargador', { mode: 'boolean' }).default(false),
  accesorioCablePoder: integer('accesorio_cable_poder', { mode: 'boolean' }).default(false),
  accesorioMouse: integer('accesorio_mouse', { mode: 'boolean' }).default(false),
  accesorioMaletin: integer('accesorio_maletin', { mode: 'boolean' }).default(false),
  encendidoInicial: integer('encendido_inicial', { mode: 'boolean' }).default(true),
  estadoCarcasa: text('estado_carcasa'),
  pinContrasena: text('pin_contrasena'),
});

const formatoActividades = sqliteTable('formato_actividades', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  ordenId: integer('orden_id').notNull().references(() => ordenes.id, { onDelete: 'cascade' }),
  procedimientosRealizados: text('procedimientos_realizados'),
  pastaTermica: integer('pasta_termica', { mode: 'boolean' }).default(false),
  alcoholIsopropilico: integer('alcohol_isopropilico', { mode: 'boolean' }).default(false),
  sopleteadoContactos: integer('sopleteado_contactos', { mode: 'boolean' }).default(false),
  brochaAntiestatica: integer('brocha_antiestatica', { mode: 'boolean' }).default(false),
  panoMicrofibra: integer('pano_microfibra', { mode: 'boolean' }).default(false),
  depuracionTemporales: integer('depuracion_temporales', { mode: 'boolean' }).default(false),
  optimizacionInicio: integer('optimizacion_inicio', { mode: 'boolean' }).default(false),
  escaneoMalware: integer('escaneo_malware', { mode: 'boolean' }).default(false),
  actualizacionDrivers: integer('actualizacion_drivers', { mode: 'boolean' }).default(false),
  comprobacionDisco: integer('comprobacion_disco', { mode: 'boolean' }).default(false),
  qaEstresTermico: integer('qa_estres_termico', { mode: 'boolean' }).default(false),
  qaPuertos: integer('qa_puertos', { mode: 'boolean' }).default(false),
  qaConectividad: integer('qa_conectividad', { mode: 'boolean' }).default(false),
  qaBateria: integer('qa_bateria', { mode: 'boolean' }).default(false),
  qaTecladoTouchpad: integer('qa_teclado_touchpad', { mode: 'boolean' }).default(false),
  costoManoObra: real('costo_mano_obra').default(0),
  fechaActividad: text('fecha_actividad').default(sql`(datetime('now'))`),
});

const repuestosOrden = sqliteTable('repuestos_orden', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  ordenId: integer('orden_id').notNull().references(() => ordenes.id, { onDelete: 'cascade' }),
  referencia: text('referencia').notNull(),
  cantidad: integer('cantidad').notNull().default(1),
  precioUnitario: real('precio_unitario').notNull().default(0),
  createdAt: text('created_at').default(sql`(datetime('now'))`),
});

const formatoActaEntrega = sqliteTable('formato_acta_entrega', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  ordenId: integer('orden_id').notNull().references(() => ordenes.id, { onDelete: 'cascade' }),
  estadoOperatividad: text('estado_operatividad').notNull().default('OPERATIVO'),
  observaciones: text('observaciones'),
  recomendacionesCuidado: text('recomendaciones_cuidado'),
  garantiaDias: integer('garantia_dias').default(30),
  personaRecibeNombre: text('persona_recibe_nombre').notNull(),
  personaRecibeDocumento: text('persona_recibe_documento').notNull(),
  checkConformidad: integer('check_conformidad', { mode: 'boolean' }).default(false),
  firmaDigitalBase64: text('firma_digital_base64'),
  fechaEntrega: text('fecha_entrega').default(sql`(datetime('now'))`),
});

const fotosEvidencia = sqliteTable('fotos_evidencia', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  ordenId: integer('orden_id').notNull().references(() => ordenes.id, { onDelete: 'cascade' }),
  etapa: text('etapa').notNull(),
  rutaOBytesBase64: text('ruta_o_bytes_base64').notNull(),
  notaTecnica: text('nota_tecnica'),
  fechaCaptura: text('fecha_captura').default(sql`(datetime('now'))`),
});

const configuracionEmpresa = sqliteTable('configuracion_empresa', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  nombreEmpresa: text('nombre_empresa').notNull().default('Santi Inc'),
  slogan: text('slogan'),
  nit: text('nit'),
  telefono: text('telefono'),
  email: text('email'),
  direccion: text('direccion'),
  ciudad: text('ciudad'),
  logoBase64: text('logo_base64'),
  smtpHost: text('smtp_host').default('smtp.gmail.com'),
  smtpPort: integer('smtp_port').default(465),
  smtpUser: text('smtp_user'),
  smtpPass: text('smtp_pass'),
  smtpApiUrl: text('smtp_api_url'),
  portalHostUrl: text('portal_host_url').default('http://localhost:3000'),
  colorPrimario: text('color_primario').default('#0F172A'),
  colorSecundario: text('color_secundario').default('#0284C7'),
  isSetupCompleted: integer('is_setup_completed', { mode: 'boolean' }).default(false),
});

const notificacionesAuditoria = sqliteTable('notificaciones_auditoria', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  destinatario: text('destinatario').notNull(),
  asunto: text('asunto').notNull(),
  evento: text('evento').notNull(),
  estado: text('estado').notNull(),
  fechaEnvio: text('fecha_envio').default(sql`(datetime('now'))`),
});

const tiposFalla = sqliteTable('tipos_falla', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  tipoServicio: text('tipo_servicio').notNull(),
  nombre: text('nombre').notNull(),
  descripcion: text('descripcion'),
  activo: integer('activo', { mode: 'boolean' }).default(true),
  createdAt: text('created_at').default(sql`(datetime('now'))`),
}, table => [uniqueIndex('tipos_falla_nombre_unique').on(table.nombre)]);

const auditoriaCambios = sqliteTable('auditoria_cambios', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  usuarioId: integer('usuario_id').references(() => usuarios.id, { onDelete: 'set null' }),
  usuarioNombre: text('usuario_nombre').notNull(),
  metodo: text('metodo').notNull(),
  ruta: text('ruta').notNull(),
  fecha: text('fecha').notNull().default(sql`(datetime('now'))`),
}, table => [index('idx_auditoria_fecha').on(table.fecha)]);

module.exports = {
  usuarios,
  clientes,
  equipos,
  ordenes,
  formatoOt,
  formatoActividades,
  repuestosOrden,
  formatoActaEntrega,
  fotosEvidencia,
  configuracionEmpresa,
  notificacionesAuditoria,
  tiposFalla,
  auditoriaCambios,
};
