const db = require('../db');
const { eq, and } = require('drizzle-orm');
const { orm, schema } = require('../orm');
const { formatUsuario } = require('../serializers');
const { hashPassword, verifyPassword, createSession, revokeUserSessions } = require('../security');

module.exports = app => {
  app.post('/api/auth/recover-password', (req, res) => {
    try {
      const { email, recoveryCode, newPassword } = req.body;
      if (!require('../recovery').verifyRecoveryCode(recoveryCode)) {
        return res.status(401).json({ success: false, error: 'Clave de recuperación inválida' });
      }
      const cleanEmail = email.trim().toLowerCase();
      const row = orm.select({ id: schema.usuarios.id }).from(schema.usuarios)
        .where(and(eq(schema.usuarios.email, cleanEmail), eq(schema.usuarios.activo, true))).get();
      if (!row) return res.status(404).json({ success: false, error: 'No existe una cuenta activa con ese correo' });
      orm.update(schema.usuarios).set({ password: hashPassword(newPassword) })
        .where(eq(schema.usuarios.id, row.id)).run();
      revokeUserSessions(row.id);
      res.json({ success: true, message: 'Contraseña restablecida. Ya puede iniciar sesión.' });
    } catch (err) {
      res.status(err.status || 500).json({ success: false, error: err.message || 'No se pudo restablecer la contraseña' });
    }
  });

  app.post('/api/auth/login', (req, res) => {
    try {
      const { email, password } = req.body;
      if (!email || !password) {
        return res.status(400).json({ success: false, error: 'Correo y contraseña requeridos' });
      }
      const cleanEmail = email.trim().toLowerCase();
      const cleanPass = password;

      const row = orm.select().from(schema.usuarios)
        .where(and(eq(schema.usuarios.email, cleanEmail), eq(schema.usuarios.activo, true))).get();
      if (!row || !verifyPassword(cleanPass, row.password)) {
        return res.status(401).json({ success: false, error: 'Credenciales inválidas o usuario inactivo' });
      }
      res.json({ success: true, usuario: formatUsuario(row), token: createSession(row.id) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/auth/me', (req, res) => {
    try {
      res.json({ success: true, usuario: formatUsuario(req.user) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo obtener la sesión actual' });
    }
  });

  app.get('/api/usuarios', (req, res) => {
    try {
      const rol = req.user.rol === 'admin' ? req.query.rol : 'tecnico';
      let rows;
      if (rol && rol !== 'TODOS') {
        rows = orm.select().from(schema.usuarios).where(eq(schema.usuarios.rol, rol))
          .orderBy(schema.usuarios.nombre).all();
      } else {
        rows = orm.select().from(schema.usuarios).orderBy(schema.usuarios.nombre).all();
      }
      res.json({ success: true, data: rows.map(formatUsuario) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/usuarios', (req, res) => {
    try {
      const u = req.body;
      const row = orm.insert(schema.usuarios).values({
        nombre: u.nombre, email: u.email.trim().toLowerCase(), password: hashPassword(u.password),
        documento: u.documento || '', telefono: u.telefono || '', rol: u.rol,
        activo: u.activo !== undefined ? Boolean(u.activo) : true,
      }).returning().get();
      res.json({ success: true, data: formatUsuario(row) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.put('/api/usuarios/:id', (req, res) => {
    try {
      const u = req.body;
      const id = parseInt(req.params.id, 10);
      const current = orm.select({ password: schema.usuarios.password }).from(schema.usuarios)
        .where(eq(schema.usuarios.id, id)).get();
      if (!current) return res.status(404).json({ success: false, error: 'Usuario no encontrado' });
      orm.update(schema.usuarios).set({
        nombre: u.nombre, email: u.email.trim().toLowerCase(),
        password: u.password ? hashPassword(u.password) : current.password,
        documento: u.documento, telefono: u.telefono, rol: u.rol, activo: Boolean(u.activo),
      }).where(eq(schema.usuarios.id, id)).run();
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
      orm.update(schema.usuarios).set({ activo: Boolean(activo) }).where(eq(schema.usuarios.id, id)).run();
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.delete('/api/usuarios/:id', (req, res) => {
    try {
      const id = parseInt(req.params.id, 10);
      orm.delete(schema.usuarios).where(eq(schema.usuarios.id, id)).run();
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
