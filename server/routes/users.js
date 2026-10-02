const db = require('../db');
const { formatUsuario } = require('../serializers');
const { hashPassword, verifyPassword, createSession, revokeUserSessions } = require('../security');
const toInt = val => val ? 1 : 0;

module.exports = app => {
  app.post('/api/auth/login', (req, res) => {
    try {
      const { email, password } = req.body;
      if (!email || !password) {
        return res.status(400).json({ success: false, error: 'Correo y contraseña requeridos' });
      }
      const cleanEmail = email.trim().toLowerCase();
      const cleanPass = password;

      const row = db.prepare('SELECT * FROM usuarios WHERE email = ? AND activo = 1').get(cleanEmail);
      if (!row || !verifyPassword(cleanPass, row.password)) {
        return res.status(401).json({ success: false, error: 'Credenciales inválidas o usuario inactivo' });
      }
      res.json({ success: true, usuario: formatUsuario(row), token: createSession(row.id) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/usuarios', (req, res) => {
    try {
      const rol = req.user.rol === 'admin' ? req.query.rol : 'tecnico';
      let rows;
      if (rol && rol !== 'TODOS') {
        rows = db.prepare('SELECT * FROM usuarios WHERE rol = ? ORDER BY nombre ASC').all(rol);
      } else {
        rows = db.prepare('SELECT * FROM usuarios ORDER BY nombre ASC').all();
      }
      res.json({ success: true, data: rows.map(formatUsuario) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
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
        hashPassword(u.password),
        u.documento || '',
        u.telefono || '',
        u.rol,
        toInt(u.activo !== undefined ? u.activo : true)
      );
      const row = db.prepare('SELECT * FROM usuarios WHERE id = ?').get(info.lastInsertRowid);
      res.json({ success: true, data: formatUsuario(row) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
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
        u.password ? hashPassword(u.password) : db.prepare('SELECT password FROM usuarios WHERE id = ?').get(id).password,
        u.documento,
        u.telefono,
        u.rol,
        toInt(u.activo),
        id
      );
      revokeUserSessions(id, req.user.id === id ? req.headers.authorization?.slice(7) : null);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.put('/api/usuarios/:id/toggle-activo', (req, res) => {
    try {
      const id = parseInt(req.params.id, 10);
      const { activo } = req.body;
      db.prepare('UPDATE usuarios SET activo = ? WHERE id = ?').run(toInt(activo), id);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.delete('/api/usuarios/:id', (req, res) => {
    try {
      const id = parseInt(req.params.id, 10);
      db.prepare('DELETE FROM usuarios WHERE id = ?').run(id);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
