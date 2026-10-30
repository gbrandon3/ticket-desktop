const { eq, or, like, asc, desc } = require('drizzle-orm');
const { orm, schema } = require('../orm');
const { formatCliente, formatEquipo, formatOrden } = require('../serializers');

module.exports = app => {
  app.get('/api/clientes', (req, res) => {
    try {
      const { q } = req.query;
      let rows;
      if (q && q.trim().length > 0) {
        const term = `%${q.trim()}%`;
        rows = orm
          .select()
          .from(schema.clientes)
          .where(
            or(
              like(schema.clientes.nombreCompleto, term),
              like(schema.clientes.numeroDocumento, term),
              like(schema.clientes.telefono, term),
              like(schema.clientes.email, term)
            )
          )
          .orderBy(asc(schema.clientes.nombreCompleto))
          .all();
      } else {
        rows = orm
          .select()
          .from(schema.clientes)
          .orderBy(asc(schema.clientes.nombreCompleto))
          .all();
      }
      res.json({ success: true, data: rows.map(formatCliente) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/clientes/documento/:doc', (req, res) => {
    try {
      const row = orm
        .select()
        .from(schema.clientes)
        .where(eq(schema.clientes.numeroDocumento, req.params.doc.trim()))
        .get();
      res.json({ success: true, data: formatCliente(row) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/clientes', (req, res) => {
    try {
      const c = req.body;
      let row = orm
        .select()
        .from(schema.clientes)
        .where(eq(schema.clientes.numeroDocumento, c.numeroDocumento.trim()))
        .get();
      if (row) {
        row = orm
          .update(schema.clientes)
          .set({
            tipoDocumento: c.tipoDocumento,
            nombreCompleto: c.nombreCompleto,
            telefono: c.telefono,
            email: c.email || null,
            direccion: c.direccion,
          })
          .where(eq(schema.clientes.id, row.id))
          .returning()
          .get();
      } else {
        row = orm
          .insert(schema.clientes)
          .values({
            tipoDocumento: c.tipoDocumento,
            numeroDocumento: c.numeroDocumento.trim(),
            nombreCompleto: c.nombreCompleto,
            telefono: c.telefono,
            email: c.email || null,
            direccion: c.direccion,
          })
          .returning()
          .get();
      }
      res.json({ success: true, data: formatCliente(row) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/clientes/:id/equipos', (req, res) => {
    try {
      const clienteId = parseInt(req.params.id, 10);
      const rows = orm
        .select()
        .from(schema.equipos)
        .where(eq(schema.equipos.clienteId, clienteId))
        .orderBy(desc(schema.equipos.id))
        .all();
      res.json({ success: true, data: rows.map(formatEquipo) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/clientes/:id/ordenes', (req, res) => {
    try {
      const clienteId = parseInt(req.params.id, 10);
      const rows = orm
        .select()
        .from(schema.ordenes)
        .where(eq(schema.ordenes.clienteId, clienteId))
        .orderBy(desc(schema.ordenes.id))
        .all();
      res.json({ success: true, data: rows.map(formatOrden) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
