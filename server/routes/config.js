const db = require('../db');
const { getEmpresaConfig } = require('../serializers');
const { hashPassword } = require('../security');

module.exports = app => {
  app.get('/api/config', (req, res) => {
    try {
      const config = getEmpresaConfig();
      const token = req.headers.authorization?.slice(7);
      const user = require('../security').sessionUser(token);
      if (user?.rol !== 'admin' && config) {
        delete config.smtpHost; delete config.smtpPort;
        config.smtpUser = config.smtpUser ? 'configurado' : null;
        // A boolean placeholder allows the UI to show whether mail is configured.
        config.smtpPass = config.smtpPass ? '********' : null;
        delete config.smtpApiUrl;
      }
      res.json({ success: true, data: config });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/config', (req, res) => {
    try {
      const b = req.body;
      let row = db.prepare('SELECT id FROM configuracion_empresa ORDER BY id ASC LIMIT 1').get();
      if (!row) {
        db.prepare(`
          INSERT INTO configuracion_empresa (
            nombre_empresa, portal_host_url, is_setup_completed
          ) VALUES ('Santi Inc', 'http://localhost:3000', 0)
        `).run();
        row = db.prepare('SELECT id FROM configuracion_empresa ORDER BY id ASC LIMIT 1').get();
      }
      db.prepare(`
        UPDATE configuracion_empresa SET
          nombre_empresa = ?, slogan = ?, nit = ?, telefono = ?, email = ?,
          direccion = ?, ciudad = ?, logo_base64 = ?, smtp_host = ?,
          smtp_port = ?, smtp_user = ?, smtp_pass = ?, smtp_api_url = ?,
          portal_host_url = ?, color_primario = ?, color_secundario = ?
        WHERE id = ?
      `).run(
        b.nombreEmpresa || 'Santi Inc',
        b.slogan || null,
        b.nit || null,
        b.telefono || null,
        b.email || null,
        b.direccion || null,
        b.ciudad || null,
        b.logoBase64 || null,
        b.smtpHost || 'smtp.gmail.com',
        b.smtpPort ? parseInt(b.smtpPort, 10) : 465,
        b.smtpUser || null,
        (!b.smtpPass || b.smtpPass === '********') ? db.prepare('SELECT smtp_pass FROM configuracion_empresa WHERE id = ?').get(row.id).smtp_pass : require('../secrets').encrypt(b.smtpPass),
        b.smtpApiUrl || null,
        b.portalHostUrl || 'http://localhost:3000',
        b.colorPrimario || '#0F172A',
        b.colorSecundario || '#0284C7',
        row.id
      );
      res.json({ success: true, message: 'Configuración actualizada con éxito' });
    } catch (err) {
      console.error('Error actualizando configuracion_empresa:', err);
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/setup/status', (req, res) => {
    try {
      const config = getEmpresaConfig();
      res.json({ success: true, isSetupCompleted: config ? config.isSetupCompleted : false, empresa: null });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/setup', (req, res) => {
    try {
      const { empresa, admin, operador, tecnico } = req.body;
      if (!admin || !admin.email || !admin.password) {
        return res.status(400).json({ success: false, error: 'Credenciales del administrador incompletas' });
      }

      // 1. Actualizar configuración de la empresa y marcar is_setup_completed = 1
      db.prepare(`
        UPDATE configuracion_empresa SET
          nombre_empresa = ?, nit = ?, telefono = ?, email = ?,
          direccion = ?, ciudad = ?, is_setup_completed = 1
        WHERE id = (SELECT id FROM configuracion_empresa ORDER BY id ASC LIMIT 1)
      `).run(
        empresa.nombreEmpresa || 'Santi Inc',
        empresa.nit || '',
        empresa.telefono || '',
        empresa.email || '',
        empresa.direccion || '',
        empresa.ciudad || ''
      );

      // 2. Insertar Administrador
      db.prepare(`
        INSERT INTO usuarios (nombre, email, password, documento, telefono, rol, activo)
        VALUES (?, ?, ?, ?, ?, 'admin', 1)
        ON CONFLICT(email) DO UPDATE SET
          nombre = excluded.nombre,
          password = excluded.password,
          documento = excluded.documento,
          telefono = excluded.telefono,
          rol = 'admin',
          activo = 1
      `).run(
        admin.nombre || 'Administrador',
        admin.email.trim().toLowerCase(),
        hashPassword(admin.password),
        admin.documento || '',
        admin.telefono || ''
      );

      // 3. Operador opcional
      if (operador && operador.email && operador.password) {
        db.prepare(`
          INSERT INTO usuarios (nombre, email, password, documento, telefono, rol, activo)
          VALUES (?, ?, ?, ?, ?, 'solicitante', 1)
          ON CONFLICT(email) DO UPDATE SET
            nombre = excluded.nombre,
            password = excluded.password,
            documento = excluded.documento,
            telefono = excluded.telefono
        `).run(
          operador.nombre || 'Operador',
          operador.email.trim().toLowerCase(),
          hashPassword(operador.password),
          operador.documento || '',
          operador.telefono || ''
        );
      }

      // 4. Técnico opcional
      if (tecnico && tecnico.email && tecnico.password) {
        db.prepare(`
          INSERT INTO usuarios (nombre, email, password, documento, telefono, rol, activo)
          VALUES (?, ?, ?, ?, ?, 'tecnico', 1)
          ON CONFLICT(email) DO UPDATE SET
            nombre = excluded.nombre,
            password = excluded.password,
            documento = excluded.documento,
            telefono = excluded.telefono
        `).run(
          tecnico.nombre || 'Técnico',
          tecnico.email.trim().toLowerCase(),
          hashPassword(tecnico.password),
          tecnico.documento || '',
          tecnico.telefono || ''
        );
      }

      res.json({ success: true, message: 'Setup inicial completado correctamente' });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
