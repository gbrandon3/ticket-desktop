const db = require('../db');
const { formatOrden } = require('../serializers');

module.exports = app => {
  app.get('/api/ordenes', (req, res) => {
    try {
      const { busqueda, estado, tipo, solicitanteId } = req.query;
      const tecnicoId = req.user.rol === 'tecnico' ? req.user.id : req.query.tecnicoId;
      let sql = 'SELECT * FROM ordenes WHERE 1=1';
      const params = [];

      if (estado && estado !== 'TODOS') {
        sql += ' AND estado = ?';
        params.push(estado);
      }
      if (tipo && tipo !== 'TODOS') {
        sql += ' AND tipo_servicio = ?';
        params.push(tipo);
      }
      if (tecnicoId) {
        sql += ' AND tecnico_id = ?';
        params.push(parseInt(tecnicoId, 10));
      }
      if (solicitanteId) {
        sql += ' AND solicitante_id = ?';
        params.push(parseInt(solicitanteId, 10));
      }
      if (busqueda && busqueda.trim().length > 0) {
        const term = `%${busqueda.trim()}%`;
        sql += ' AND (codigo_orden LIKE ? OR titulo LIKE ? OR descripcion LIKE ?)';
        params.push(term, term, term);
      }
      sql += ' ORDER BY id DESC';

      const rows = db.prepare(sql).all(...params);
      res.json({ success: true, data: rows.map(formatOrden) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/ordenes/:id', (req, res) => {
    try {
      const id = parseInt(req.params.id, 10);
      const row = db.prepare('SELECT * FROM ordenes WHERE id = ?').get(id);
      if (!row) {
        return res.status(404).json({ success: false, error: 'Orden no encontrada' });
      }
      res.json({ success: true, data: formatOrden(row) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/ordenes', (req, res) => {
    try {
      const { cliente, equipo, orden, fotoIngresoBase64 } = req.body;

      const existingEquipment = db.prepare('SELECT * FROM equipos WHERE numero_serie = ?').get(equipo.numeroSerie.trim());
      if (existingEquipment) {
        const owner = db.prepare('SELECT numero_documento FROM clientes WHERE id = ?').get(existingEquipment.cliente_id);
        if (owner.numero_documento !== cliente.numeroDocumento.trim()) {
          return res.status(409).json({ success: false, error: 'Este serial pertenece a otro cliente; revise los datos del equipo' });
        }
        const openOrder = db.prepare("SELECT codigo_orden FROM ordenes WHERE equipo_id = ? AND estado <> 'ENTREGADO_CERRADO' LIMIT 1").get(existingEquipment.id);
        if (openOrder) {
          return res.status(409).json({ success: false, error: `El equipo ya tiene una orden abierta: ${openOrder.codigo_orden}` });
        }
      }

      // 1. Guardar o actualizar Cliente
      let cRow = db.prepare('SELECT * FROM clientes WHERE numero_documento = ?').get(cliente.numeroDocumento.trim());
      let clienteId;
      if (cRow) {
        clienteId = cRow.id;
        db.prepare(`
          UPDATE clientes SET
            tipo_documento = ?, nombre_completo = ?, telefono = ?, email = ?, direccion = ?
          WHERE id = ?
        `).run(cliente.tipoDocumento, cliente.nombreCompleto, cliente.telefono, cliente.email || null, cliente.direccion, clienteId);
      } else {
        const infoC = db.prepare(`
          INSERT INTO clientes (tipo_documento, numero_documento, nombre_completo, telefono, email, direccion)
          VALUES (?, ?, ?, ?, ?, ?)
        `).run(cliente.tipoDocumento, cliente.numeroDocumento.trim(), cliente.nombreCompleto, cliente.telefono, cliente.email || null, cliente.direccion);
        clienteId = infoC.lastInsertRowid;
      }

      // 2. Guardar o actualizar Equipo
      let eRow = null;
      if (equipo.numeroSerie && equipo.numeroSerie.trim().length > 0) {
        eRow = db.prepare('SELECT * FROM equipos WHERE numero_serie = ?').get(equipo.numeroSerie.trim());
      }
      let equipoId;
      if (eRow) {
        equipoId = eRow.id;
        db.prepare(`
          UPDATE equipos SET
            cliente_id = ?, tipo_equipo = ?, marca = ?, modelo = ?,
            sistema_operativo = ?, procesador = ?, memoria_ram = ?, almacenamiento = ?,
            tarjeta_grafica = ?, estado_equipo = 'EN_TALLER'
          WHERE id = ?
        `).run(
          clienteId, equipo.tipoEquipo, equipo.marca, equipo.modelo,
          equipo.sistemaOperativo || null, equipo.procesador || null,
          equipo.memoriaRam || null, equipo.almacenamiento || null,
          equipo.tarjetaGrafica || null, equipoId
        );
      } else {
        const infoE = db.prepare(`
          INSERT INTO equipos (
            cliente_id, tipo_equipo, marca, modelo, numero_serie,
            sistema_operativo, procesador, memoria_ram, almacenamiento,
            tarjeta_grafica, estado_equipo
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'EN_TALLER')
        `).run(
          clienteId, equipo.tipoEquipo, equipo.marca, equipo.modelo,
          equipo.numeroSerie.trim(),
          equipo.sistemaOperativo || null, equipo.procesador || null,
          equipo.memoriaRam || null, equipo.almacenamiento || null,
          equipo.tarjetaGrafica || null
        );
        equipoId = infoE.lastInsertRowid;
      }

      // 3. Generar código consecutivo de orden
      const year = new Date().getFullYear();
      const countRow = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE codigo_orden LIKE ?").get(`ORD-${year}-%`);
      const nextNum = (countRow.c + 1).toString().padStart(4, '0');
      const codigoOrden = `ORD-${year}-${nextNum}-${require('node:crypto').randomBytes(16).toString('hex').toUpperCase()}`;

      // 4. Insertar Orden
      const infoO = db.prepare(`
        INSERT INTO ordenes (
          codigo_orden, cliente_id, equipo_id, tecnico_id, solicitante_id,
          tipo_servicio, categoria_falla, prioridad, titulo, descripcion,
          estado, fecha_ingreso, fecha_limite_sla
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `).run(
        codigoOrden, clienteId, equipoId,
        orden.tecnicoId || null, orden.solicitanteId || null,
        orden.tipoServicio, orden.categoriaFalla, orden.prioridad,
        orden.titulo, orden.descripcion,
        orden.estado || 'RECIBIDO',
        orden.fechaIngreso || new Date().toISOString(),
        orden.fechaLimiteSla || null
      );
      const ordenId = infoO.lastInsertRowid;

      // 5. Foto de ingreso opcional
      if (fotoIngresoBase64) {
        db.prepare(`
          INSERT INTO fotos_evidencia (orden_id, etapa, ruta_o_bytes_base64, nota_tecnica, fecha_captura)
          VALUES (?, 'RECEPCION', ?, 'Foto de ingreso al radicar orden', datetime('now'))
        `).run(ordenId, fotoIngresoBase64);
      }

      res.json({ success: true, codigoOrden, ordenId });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.put('/api/ordenes/:id/estado', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const { nuevoEstado } = req.body;
      if (nuevoEstado === 'ENTREGADO_CERRADO') {
        db.prepare("UPDATE ordenes SET estado = ?, fecha_cierre = datetime('now') WHERE id = ?").run(nuevoEstado, ordenId);
      } else {
        db.prepare('UPDATE ordenes SET estado = ? WHERE id = ?').run(nuevoEstado, ordenId);
      }
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.put('/api/ordenes/:id/tecnico', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const { tecnicoId } = req.body;
      db.prepare('UPDATE ordenes SET tecnico_id = ? WHERE id = ?').run(tecnicoId ? parseInt(tecnicoId, 10) : null, ordenId);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
