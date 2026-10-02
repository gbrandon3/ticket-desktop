const db = require('../db');
const { formatEquipo, formatOrden } = require('../serializers');

module.exports = app => {
  app.get('/api/equipos', (req, res) => {
    try {
      const { tipo, estado, busqueda, clienteId } = req.query;
      let sql = 'SELECT e.*, c.nombre_completo as cliente_nombre FROM equipos e JOIN clientes c ON e.cliente_id = c.id WHERE 1=1';
      const params = [];

      if (clienteId) {
        sql += ' AND e.cliente_id = ?';
        params.push(parseInt(clienteId, 10));
      }
      if (tipo && tipo !== 'TODOS') {
        sql += ' AND e.tipo_equipo = ?';
        params.push(tipo);
      }
      if (estado && estado !== 'TODOS') {
        sql += ' AND e.estado_equipo = ?';
        params.push(estado);
      }
      if (busqueda && busqueda.trim().length > 0) {
        const term = `%${busqueda.trim()}%`;
        sql += ' AND (e.numero_serie LIKE ? OR e.marca LIKE ? OR e.modelo LIKE ? OR c.nombre_completo LIKE ?)';
        params.push(term, term, term, term);
      }
      sql += ' ORDER BY e.id DESC';

      const rows = db.prepare(sql).all(...params);
      res.json({ success: true, data: rows.map(formatEquipo) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/equipos/:id/historial', (req, res) => {
    try {
      const equipoId = parseInt(req.params.id, 10);
      const rows = db.prepare('SELECT * FROM ordenes WHERE equipo_id = ? ORDER BY id DESC').all(equipoId);
      res.json({ success: true, data: rows.map(formatOrden) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.put('/api/equipos/:id/estado', (req, res) => {
    try {
      const equipoId = parseInt(req.params.id, 10);
      const { nuevoEstado } = req.body;
      db.prepare('UPDATE equipos SET estado_equipo = ? WHERE id = ?').run(nuevoEstado, equipoId);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
