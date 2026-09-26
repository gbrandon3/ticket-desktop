const fs = require('fs');
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

const dataDir = path.join(__dirname, '..', 'data');
if (!fs.existsSync(dataDir)) {
  fs.mkdirSync(dataDir, { recursive: true });
}

const dbPath = path.join(dataDir, 'tickets.sqlite');
const db = new DatabaseSync(dbPath);

// Habilitar claves foráneas y WAL para alta concurrencia
db.exec('PRAGMA foreign_keys = ON;');
db.exec('PRAGMA journal_mode = WAL;');

// Inicializar tablas
db.exec(`
  CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    documento TEXT NOT NULL,
    telefono TEXT NOT NULL,
    rol TEXT NOT NULL,
    activo INTEGER DEFAULT 1,
    created_at TEXT DEFAULT (datetime('now'))
  );

  CREATE TABLE IF NOT EXISTS clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tipo_documento TEXT NOT NULL,
    numero_documento TEXT UNIQUE NOT NULL,
    nombre_completo TEXT NOT NULL,
    telefono TEXT NOT NULL,
    email TEXT,
    direccion TEXT NOT NULL,
    created_at TEXT DEFAULT (datetime('now'))
  );

  CREATE TABLE IF NOT EXISTS equipos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id) ON DELETE CASCADE,
    tipo_equipo TEXT NOT NULL,
    marca TEXT NOT NULL,
    modelo TEXT NOT NULL,
    numero_serie TEXT NOT NULL,
    sistema_operativo TEXT,
    procesador TEXT,
    memoria_ram TEXT,
    almacenamiento TEXT,
    tarjeta_grafica TEXT,
    estado_equipo TEXT DEFAULT 'OPERATIVO',
    created_at TEXT DEFAULT (datetime('now'))
  );

  CREATE TABLE IF NOT EXISTS ordenes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo_orden TEXT UNIQUE NOT NULL,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    equipo_id INTEGER NOT NULL REFERENCES equipos(id),
    tecnico_id INTEGER REFERENCES usuarios(id),
    solicitante_id INTEGER REFERENCES usuarios(id),
    tipo_servicio TEXT NOT NULL,
    categoria_falla TEXT NOT NULL,
    prioridad TEXT NOT NULL,
    titulo TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    estado TEXT DEFAULT 'RECIBIDO',
    fecha_ingreso TEXT DEFAULT (datetime('now')),
    fecha_limite_sla TEXT,
    fecha_cierre TEXT
  );

  CREATE TABLE IF NOT EXISTS formato_ot (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    orden_id INTEGER NOT NULL REFERENCES ordenes(id) ON DELETE CASCADE,
    diagnostico_preliminar TEXT,
    herramientas_chips TEXT DEFAULT '[]',
    tiempo_estimado_entrega TEXT,
    accesorio_cargador INTEGER DEFAULT 0,
    accesorio_cable_poder INTEGER DEFAULT 0,
    accesorio_mouse INTEGER DEFAULT 0,
    accesorio_maletin INTEGER DEFAULT 0,
    encendido_inicial INTEGER DEFAULT 1,
    estado_carcasa TEXT,
    pin_contrasena TEXT
  );

  CREATE TABLE IF NOT EXISTS formato_actividades (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    orden_id INTEGER NOT NULL REFERENCES ordenes(id) ON DELETE CASCADE,
    procedimientos_realizados TEXT,
    pasta_termica INTEGER DEFAULT 0,
    alcohol_isopropilico INTEGER DEFAULT 0,
    sopleteado_contactos INTEGER DEFAULT 0,
    brocha_antiestatica INTEGER DEFAULT 0,
    pano_microfibra INTEGER DEFAULT 0,
    depuracion_temporales INTEGER DEFAULT 0,
    optimizacion_inicio INTEGER DEFAULT 0,
    escaneo_malware INTEGER DEFAULT 0,
    actualizacion_drivers INTEGER DEFAULT 0,
    comprobacion_disco INTEGER DEFAULT 0,
    qa_estres_termico INTEGER DEFAULT 0,
    qa_puertos INTEGER DEFAULT 0,
    qa_conectividad INTEGER DEFAULT 0,
    qa_bateria INTEGER DEFAULT 0,
    qa_teclado_touchpad INTEGER DEFAULT 0,
    costo_mano_obra REAL DEFAULT 0,
    fecha_actividad TEXT DEFAULT (datetime('now'))
  );

  CREATE TABLE IF NOT EXISTS repuestos_orden (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    orden_id INTEGER NOT NULL REFERENCES ordenes(id) ON DELETE CASCADE,
    referencia TEXT NOT NULL,
    cantidad INTEGER NOT NULL DEFAULT 1,
    precio_unitario REAL NOT NULL DEFAULT 0,
    created_at TEXT DEFAULT (datetime('now'))
  );

  CREATE TABLE IF NOT EXISTS formato_acta_entrega (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    orden_id INTEGER NOT NULL REFERENCES ordenes(id) ON DELETE CASCADE,
    estado_operatividad TEXT NOT NULL DEFAULT 'OPERATIVO',
    observaciones TEXT,
    recomendaciones_cuidado TEXT,
    garantia_dias INTEGER DEFAULT 30,
    persona_recibe_nombre TEXT NOT NULL,
    persona_recibe_documento TEXT NOT NULL,
    check_conformidad INTEGER DEFAULT 0,
    firma_digital_base64 TEXT,
    fecha_entrega TEXT DEFAULT (datetime('now'))
  );

  CREATE TABLE IF NOT EXISTS fotos_evidencia (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    orden_id INTEGER NOT NULL REFERENCES ordenes(id) ON DELETE CASCADE,
    etapa TEXT NOT NULL,
    ruta_o_bytes_base64 TEXT NOT NULL,
    nota_tecnica TEXT,
    fecha_captura TEXT DEFAULT (datetime('now'))
  );

  CREATE TABLE IF NOT EXISTS configuracion_empresa (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre_empresa TEXT NOT NULL DEFAULT 'Santi Inc',
    slogan TEXT,
    nit TEXT,
    telefono TEXT,
    email TEXT,
    direccion TEXT,
    ciudad TEXT,
    logo_base64 TEXT,
    smtp_host TEXT DEFAULT 'smtp.gmail.com',
    smtp_port INTEGER DEFAULT 465,
    smtp_user TEXT,
    smtp_pass TEXT,
    smtp_api_url TEXT,
    portal_host_url TEXT DEFAULT 'http://localhost:3000',
    color_primario TEXT DEFAULT '#0F172A',
    color_secundario TEXT DEFAULT '#0284C7',
    is_setup_completed INTEGER DEFAULT 0
  );

  CREATE TABLE IF NOT EXISTS notificaciones_auditoria (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    destinatario TEXT NOT NULL,
    asunto TEXT NOT NULL,
    evento TEXT NOT NULL,
    estado TEXT NOT NULL,
    fecha_envio TEXT DEFAULT (datetime('now'))
  );

  CREATE TABLE IF NOT EXISTS tipos_falla (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tipo_servicio TEXT NOT NULL,
    nombre TEXT UNIQUE NOT NULL,
    descripcion TEXT,
    activo INTEGER DEFAULT 1,
    created_at TEXT DEFAULT (datetime('now'))
  );
`);

// Garantizar fila única en configuracion_empresa
const configRow = db.prepare('SELECT id FROM configuracion_empresa LIMIT 1').get();
if (!configRow) {
  db.prepare(`
    INSERT INTO configuracion_empresa (
      nombre_empresa, portal_host_url, is_setup_completed
    ) VALUES ('Santi Inc', 'http://localhost:3000', 0)
  `).run();
}

module.exports = db;
