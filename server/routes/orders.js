const crypto = require('node:crypto');
const { eq, ne, and, or, like, desc, count } = require('drizzle-orm');
const { orm, schema } = require('../orm');
const { formatOrden } = require('../serializers');

module.exports = app => {
  app.get('/api/ordenes', (req, res) => {
    try {
      const { busqueda, estado, tipo, solicitanteId } = req.query;
      const tecnicoId = req.user.rol === 'tecnico' ? req.user.id : req.query.tecnicoId;
      const conditions = [];

      if (estado && estado !== 'TODOS') {
        conditions.push(eq(schema.ordenes.estado, estado));
      }
      if (tipo && tipo !== 'TODOS') {
        conditions.push(eq(schema.ordenes.tipoServicio, tipo));
      }
      if (tecnicoId) {
        conditions.push(eq(schema.ordenes.tecnicoId, parseInt(tecnicoId, 10)));
      }
      if (solicitanteId) {
        conditions.push(eq(schema.ordenes.solicitanteId, parseInt(solicitanteId, 10)));
      }
      if (busqueda && busqueda.trim().length > 0) {
        const term = `%${busqueda.trim()}%`;
        conditions.push(
          or(
            like(schema.ordenes.codigoOrden, term),
            like(schema.ordenes.titulo, term),
            like(schema.ordenes.descripcion, term)
          )
        );
      }

      const query = orm.select().from(schema.ordenes);
      const rows = (conditions.length > 0 ? query.where(and(...conditions)) : query)
        .orderBy(desc(schema.ordenes.id))
        .all();

      res.json({ success: true, data: rows.map(formatOrden) });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/ordenes/:id', (req, res) => {
    try {
      const id = parseInt(req.params.id, 10);
      const row = orm.select().from(schema.ordenes).where(eq(schema.ordenes.id, id)).get();
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

      const existingEquipment = orm
        .select()
        .from(schema.equipos)
        .where(eq(schema.equipos.numeroSerie, equipo.numeroSerie.trim()))
        .get();

      if (existingEquipment) {
        const owner = orm
          .select({ numeroDocumento: schema.clientes.numeroDocumento })
          .from(schema.clientes)
          .where(eq(schema.clientes.id, existingEquipment.clienteId))
          .get();
        if (owner.numeroDocumento !== cliente.numeroDocumento.trim()) {
          return res.status(409).json({
            success: false,
            error: 'Este serial pertenece a otro cliente; revise los datos del equipo',
          });
        }
        const openOrder = orm
          .select({ codigoOrden: schema.ordenes.codigoOrden })
          .from(schema.ordenes)
          .where(
            and(
              eq(schema.ordenes.equipoId, existingEquipment.id),
              ne(schema.ordenes.estado, 'ENTREGADO_CERRADO')
            )
          )
          .limit(1)
          .get();
        if (openOrder) {
          return res.status(409).json({
            success: false,
            error: `El equipo ya tiene una orden abierta: ${openOrder.codigoOrden}`,
          });
        }
      }

      // 1. Guardar o actualizar Cliente
      let cRow = orm
        .select()
        .from(schema.clientes)
        .where(eq(schema.clientes.numeroDocumento, cliente.numeroDocumento.trim()))
        .get();
      let clienteId;
      if (cRow) {
        clienteId = cRow.id;
        orm
          .update(schema.clientes)
          .set({
            tipoDocumento: cliente.tipoDocumento,
            nombreCompleto: cliente.nombreCompleto,
            telefono: cliente.telefono,
            email: cliente.email || null,
            direccion: cliente.direccion,
          })
          .where(eq(schema.clientes.id, clienteId))
          .run();
      } else {
        const insertedC = orm
          .insert(schema.clientes)
          .values({
            tipoDocumento: cliente.tipoDocumento,
            numeroDocumento: cliente.numeroDocumento.trim(),
            nombreCompleto: cliente.nombreCompleto,
            telefono: cliente.telefono,
            email: cliente.email || null,
            direccion: cliente.direccion,
          })
          .returning({ id: schema.clientes.id })
          .get();
        clienteId = insertedC.id;
      }

      // 2. Guardar o actualizar Equipo
      let eRow = null;
      if (equipo.numeroSerie && equipo.numeroSerie.trim().length > 0) {
        eRow = orm
          .select()
          .from(schema.equipos)
          .where(eq(schema.equipos.numeroSerie, equipo.numeroSerie.trim()))
          .get();
      }
      let equipoId;
      if (eRow) {
        equipoId = eRow.id;
        orm
          .update(schema.equipos)
          .set({
            clienteId,
            tipoEquipo: equipo.tipoEquipo,
            marca: equipo.marca,
            modelo: equipo.modelo,
            sistemaOperativo: equipo.sistemaOperativo || null,
            procesador: equipo.procesador || null,
            memoriaRam: equipo.memoriaRam || null,
            almacenamiento: equipo.almacenamiento || null,
            tarjetaGrafica: equipo.tarjetaGrafica || null,
            estadoEquipo: 'EN_TALLER',
          })
          .where(eq(schema.equipos.id, equipoId))
          .run();
      } else {
        const insertedE = orm
          .insert(schema.equipos)
          .values({
            clienteId,
            tipoEquipo: equipo.tipoEquipo,
            marca: equipo.marca,
            modelo: equipo.modelo,
            numeroSerie: equipo.numeroSerie.trim(),
            sistemaOperativo: equipo.sistemaOperativo || null,
            procesador: equipo.procesador || null,
            memoriaRam: equipo.memoriaRam || null,
            almacenamiento: equipo.almacenamiento || null,
            tarjetaGrafica: equipo.tarjetaGrafica || null,
            estadoEquipo: 'EN_TALLER',
          })
          .returning({ id: schema.equipos.id })
          .get();
        equipoId = insertedE.id;
      }

      // 3. Generar código consecutivo de orden
      const year = new Date().getFullYear();
      const countRow = orm
        .select({ c: count() })
        .from(schema.ordenes)
        .where(like(schema.ordenes.codigoOrden, `ORD-${year}-%`))
        .get();
      const nextNum = ((countRow?.c || 0) + 1).toString().padStart(4, '0');
      const codigoOrden = `ORD-${year}-${nextNum}-${crypto.randomBytes(16).toString('hex').toUpperCase()}`;

      // 4. Insertar Orden
      const insertedO = orm
        .insert(schema.ordenes)
        .values({
          codigoOrden,
          clienteId,
          equipoId,
          tecnicoId: orden.tecnicoId || null,
          solicitanteId: orden.solicitanteId || null,
          tipoServicio: orden.tipoServicio,
          categoriaFalla: orden.categoriaFalla,
          prioridad: orden.prioridad,
          titulo: orden.titulo,
          descripcion: orden.descripcion,
          estado: orden.estado || 'RECIBIDO',
          fechaIngreso: orden.fechaIngreso || new Date().toISOString(),
          fechaLimiteSla: orden.fechaLimiteSla || null,
        })
        .returning({ id: schema.ordenes.id })
        .get();
      const ordenId = insertedO.id;

      // 5. Foto de ingreso opcional
      if (fotoIngresoBase64) {
        orm
          .insert(schema.fotosEvidencia)
          .values({
            ordenId,
            etapa: 'RECEPCION',
            rutaOBytesBase64: fotoIngresoBase64,
            notaTecnica: 'Foto de ingreso al radicar orden',
            fechaCaptura: new Date().toISOString(),
          })
          .run();
      }

      res.json({ success: true, codigoOrden, ordenId });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.put('/api/ordenes/:id/estado', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const nuevoEstado = req.body.nuevoEstado || req.body.estado;
      const updateValues =
        nuevoEstado === 'ENTREGADO_CERRADO'
          ? { estado: nuevoEstado, fechaCierre: new Date().toISOString() }
          : { estado: nuevoEstado };
      orm
        .update(schema.ordenes)
        .set(updateValues)
        .where(eq(schema.ordenes.id, ordenId))
        .run();
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.put('/api/ordenes/:id/tecnico', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const { tecnicoId } = req.body;
      orm
        .update(schema.ordenes)
        .set({ tecnicoId: tecnicoId ? parseInt(tecnicoId, 10) : null })
        .where(eq(schema.ordenes.id, ordenId))
        .run();
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.delete('/api/ordenes/:id', async (req, res) => {
    try {
      if (req.user?.rol !== 'admin') {
        return res.status(403).json({ success: false, error: 'Solo los administradores pueden eliminar órdenes de servicio' });
      }
      const ordenId = parseInt(req.params.id, 10);
      const row = orm.select().from(schema.ordenes).where(eq(schema.ordenes.id, ordenId)).get();
      if (!row) {
        return res.status(404).json({ success: false, error: 'Orden no encontrada' });
      }

      // 1. Limpiar registros técnicos hijos asociados a la orden
      // (NO se tocan clientes ni equipos)
      const db = require('../db');
      db.prepare('DELETE FROM fotos_evidencia WHERE orden_id = ?').run(ordenId);
      db.prepare('DELETE FROM formato_acta_entrega WHERE orden_id = ?').run(ordenId);
      db.prepare('DELETE FROM repuestos_orden WHERE orden_id = ?').run(ordenId);
      db.prepare('DELETE FROM formato_actividades WHERE orden_id = ?').run(ordenId);
      db.prepare('DELETE FROM formato_ot WHERE orden_id = ?').run(ordenId);

      // 2. Eliminar la orden
      db.prepare('DELETE FROM ordenes WHERE id = ?').run(ordenId);

      // 3. Eliminación síncrona en Supabase si está conectado
      const { isSyncEnabled, supabaseRequest } = require('../supabase-sync');
      if (isSyncEnabled()) {
        try {
          await supabaseRequest('DELETE', `/rest/v1/fotos_evidencia?orden_id=eq.${ordenId}`).catch(() => {});
          await supabaseRequest('DELETE', `/rest/v1/formato_acta_entrega?orden_id=eq.${ordenId}`).catch(() => {});
          await supabaseRequest('DELETE', `/rest/v1/repuestos_orden?orden_id=eq.${ordenId}`).catch(() => {});
          await supabaseRequest('DELETE', `/rest/v1/formato_actividades?orden_id=eq.${ordenId}`).catch(() => {});
          await supabaseRequest('DELETE', `/rest/v1/formato_ot?orden_id=eq.${ordenId}`).catch(() => {});
          await supabaseRequest('DELETE', `/rest/v1/ordenes?id=eq.${ordenId}`).catch(() => {});
        } catch (_) {}
      }

      res.json({ success: true, message: 'Orden eliminada exitosamente' });
    } catch (err) {
      console.error('Error al eliminar orden:', err);
      res.status(500).json({ success: false, error: 'No se pudo eliminar la orden' });
    }
  });
};
