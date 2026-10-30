const path = require('path');
const fs = require('fs');
const { eq, asc } = require('drizzle-orm');
const { orm, schema } = require('../orm');
const { toBool } = require('../serializers');

const uploadsDir = process.env.VERCEL ? path.join('/tmp', 'uploads') : path.join(__dirname, '..', '..', 'data', 'uploads');
try {
  if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir, { recursive: true });
  }
} catch (_) {}

function saveUploadFile(ordenId, rutaOBytesBase64) {
  if (!rutaOBytesBase64 || typeof rutaOBytesBase64 !== 'string') return null;
  const trimmed = rutaOBytesBase64.trim();
  if (trimmed.startsWith('/uploads/') || trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }
  try {
    let ext = '.jpg';
    if (trimmed.startsWith('data:image/png')) ext = '.png';
    else if (trimmed.startsWith('data:image/webp')) ext = '.webp';
    else if (trimmed.startsWith('data:image/jpeg') || trimmed.startsWith('data:image/jpg')) ext = '.jpg';

    const cleanBase64 = trimmed.includes(',') ? trimmed.split(',')[1] : trimmed;
    const buffer = Buffer.from(cleanBase64, 'base64');
    const filename = `evidencia_${ordenId}_${Date.now()}_${Math.random().toString(36).slice(2, 8)}${ext}`;
    const targetPath = path.join(uploadsDir, filename);
    fs.writeFileSync(targetPath, buffer);
    return `/uploads/${filename}`;
  } catch (err) {
    console.error('Error guardando evidencia en disco:', err.message);
    return trimmed;
  }
}

