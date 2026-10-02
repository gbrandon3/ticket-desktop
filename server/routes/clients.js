const db = require('../db');
const { formatCliente, formatEquipo, formatOrden } = require('../serializers');

module.exports = app => {
  app.get('/api/clientes', (req, res) => {
    try {
      const { q } = req.query;
      let rows;
      if (q && q.trim().length > 0) {
        const term = `%${q.trim()}%`;
        rows = db.prepare(`
          SELECT * FROM clientes
          WHERE nombre_completo LIKE ? OR numero_documento LIKE ? OR telefono LIKE ? OR email LIKE ?
          ORDER BY nombre_completo ASC
        `).all(term, term, term, term);
      } else {
        rows = db.prepare('SELECT * FROM clientes ORDER BY nombre_completo ASC').all();
      }
      res.json({ success: true, data: rows.map(formatCliente) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/clientes/documento/:doc', (req, res) => {
    try {
      const row = db.prepare('SELECT * FROM clientes WHERE numero_documento = ?').get(req.params.doc.trim());
      res.json({ success: true, data: formatCliente(row) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/clientes', (req, res) => {
    try {
      const c = req.body;
      let row = db.prepare('SELECT * FROM clientes WHERE numero_documento = ?').get(c.numeroDocumento.trim());
      if (row) {
        db.prepare(`
          UPDATE clientes SET
            tipo_documento = ?, nombre_completo = ?, telefono = ?, email = ?, direccion = ?
          WHERE id = ?
        `).run(c.tipoDocumento, c.nombreCompleto, c.telefono, c.email || null, c.direccion, row.id);
        row = db.prepare('SELECT * FROM clientes WHERE id = ?').get(row.id);
      } else {
        const info = db.prepare(`
          INSERT INTO clientes (tipo_documento, numero_documento, nombre_completo, telefono, email, direccion)
          VALUES (?, ?, ?, ?, ?, ?)
        `).run(c.tipoDocumento, c.numeroDocumento.trim(), c.nombreCompleto, c.telefono, c.email || null, c.direccion);
        row = db.prepare('SELECT * FROM clientes WHERE id = ?').get(info.lastInsertRowid);
      }
      res.json({ success: true, data: formatCliente(row) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/clientes/:id/equipos', (req, res) => {
    try {
      const clienteId = parseInt(req.params.id, 10);
      const rows = db.prepare('SELECT * FROM equipos WHERE cliente_id = ? ORDER BY id DESC').all(clienteId);
      res.json({ success: true, data: rows.map(formatEquipo) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/clientes/:id/ordenes', (req, res) => {
    try {
      const clienteId = parseInt(req.params.id, 10);
      const rows = db.prepare('SELECT * FROM ordenes WHERE cliente_id = ? ORDER BY id DESC').all(clienteId);
      res.json({ success: true, data: rows.map(formatOrden) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
