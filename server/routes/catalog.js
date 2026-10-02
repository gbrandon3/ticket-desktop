const db = require('../db');
const { toBool } = require('../serializers');

module.exports = app => {
  app.get('/api/tipos-falla', (req, res) => {
    try {
      const { tipoServicio } = req.query;
      let rows;
      if (tipoServicio) {
        rows = db.prepare('SELECT * FROM tipos_falla WHERE tipo_servicio = ? AND activo = 1 ORDER BY nombre ASC').all(tipoServicio);
      } else {
        rows = db.prepare('SELECT * FROM tipos_falla WHERE activo = 1 ORDER BY nombre ASC').all();
      }
      res.json({
        success: true,
        data: rows.map(t => ({
          id: t.id,
          tipoServicio: t.tipo_servicio,
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
      const info = db.prepare(`
        INSERT INTO tipos_falla (tipo_servicio, nombre, descripcion, activo)
        VALUES (?, ?, ?, 1)
      `).run(tipoServicio, nombre.trim(), descripcion || null);
      res.json({
        success: true,
        data: { id: info.lastInsertRowid, tipoServicio, nombre, descripcion, activo: true },
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.delete('/api/tipos-falla/:id', (req, res) => {
    try {
      const id = parseInt(req.params.id, 10);
      db.prepare('DELETE FROM tipos_falla WHERE id = ?').run(id);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
