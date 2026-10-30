const { DatabaseSync } = require('node:sqlite');
const fs = require('fs');

if (fs.existsSync('data/tickets.sqlite')) {
  const db = new DatabaseSync('data/tickets.sqlite');
  db.exec('PRAGMA foreign_keys = OFF;');

  const tablesToDelete = [
    'fotos_evidencia',
    'repuestos_orden',
    'formato_ot',
    'formato_actividades',
    'formato_acta_entrega',
    'cambios_orden',
    'historial_cambios',
    'auditoria',
    'ordenes',
    'equipos'
  ];

  for (const table of tablesToDelete) {
    try {
      db.exec(`DELETE FROM ${table};`);
    } catch (_) {}
  }

  // Limpiar clientes de prueba que no sean Santiago Matias Ojeda Cuadrado
  db.exec("DELETE FROM clientes WHERE numero_documento != '1068423488';");

  // Registrar cliente de Santiago Matias Ojeda Cuadrado
  const santiagoClient = db.prepare("SELECT id FROM clientes WHERE numero_documento = '1068423488'").get();
  if (!santiagoClient) {
    db.prepare(`
      INSERT INTO clientes (tipo_documento, numero_documento, nombre_completo, telefono, email, direccion)
      VALUES ('CC', '1068423488', 'Santiago Matias Ojeda Cuadrado', '3053633737', 'matiasojeda1803@gmail.com', 'Dg. 23, Montería, Córdoba')
    `).run();
  }

  // Dejar únicamente los usuarios oficiales
  db.exec(`
    DELETE FROM usuarios 
    WHERE email NOT IN (
      'matiasojeda1803@gmail.com',
      'lunapalmera@gmail.com',
      'quitana16@gmail.com',
      'admin@admin.com'
    );
  `);

  db.exec('PRAGMA foreign_keys = ON;');

  console.log('Clientes restantes en SQLite local:', db.prepare('SELECT id, nombre_completo, numero_documento, email FROM clientes').all());
  console.log('Órdenes restantes en SQLite local:', db.prepare('SELECT count(*) as total FROM ordenes').get());
  console.log('Usuarios restantes en SQLite local:', db.prepare('SELECT id, nombre, email, rol FROM usuarios').all());
}
