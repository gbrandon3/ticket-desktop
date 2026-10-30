const { eq, and, or, like, desc } = require('drizzle-orm');
const { orm, schema } = require('../orm');
const { formatEquipo, formatOrden } = require('../serializers');

module.exports = app => {
  app.get('/api/equipos', (req, res) => {
    try {
      const { tipo, estado, busqueda, clienteId } = req.query;
      const conditions = [];

      if (clienteId) {
        conditions.push(eq(schema.equipos.clienteId, parseInt(clienteId, 10)));
      }
      if (tipo && tipo !== 'TODOS') {
        conditions.push(eq(schema.equipos.tipoEquipo, tipo));
      }
      if (estado && estado !== 'TODOS') {
        conditions.push(eq(schema.equipos.estadoEquipo, estado));
      }
      if (busqueda && busqueda.trim().length > 0) {
        const term = `%${busqueda.trim()}%`;
        conditions.push(
          or(
            like(schema.equipos.numeroSerie, term),
            like(schema.equipos.marca, term),
            like(schema.equipos.modelo, term),
            like(schema.clientes.nombreCompleto, term)
          )
        );
      }

      const query = orm
        .select({ equipo: schema.equipos, clienteNombre: schema.clientes.nombreCompleto })
        .from(schema.equipos)
        .innerJoin(schema.clientes, eq(schema.equipos.clienteId, schema.clientes.id));

      const joinedRows = (conditions.length > 0 ? query.where(and(...conditions)) : query)
        .orderBy(desc(schema.equipos.id))
        .all();

      res.json({ success: true, data: joinedRows.map(r => formatEquipo(r.equipo)) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/equipos/:id/historial', (req, res) => {
    try {
      const equipoId = parseInt(req.params.id, 10);
      const rows = orm
        .select()
        .from(schema.ordenes)
        .where(eq(schema.ordenes.equipoId, equipoId))
        .orderBy(desc(schema.ordenes.id))
        .all();
      res.json({ success: true, data: rows.map(formatOrden) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.put('/api/equipos/:id/estado', (req, res) => {
    try {
      const equipoId = parseInt(req.params.id, 10);
      const { nuevoEstado } = req.body;
      orm
        .update(schema.equipos)
        .set({ estadoEquipo: nuevoEstado })
        .where(eq(schema.equipos.id, equipoId))
        .run();
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