module.exports = app => {
  // Formato OT
  app.get('/api/ordenes/:id/ot', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const row = orm
        .select()
        .from(schema.formatoOt)
        .where(eq(schema.formatoOt.ordenId, ordenId))
        .get();
      if (!row) return res.json({ success: true, data: null });

      let chips = [];
      try {
        chips = JSON.parse(row.herramientasChips || '[]');
      } catch (_) {}

      res.json({
        success: true,
        data: {
          id: row.id,
          ordenId: row.ordenId,
          diagnosticoPreliminar: row.diagnosticoPreliminar,
          herramientasChips: chips,
          tiempoEstimadoEntrega: row.tiempoEstimadoEntrega,
          accesorioCargador: toBool(row.accesorioCargador),
          accesorioCablePoder: toBool(row.accesorioCablePoder),
          accesorioMouse: toBool(row.accesorioMouse),
          accesorioMaletin: toBool(row.accesorioMaletin),
          encendidoInicial: toBool(row.encendidoInicial),
          estadoCarcasa: row.estadoCarcasa,
          pinContrasena: row.pinContrasena,
        },
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/ordenes/:id/ot', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const ot = req.body;
      const existing = orm
        .select({ id: schema.formatoOt.id })
        .from(schema.formatoOt)
        .where(eq(schema.formatoOt.ordenId, ordenId))
        .get();

      const chipsJson = JSON.stringify(ot.herramientasChips || []);
      const values = {
        diagnosticoPreliminar: ot.diagnosticoPreliminar,
        herramientasChips: chipsJson,
        tiempoEstimadoEntrega: ot.tiempoEstimadoEntrega || null,
        accesorioCargador: Boolean(ot.accesorioCargador),
        accesorioCablePoder: Boolean(ot.accesorioCablePoder),
        accesorioMouse: Boolean(ot.accesorioMouse),
        accesorioMaletin: Boolean(ot.accesorioMaletin),
        encendidoInicial: Boolean(ot.encendidoInicial),
        estadoCarcasa: ot.estadoCarcasa,
        pinContrasena: ot.pinContrasena,
      };

      if (existing) {
        orm
          .update(schema.formatoOt)
          .set(values)
          .where(eq(schema.formatoOt.id, existing.id))
          .run();
      } else {
        orm
          .insert(schema.formatoOt)
          .values({ ordenId, ...values })
          .run();
      }
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  // Formato Actividades
  app.get('/api/ordenes/:id/actividades', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const row = orm
        .select()
        .from(schema.formatoActividades)
        .where(eq(schema.formatoActividades.ordenId, ordenId))
        .get();
      if (!row) return res.json({ success: true, data: null });

      res.json({
        success: true,
        data: {
          id: row.id,
          ordenId: row.ordenId,
          procedimientosRealizados: row.procedimientosRealizados,
          pastaTermica: toBool(row.pastaTermica),
          alcoholIsopropilico: toBool(row.alcoholIsopropilico),
          sopleteadoContactos: toBool(row.sopleteadoContactos),
          brochaAntiestatica: toBool(row.brochaAntiestatica),
          panoMicrofibra: toBool(row.panoMicrofibra),
          depuracionTemporales: toBool(row.depuracionTemporales),
          optimizacionInicio: toBool(row.optimizacionInicio),
          escaneoMalware: toBool(row.escaneoMalware),
          actualizacionDrivers: toBool(row.actualizacionDrivers),
          comprobacionDisco: toBool(row.comprobacionDisco),
          qaEstresTermico: toBool(row.qaEstresTermico),
          qaPuertos: toBool(row.qaPuertos),
          qaConectividad: toBool(row.qaConectividad),
          qaBateria: toBool(row.qaBateria),
          qaTecladoTouchpad: toBool(row.qaTecladoTouchpad),
          costoManoObra: row.costoManoObra || 0,
        },
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/ordenes/:id/actividades', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const act = req.body;
      const existing = orm
        .select({ id: schema.formatoActividades.id })
        .from(schema.formatoActividades)
        .where(eq(schema.formatoActividades.ordenId, ordenId))
        .get();

      const values = {
        procedimientosRealizados: act.procedimientosRealizados,
        pastaTermica: Boolean(act.pastaTermica),
        alcoholIsopropilico: Boolean(act.alcoholIsopropilico),
        sopleteadoContactos: Boolean(act.sopleteadoContactos),
        brochaAntiestatica: Boolean(act.brochaAntiestatica),
        panoMicrofibra: Boolean(act.panoMicrofibra),
        depuracionTemporales: Boolean(act.depuracionTemporales),
        optimizacionInicio: Boolean(act.optimizacionInicio),
        escaneoMalware: Boolean(act.escaneoMalware),
        actualizacionDrivers: Boolean(act.actualizacionDrivers),
        comprobacionDisco: Boolean(act.comprobacionDisco),
        qaEstresTermico: Boolean(act.qaEstresTermico),
        qaPuertos: Boolean(act.qaPuertos),
        qaConectividad: Boolean(act.qaConectividad),
        qaBateria: Boolean(act.qaBateria),
        qaTecladoTouchpad: Boolean(act.qaTecladoTouchpad),
        costoManoObra: act.costoManoObra || 0,
      };

      if (existing) {
        orm
          .update(schema.formatoActividades)
          .set(values)
          .where(eq(schema.formatoActividades.id, existing.id))
          .run();
      } else {
        orm
          .insert(schema.formatoActividades)
          .values({ ordenId, ...values })
          .run();
      }
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  // Repuestos
  app.get('/api/ordenes/:id/repuestos', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const rows = orm
        .select()
        .from(schema.repuestosOrden)
        .where(eq(schema.repuestosOrden.ordenId, ordenId))
        .orderBy(asc(schema.repuestosOrden.id))
        .all();
      res.json({
        success: true,
        data: rows.map(r => ({
          id: r.id,
          ordenId: r.ordenId,
          referencia: r.referencia,
          cantidad: r.cantidad,
          precioUnitario: r.precioUnitario,
          subtotal: r.cantidad * r.precioUnitario,
        })),
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/ordenes/:id/repuestos', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const r = req.body;
      const inserted = orm
        .insert(schema.repuestosOrden)
        .values({
          ordenId,
          referencia: r.referencia,
          cantidad: r.cantidad || 1,
          precioUnitario: r.precioUnitario || 0,
        })
        .returning({ id: schema.repuestosOrden.id })
        .get();
      res.json({ success: true, id: inserted.id });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.delete('/api/repuestos/:id', (req, res) => {
    try {
      const id = parseInt(req.params.id, 10);
      orm.delete(schema.repuestosOrden).where(eq(schema.repuestosOrden.id, id)).run();
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  // Fotos
  app.get('/api/ordenes/:id/fotos', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const rows = orm
        .select()
        .from(schema.fotosEvidencia)
        .where(eq(schema.fotosEvidencia.ordenId, ordenId))
        .orderBy(asc(schema.fotosEvidencia.id))
        .all();
      res.json({
        success: true,
        data: rows.map(f => ({
          id: f.id,
          ordenId: f.ordenId,
          etapa: f.etapa,
          rutaOBytesBase64: f.rutaOBytesBase64,
          notaTecnica: f.notaTecnica,
          fechaCaptura: f.fechaCaptura,
        })),
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/ordenes/:id/fotos', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const f = req.body;
      const storedPath = saveUploadFile(ordenId, f.rutaOBytesBase64);
      const inserted = orm
        .insert(schema.fotosEvidencia)
        .values({
          ordenId,
          etapa: f.etapa,
          rutaOBytesBase64: storedPath,
          notaTecnica: f.notaTecnica || null,
          fechaCaptura: f.fechaCaptura || new Date().toISOString(),
        })
        .returning({ id: schema.fotosEvidencia.id })
        .get();
      res.json({ success: true, id: inserted.id, ruta: storedPath });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.delete('/api/fotos/:id', (req, res) => {
    try {
      const id = parseInt(req.params.id, 10);
      const row = orm
        .select({ rutaOBytesBase64: schema.fotosEvidencia.rutaOBytesBase64 })
        .from(schema.fotosEvidencia)
        .where(eq(schema.fotosEvidencia.id, id))
        .get();
      if (row && row.rutaOBytesBase64 && typeof row.rutaOBytesBase64 === 'string' && row.rutaOBytesBase64.startsWith('/uploads/')) {
        const filePath = path.join(uploadsDir, path.basename(row.rutaOBytesBase64));
        if (fs.existsSync(filePath)) {
          try {
            fs.unlinkSync(filePath);
          } catch (_) {}
        }
      }
      orm.delete(schema.fotosEvidencia).where(eq(schema.fotosEvidencia.id, id)).run();
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  // Acta de Entrega
  app.get('/api/ordenes/:id/acta', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const row = orm
        .select()
        .from(schema.formatoActaEntrega)
        .where(eq(schema.formatoActaEntrega.ordenId, ordenId))
        .get();
      if (!row) return res.json({ success: true, data: null });
      res.json({
        success: true,
        data: {
          id: row.id,
          ordenId: row.ordenId,
          estadoOperatividad: row.estadoOperatividad,
          observaciones: row.observaciones,
          recomendacionesCuidado: row.recomendacionesCuidado,
          garantiaDias: row.garantiaDias,
          personaRecibeNombre: row.personaRecibeNombre,
          personaRecibeDocumento: row.personaRecibeDocumento,
          checkConformidad: toBool(row.checkConformidad),
          firmaDigitalBase64: row.firmaDigitalBase64,
          fechaEntrega: row.fechaEntrega,
        },
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.post('/api/ordenes/:id/acta', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const a = req.body;
      const existing = orm
        .select({ id: schema.formatoActaEntrega.id })
        .from(schema.formatoActaEntrega)
        .where(eq(schema.formatoActaEntrega.ordenId, ordenId))
        .get();

      const values = {
        estadoOperatividad: a.estadoOperatividad || 'OPERATIVO',
        observaciones: a.observaciones || null,
        recomendacionesCuidado: a.recomendacionesCuidado || null,
        garantiaDias: a.garantiaDias || 30,
        personaRecibeNombre: a.personaRecibeNombre,
        personaRecibeDocumento: a.personaRecibeDocumento,
        checkConformidad: Boolean(a.checkConformidad),
        firmaDigitalBase64: a.firmaDigitalBase64 || null,
      };

      if (existing) {
        orm
          .update(schema.formatoActaEntrega)
          .set(values)
          .where(eq(schema.formatoActaEntrega.id, existing.id))
          .run();
      } else {
        orm
          .insert(schema.formatoActaEntrega)
          .values({ ordenId, ...values })
          .run();
      }

      // Cerrar automáticamente la orden y actualizar estado del equipo
      const ordenRow = orm
        .select({ equipoId: schema.ordenes.equipoId })
        .from(schema.ordenes)
        .where(eq(schema.ordenes.id, ordenId))
        .get();

      orm
        .update(schema.ordenes)
        .set({ estado: 'ENTREGADO_CERRADO', fechaCierre: new Date().toISOString() })
        .where(eq(schema.ordenes.id, ordenId))
        .run();

      if (ordenRow?.equipoId) {
        orm
          .update(schema.equipos)
          .set({ estadoEquipo: a.estadoOperatividad === 'SIN_SOLUCION' ? 'DE_BAJA' : 'OPERATIVO' })
          .where(eq(schema.equipos.id, ordenRow.equipoId))
          .run();
      }

      res.json({ success: true, message: 'Acta guardada y orden cerrada con éxito' });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
