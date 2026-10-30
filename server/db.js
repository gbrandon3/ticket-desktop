const fs = require('fs');
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

const isVercel = !!process.env.VERCEL;
const dataDir = isVercel ? path.join('/tmp', 'data') : path.join(__dirname, '..', 'data');
try {
  if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir, { recursive: true });
  }
} catch (_) {}

const dbPath = process.env.TICKETS_DB_PATH || (isVercel ? ':memory:' : path.join(dataDir, 'tickets.sqlite'));
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

const shouldSeed = isVercel || !process.env.TICKETS_DB_PATH;

// Garantizar configuracion inicial de empresa
const configRow = db.prepare('SELECT id FROM configuracion_empresa LIMIT 1').get();
if (!configRow) {
  db.prepare(`
    INSERT INTO configuracion_empresa (
      nombre_empresa, nit, telefono, email, ciudad, direccion, portal_host_url, is_setup_completed
    ) VALUES (
      'SANTI INC', '922348710', '+57 3053633737', 'SantiINC@gmail.com', 'Monteria, Cordoba', 'Dg. 23, Montería, Córdoba', 'https://ticket-desktop.vercel.app', ?
    )
  `).run(shouldSeed ? 1 : 0);
} else if (shouldSeed) {
  db.prepare(`
    UPDATE configuracion_empresa
    SET nombre_empresa = 'SANTI INC',
        nit = '922348710',
        telefono = '+57 3053633737',
        email = 'SantiINC@gmail.com',
        ciudad = 'Monteria, Cordoba',
        direccion = 'Dg. 23, Montería, Córdoba',
        is_setup_completed = 1
    WHERE id = ?
  `).run(configRow.id);
}

// Garantizar cuentas base de usuarios iniciales con contraseña admin123
if (shouldSeed) {
  const defaultHash = 'scrypt:1efda6a42658955088bea609c3348a9a:8c16f449609946d81ca35cf1c36f50d13f3a8bd102a945b2b2eee91709a8bcb278de8aba24ee09c83495b4d5a61f8a981fb75f929d3e8d0d2bbb2a5b272aee0c';
  const baseUsers = [
    ['Santiago Matias Ojeda Cuadrado', 'matiasojeda1803@gmail.com', '1068423488', '3053633737', 'admin'],
    ['Celeste Azul Luna Palmera', 'lunapalmera@gmail.com', '1068423489', '3124698356', 'solicitante'],
    ['Santiago Andres Quintana Martinez', 'quitana16@gmail.com', '1068423490', '3244275335', 'tecnico'],
    ['Administrador', 'admin@admin.com', '1423512', '543215', 'admin']
  ];

  for (const [nombre, email, doc, tel, rol] of baseUsers) {
    db.prepare(`
      INSERT INTO usuarios (nombre, email, password, documento, telefono, rol, activo)
      VALUES (?, ?, ?, ?, ?, ?, 1)
      ON CONFLICT (email) DO UPDATE SET
        nombre = excluded.nombre,
        password = excluded.password,
        documento = excluded.documento,
        telefono = excluded.telefono,
        rol = excluded.rol,
        activo = 1
    `).run(nombre, email, defaultHash, doc, tel, rol);
  }

  // Garantizar únicamente el cliente oficial del usuario (Santiago Matias Ojeda Cuadrado)
  db.prepare(`
    INSERT INTO clientes (tipo_documento, numero_documento, nombre_completo, telefono, email, direccion)
    VALUES ('CC', '1068423488', 'Santiago Matias Ojeda Cuadrado', '3053633737', 'matiasojeda1803@gmail.com', 'Dg. 23, Montería, Córdoba')
    ON CONFLICT (numero_documento) DO NOTHING
  `).run();
}

module.exports = db;
