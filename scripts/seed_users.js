const db = require('../server/db');
const { hashPassword } = require('../server/security');
const pass = hashPassword('admin123');

db.prepare(`
  UPDATE configuracion_empresa
  SET nombre_empresa = 'SANTI INC',
      nit = '922348710',
      telefono = '+57 3053633737',
      email = 'SantiINC@gmail.com',
      ciudad = 'Monteria, Cordoba',
      direccion = 'Dg. 23, Montería, Córdoba',
      is_setup_completed = 1
  WHERE id = 1
`).run();

const users = [
  ['Santiago Matias Ojeda Cuadrado', 'matiasojeda1803@gmail.com', '1068423488', '3053633737', 'admin'],
  ['Celeste Azul Luna Palmera', 'lunapalmera@gmail.com', '1068423489', '3124698356', 'solicitante'],
  ['Santiago Andres Quintana Martinez', 'quitana16@gmail.com', '1068423490', '3244275335', 'tecnico'],
  ['Administrador', 'admin@admin.com', '1423512', '543215', 'admin']
];

for (const [nombre, email, documento, telefono, rol] of users) {
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
  `).run(nombre, email, pass, documento, telefono, rol);
}

console.log('Local SQLite users successfully updated:');
console.log(db.prepare('SELECT id, nombre, email, rol FROM usuarios').all());
