const { sql } = require('drizzle-orm');
const {
  pgTable,
  serial,
  integer,
  text,
  doublePrecision,
  boolean,
  uniqueIndex,
  index,
} = require('drizzle-orm/pg-core');

const usuarios = pgTable('usuarios', {
  id: serial('id').primaryKey(),
  nombre: text('nombre').notNull(),
  email: text('email').notNull(),
  password: text('password').notNull(),
  documento: text('documento').notNull(),
  telefono: text('telefono').notNull(),
  rol: text('rol').notNull(),
  activo: boolean('activo').notNull().default(true),
  createdAt: text('created_at').default(sql`CURRENT_TIMESTAMP`),
}, table => [uniqueIndex('usuarios_email_unique').on(table.email)]);

const clientes = pgTable('clientes', {
  id: serial('id').primaryKey(),
  tipoDocumento: text('tipo_documento').notNull(),
  numeroDocumento: text('numero_documento').notNull(),
  nombreCompleto: text('nombre_completo').notNull(),
  telefono: text('telefono').notNull(),
  email: text('email'),
  direccion: text('direccion').notNull(),
  createdAt: text('created_at').default(sql`CURRENT_TIMESTAMP`),
}, table => [uniqueIndex('clientes_documento_unique').on(table.numeroDocumento)]);

const equipos = pgTable('equipos', {
  id: serial('id').primaryKey(),
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
  createdAt: text('created_at').default(sql`CURRENT_TIMESTAMP`),
});

const ordenes = pgTable('ordenes', {
  id: serial('id').primaryKey(),
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
  fechaIngreso: text('fecha_ingreso').default(sql`CURRENT_TIMESTAMP`),
  fechaLimiteSla: text('fecha_limite_sla'),
  fechaCierre: text('fecha_cierre'),
}, table => [uniqueIndex('ordenes_codigo_unique').on(table.codigoOrden)]);

const formatoOt = pgTable('formato_ot', {
  id: serial('id').primaryKey(),
  ordenId: integer('orden_id').notNull().references(() => ordenes.id, { onDelete: 'cascade' }),
  diagnosticoPreliminar: text('diagnostico_preliminar'),
  herramientasChips: text('herramientas_chips').default('[]'),
  tiempoEstimadoEntrega: text('tiempo_estimado_entrega'),
  accesorioCargador: boolean('accesorio_cargador').default(false),
  accesorioCablePoder: boolean('accesorio_cable_poder').default(false),
  accesorioMouse: boolean('accesorio_mouse').default(false),
  accesorioMaletin: boolean('accesorio_maletin').default(false),
  encendidoInicial: boolean('encendido_inicial').default(true),
  estadoCarcasa: text('estado_carcasa'),
  pinContrasena: text('pin_contrasena'),
});

const formatoActividades = pgTable('formato_actividades', {
  id: serial('id').primaryKey(),
  ordenId: integer('orden_id').notNull().references(() => ordenes.id, { onDelete: 'cascade' }),
  procedimientosRealizados: text('procedimientos_realizados'),
  pastaTermica: boolean('pasta_termica').default(false),
  alcoholIsopropilico: boolean('alcohol_isopropilico').default(false),
  sopleteadoContactos: boolean('sopleteado_contactos').default(false),
  brochaAntiestatica: boolean('brocha_antiestatica').default(false),
  panoMicrofibra: boolean('pano_microfibra').default(false),
  depuracionTemporales: boolean('depuracion_temporales').default(false),
  optimizacionInicio: boolean('optimizacion_inicio').default(false),
  escaneoMalware: boolean('escaneo_malware').default(false),
  actualizacionDrivers: boolean('actualizacion_drivers').default(false),
  comprobacionDisco: boolean('comprobacion_disco').default(false),
  qaEstresTermico: boolean('qa_estres_termico').default(false),
  qaPuertos: boolean('qa_puertos').default(false),
  qaConectividad: boolean('qa_conectividad').default(false),
  qaBateria: boolean('qa_bateria').default(false),
  qaTecladoTouchpad: boolean('qa_teclado_touchpad').default(false),
  costoManoObra: doublePrecision('costo_mano_obra').default(0),
  fechaActividad: text('fecha_actividad').default(sql`CURRENT_TIMESTAMP`),
});

const repuestosOrden = pgTable('repuestos_orden', {
  id: serial('id').primaryKey(),
  ordenId: integer('orden_id').notNull().references(() => ordenes.id, { onDelete: 'cascade' }),
  referencia: text('referencia').notNull(),
  cantidad: integer('cantidad').notNull().default(1),
  precioUnitario: doublePrecision('precio_unitario').notNull().default(0),
  createdAt: text('created_at').default(sql`CURRENT_TIMESTAMP`),
});

const formatoActaEntrega = pgTable('formato_acta_entrega', {
  id: serial('id').primaryKey(),
  ordenId: integer('orden_id').notNull().references(() => ordenes.id, { onDelete: 'cascade' }),
  estadoOperatividad: text('estado_operatividad').notNull().default('OPERATIVO'),
  observaciones: text('observaciones'),
  recomendacionesCuidado: text('recomendaciones_cuidado'),
  garantiaDias: integer('garantia_dias').default(30),
  personaRecibeNombre: text('persona_recibe_nombre').notNull(),
  personaRecibeDocumento: text('persona_recibe_documento').notNull(),
  checkConformidad: boolean('check_conformidad').default(false),
  firmaDigitalBase64: text('firma_digital_base64'),
  fechaEntrega: text('fecha_entrega').default(sql`CURRENT_TIMESTAMP`),
});

const fotosEvidencia = pgTable('fotos_evidencia', {
  id: serial('id').primaryKey(),
  ordenId: integer('orden_id').notNull().references(() => ordenes.id, { onDelete: 'cascade' }),
  etapa: text('etapa').notNull(),
  rutaOBytesBase64: text('ruta_o_bytes_base64').notNull(),
  notaTecnica: text('nota_tecnica'),
  fechaCaptura: text('fecha_captura').default(sql`CURRENT_TIMESTAMP`),
});

const configuracionEmpresa = pgTable('configuracion_empresa', {
  id: serial('id').primaryKey(),
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
  isSetupCompleted: boolean('is_setup_completed').default(false),
});

const notificacionesAuditoria = pgTable('notificaciones_auditoria', {
  id: serial('id').primaryKey(),
  destinatario: text('destinatario').notNull(),
  asunto: text('asunto').notNull(),
  evento: text('evento').notNull(),
  estado: text('estado').notNull(),
  fechaEnvio: text('fecha_envio').default(sql`CURRENT_TIMESTAMP`),
});

const tiposFalla = pgTable('tipos_falla', {
  id: serial('id').primaryKey(),
  tipoServicio: text('tipo_servicio').notNull(),
  nombre: text('nombre').notNull(),
  descripcion: text('descripcion'),
  activo: boolean('activo').default(true),
  createdAt: text('created_at').default(sql`CURRENT_TIMESTAMP`),
}, table => [uniqueIndex('tipos_falla_nombre_unique').on(table.nombre)]);

const auditoriaCambios = pgTable('auditoria_cambios', {
  id: serial('id').primaryKey(),
  usuarioId: integer('usuario_id').references(() => usuarios.id, { onDelete: 'set null' }),
  usuarioNombre: text('usuario_nombre').notNull(),
  metodo: text('metodo').notNull(),
  ruta: text('ruta').notNull(),
  fecha: text('fecha').notNull().default(sql`CURRENT_TIMESTAMP`),
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
