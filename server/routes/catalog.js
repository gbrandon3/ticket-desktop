const { eq, and, asc } = require('drizzle-orm');
const { orm, schema } = require('../orm');
const { toBool } = require('../serializers');

module.exports = app => {
  app.get('/api/tipos-falla', (req, res) => {
    try {
      const { tipoServicio } = req.query;
      let rows;
      if (tipoServicio) {
        rows = orm
          .select()
          .from(schema.tiposFalla)
          .where(and(eq(schema.tiposFalla.tipoServicio, tipoServicio), eq(schema.tiposFalla.activo, true)))
          .orderBy(asc(schema.tiposFalla.nombre))
          .all();
      } else {
        rows = orm
          .select()
          .from(schema.tiposFalla)
          .where(eq(schema.tiposFalla.activo, true))
          .orderBy(asc(schema.tiposFalla.nombre))
          .all();
      }
      res.json({
        success: true,
        data: rows.map(t => ({
          id: t.id,
          tipoServicio: t.tipoServicio,
          nombre: t.nombre,
          descripcion: t.descripcion,
          activo: toBool(t.activo),
        })),
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/tipos-falla', (req, res) => {
    try {
      const { tipoServicio, nombre, descripcion } = req.body;
      const inserted = orm
        .insert(schema.tiposFalla)
        .values({
          tipoServicio,
          nombre: nombre.trim(),
          descripcion: descripcion || null,
          activo: true,
        })
        .returning()
        .get();
      res.json({
        success: true,
        data: { id: inserted.id, tipoServicio, nombre, descripcion, activo: true },
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.delete('/api/tipos-falla/:id', (req, res) => {
    try {
      const id = parseInt(req.params.id, 10);
      orm.delete(schema.tiposFalla).where(eq(schema.tiposFalla.id, id)).run();
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
