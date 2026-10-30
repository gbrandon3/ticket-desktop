const { eq, asc } = require('drizzle-orm');
const { orm, schema } = require('../orm');
const { getEmpresaConfig } = require('../serializers');
const { hashPassword } = require('../security');

module.exports = app => {
  app.get('/api/config', (req, res) => {
    try {
      const config = getEmpresaConfig();
      const token = req.headers.authorization?.slice(7);
      const user = require('../security').sessionUser(token);
      if (user?.rol !== 'admin' && config) {
        delete config.smtpHost;
        delete config.smtpPort;
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
      let row = orm
        .select()
        .from(schema.configuracionEmpresa)
        .orderBy(asc(schema.configuracionEmpresa.id))
        .limit(1)
        .get();
      if (!row) {
        row = orm
          .insert(schema.configuracionEmpresa)
          .values({
            nombreEmpresa: 'Santi Inc',
            portalHostUrl: 'http://localhost:3000',
            isSetupCompleted: false,
          })
          .returning()
          .get();
      }
      const resolvedSmtpPass =
        !b.smtpPass || b.smtpPass === '********'
          ? row.smtpPass
          : require('../secrets').encrypt(b.smtpPass);

      orm
        .update(schema.configuracionEmpresa)
        .set({
          nombreEmpresa: b.nombreEmpresa || 'Santi Inc',
          slogan: b.slogan || null,
          nit: b.nit || null,
          telefono: b.telefono || null,
          email: b.email || null,
          direccion: b.direccion || null,
          ciudad: b.ciudad || null,
          logoBase64: b.logoBase64 || null,
          smtpHost: b.smtpHost || 'smtp.gmail.com',
          smtpPort: b.smtpPort ? parseInt(b.smtpPort, 10) : 465,
          smtpUser: b.smtpUser || null,
          smtpPass: resolvedSmtpPass,
          smtpApiUrl: b.smtpApiUrl || null,
          portalHostUrl: b.portalHostUrl || 'http://localhost:3000',
          colorPrimario: b.colorPrimario || '#0F172A',
          colorSecundario: b.colorSecundario || '#0284C7',
        })
        .where(eq(schema.configuracionEmpresa.id, row.id))
        .run();
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

      // 1. Actualizar configuración de la empresa y marcar is_setup_completed = true
      const firstConfig = orm
        .select({ id: schema.configuracionEmpresa.id })
        .from(schema.configuracionEmpresa)
        .orderBy(asc(schema.configuracionEmpresa.id))
        .limit(1)
        .get();

      if (firstConfig) {
        orm
          .update(schema.configuracionEmpresa)
          .set({
            nombreEmpresa: empresa.nombreEmpresa || 'Santi Inc',
            nit: empresa.nit || '',
            telefono: empresa.telefono || '',
            email: empresa.email || '',
            direccion: empresa.direccion || '',
            ciudad: empresa.ciudad || '',
            isSetupCompleted: true,
          })
          .where(eq(schema.configuracionEmpresa.id, firstConfig.id))
          .run();
      } else {
        orm
          .insert(schema.configuracionEmpresa)
          .values({
            nombreEmpresa: empresa.nombreEmpresa || 'Santi Inc',
            nit: empresa.nit || '',
            telefono: empresa.telefono || '',
            email: empresa.email || '',
            direccion: empresa.direccion || '',
            ciudad: empresa.ciudad || '',
            isSetupCompleted: true,
          })
          .run();
      }

      // 2. Insertar Administrador
      const adminValues = {
        nombre: admin.nombre || 'Administrador',
        email: admin.email.trim().toLowerCase(),
        password: hashPassword(admin.password),
        documento: admin.documento || '',
        telefono: admin.telefono || '',
        rol: 'admin',
        activo: true,
      };
      orm
        .insert(schema.usuarios)
        .values(adminValues)
        .onConflictDoUpdate({
          target: schema.usuarios.email,
          set: {
            nombre: adminValues.nombre,
            password: adminValues.password,
            documento: adminValues.documento,
            telefono: adminValues.telefono,
            rol: 'admin',
            activo: true,
          },
        })
        .run();

      // 3. Operador opcional
      if (operador && operador.email && operador.password) {
        const opValues = {
          nombre: operador.nombre || 'Operador',
          email: operador.email.trim().toLowerCase(),
          password: hashPassword(operador.password),
          documento: operador.documento || '',
          telefono: operador.telefono || '',
          rol: 'solicitante',
          activo: true,
        };
        orm
          .insert(schema.usuarios)
          .values(opValues)
          .onConflictDoUpdate({
            target: schema.usuarios.email,
            set: {
              nombre: opValues.nombre,
              password: opValues.password,
              documento: opValues.documento,
              telefono: opValues.telefono,
            },
          })
          .run();
      }

      // 4. Técnico opcional
      if (tecnico && tecnico.email && tecnico.password) {
        const tecValues = {
          nombre: tecnico.nombre || 'Técnico',
          email: tecnico.email.trim().toLowerCase(),
          password: hashPassword(tecnico.password),
          documento: tecnico.documento || '',
          telefono: tecnico.telefono || '',
          rol: 'tecnico',
          activo: true,
        };
        orm
          .insert(schema.usuarios)
          .values(tecValues)
          .onConflictDoUpdate({
            target: schema.usuarios.email,
            set: {
              nombre: tecValues.nombre,
              password: tecValues.password,
              documento: tecValues.documento,
              telefono: tecValues.telefono,
            },
          })
          .run();
      }

      res.json({ success: true, message: 'Setup inicial completado correctamente' });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
