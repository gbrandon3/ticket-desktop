const path = require('path');
const fs = require('fs');
const db = require('../db');
const { toBool } = require('../serializers');

const uploadsDir = path.join(__dirname, '..', '..', 'data', 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

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

const toInt = val => val ? 1 : 0;

module.exports = app => {
  // Formato OT
  app.get('/api/ordenes/:id/ot', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const row = db.prepare('SELECT * FROM formato_ot WHERE orden_id = ?').get(ordenId);
      if (!row) return res.json({ success: true, data: null });

      let chips = [];
      try {
        chips = JSON.parse(row.herramientas_chips || '[]');
      } catch (_) {}

      res.json({
        success: true,
        data: {
          id: row.id,
          ordenId: row.orden_id,
          diagnosticoPreliminar: row.diagnostico_preliminar,
          herramientasChips: chips,
          tiempoEstimadoEntrega: row.tiempo_estimado_entrega,
          accesorioCargador: toBool(row.accesorio_cargador),
          accesorioCablePoder: toBool(row.accesorio_cable_poder),
          accesorioMouse: toBool(row.accesorio_mouse),
          accesorioMaletin: toBool(row.accesorio_maletin),
          encendidoInicial: toBool(row.encendido_inicial),
          estadoCarcasa: row.estado_carcasa,
          pinContrasena: row.pin_contrasena,
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
      const existing = db.prepare('SELECT id FROM formato_ot WHERE orden_id = ?').get(ordenId);

      const chipsJson = JSON.stringify(ot.herramientasChips || []);

      if (existing) {
        db.prepare(`
          UPDATE formato_ot SET
            diagnostico_preliminar = ?, herramientas_chips = ?, tiempo_estimado_entrega = ?,
            accesorio_cargador = ?, accesorio_cable_poder = ?, accesorio_mouse = ?,
            accesorio_maletin = ?, encendido_inicial = ?, estado_carcasa = ?, pin_contrasena = ?
          WHERE id = ?
        `).run(
          ot.diagnosticoPreliminar, chipsJson, ot.tiempoEstimadoEntrega || null,
          toInt(ot.accesorioCargador), toInt(ot.accesorioCablePoder), toInt(ot.accesorioMouse),
          toInt(ot.accesorioMaletin), toInt(ot.encendidoInicial), ot.estadoCarcasa, ot.pinContrasena,
          existing.id
        );
      } else {
        db.prepare(`
          INSERT INTO formato_ot (
            orden_id, diagnostico_preliminar, herramientas_chips, tiempo_estimado_entrega,
            accesorio_cargador, accesorio_cable_poder, accesorio_mouse, accesorio_maletin,
            encendido_inicial, estado_carcasa, pin_contrasena
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).run(
          ordenId, ot.diagnosticoPreliminar, chipsJson, ot.tiempoEstimadoEntrega || null,
          toInt(ot.accesorioCargador), toInt(ot.accesorioCablePoder), toInt(ot.accesorioMouse),
          toInt(ot.accesorioMaletin), toInt(ot.encendidoInicial), ot.estadoCarcasa, ot.pinContrasena
        );
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
      const row = db.prepare('SELECT * FROM formato_actividades WHERE orden_id = ?').get(ordenId);
      if (!row) return res.json({ success: true, data: null });

      res.json({
        success: true,
        data: {
          id: row.id,
          ordenId: row.orden_id,
          procedimientosRealizados: row.procedimientos_realizados,
          pastaTermica: toBool(row.pasta_termica),
          alcoholIsopropilico: toBool(row.alcohol_isopropilico),
          sopleteadoContactos: toBool(row.sopleteado_contactos),
          brochaAntiestatica: toBool(row.brocha_antiestatica),
          panoMicrofibra: toBool(row.pano_microfibra),
          depuracionTemporales: toBool(row.depuracion_temporales),
          optimizacionInicio: toBool(row.optimizacion_inicio),
          escaneoMalware: toBool(row.escaneo_malware),
          actualizacionDrivers: toBool(row.actualizacion_drivers),
          comprobacionDisco: toBool(row.comprobacion_disco),
          qaEstresTermico: toBool(row.qa_estres_termico),
          qaPuertos: toBool(row.qa_puertos),
          qaConectividad: toBool(row.qa_conectividad),
          qaBateria: toBool(row.qa_bateria),
          qaTecladoTouchpad: toBool(row.qa_teclado_touchpad),
          costoManoObra: row.costo_mano_obra || 0,
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
      const existing = db.prepare('SELECT id FROM formato_actividades WHERE orden_id = ?').get(ordenId);

      if (existing) {
        db.prepare(`
          UPDATE formato_actividades SET
            procedimientos_realizados = ?, pasta_termica = ?, alcohol_isopropilico = ?,
            sopleteado_contactos = ?, brocha_antiestatica = ?, pano_microfibra = ?,
            depuracion_temporales = ?, optimizacion_inicio = ?, escaneo_malware = ?,
            actualizacion_drivers = ?, comprobacion_disco = ?, qa_estres_termico = ?,
            qa_puertos = ?, qa_conectividad = ?, qa_bateria = ?, qa_teclado_touchpad = ?,
            costo_mano_obra = ?
          WHERE id = ?
        `).run(
          act.procedimientosRealizados, toInt(act.pastaTermica), toInt(act.alcoholIsopropilico),
          toInt(act.sopleteadoContactos), toInt(act.brochaAntiestatica), toInt(act.panoMicrofibra),
          toInt(act.depuracionTemporales), toInt(act.optimizacionInicio), toInt(act.escaneoMalware),
          toInt(act.actualizacionDrivers), toInt(act.comprobacionDisco), toInt(act.qaEstresTermico),
          toInt(act.qaPuertos), toInt(act.qaConectividad), toInt(act.qaBateria), toInt(act.qaTecladoTouchpad),
          act.costoManoObra || 0, existing.id
        );
      } else {
        db.prepare(`
          INSERT INTO formato_actividades (
            orden_id, procedimientos_realizados, pasta_termica, alcohol_isopropilico,
            sopleteado_contactos, brocha_antiestatica, pano_microfibra, depuracion_temporales,
            optimizacion_inicio, escaneo_malware, actualizacion_drivers, comprobacion_disco,
            qa_estres_termico, qa_puertos, qa_conectividad, qa_bateria, qa_teclado_touchpad,
            costo_mano_obra
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).run(
          ordenId, act.procedimientosRealizados, toInt(act.pastaTermica), toInt(act.alcoholIsopropilico),
          toInt(act.sopleteadoContactos), toInt(act.brochaAntiestatica), toInt(act.panoMicrofibra),
          toInt(act.depuracionTemporales), toInt(act.optimizacionInicio), toInt(act.escaneoMalware),
          toInt(act.actualizacionDrivers), toInt(act.comprobacionDisco), toInt(act.qaEstresTermico),
          toInt(act.qaPuertos), toInt(act.qaConectividad), toInt(act.qaBateria), toInt(act.qaTecladoTouchpad),
          act.costoManoObra || 0
        );
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
      const rows = db.prepare('SELECT * FROM repuestos_orden WHERE orden_id = ? ORDER BY id ASC').all(ordenId);
      res.json({
        success: true,
        data: rows.map(r => ({
          id: r.id,
          ordenId: r.orden_id,
          referencia: r.referencia,
          cantidad: r.cantidad,
          precioUnitario: r.precio_unitario,
          subtotal: r.cantidad * r.precio_unitario,
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
      const info = db.prepare(`
        INSERT INTO repuestos_orden (orden_id, referencia, cantidad, precio_unitario)
        VALUES (?, ?, ?, ?)
      `).run(ordenId, r.referencia, r.cantidad || 1, r.precioUnitario || 0);
      res.json({ success: true, id: info.lastInsertRowid });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.delete('/api/repuestos/:id', (req, res) => {
    try {
      const id = parseInt(req.params.id, 10);
      db.prepare('DELETE FROM repuestos_orden WHERE id = ?').run(id);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  // Fotos
  app.get('/api/ordenes/:id/fotos', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const rows = db.prepare('SELECT * FROM fotos_evidencia WHERE orden_id = ? ORDER BY id ASC').all(ordenId);
      res.json({
        success: true,
        data: rows.map(f => ({
          id: f.id,
          ordenId: f.orden_id,
          etapa: f.etapa,
          rutaOBytesBase64: f.ruta_o_bytes_base64,
          notaTecnica: f.nota_tecnica,
          fechaCaptura: f.fecha_captura,
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
      const info = db.prepare(`
        INSERT INTO fotos_evidencia (orden_id, etapa, ruta_o_bytes_base64, nota_tecnica, fecha_captura)
        VALUES (?, ?, ?, ?, ?)
      `).run(ordenId, f.etapa, storedPath, f.notaTecnica || null, f.fechaCaptura || new Date().toISOString());
      res.json({ success: true, id: info.lastInsertRowid, ruta: storedPath });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.delete('/api/fotos/:id', (req, res) => {
    try {
      const id = parseInt(req.params.id, 10);
      const row = db.prepare('SELECT ruta_o_bytes_base64 FROM fotos_evidencia WHERE id = ?').get(id);
      if (row && row.ruta_o_bytes_base64 && typeof row.ruta_o_bytes_base64 === 'string' && row.ruta_o_bytes_base64.startsWith('/uploads/')) {
        const filePath = path.join(uploadsDir, path.basename(row.ruta_o_bytes_base64));
        if (fs.existsSync(filePath)) {
          try { fs.unlinkSync(filePath); } catch (_) {}
        }
      }
      db.prepare('DELETE FROM fotos_evidencia WHERE id = ?').run(id);
      res.json({ success: true });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  // Acta de Entrega
  app.get('/api/ordenes/:id/acta', (req, res) => {
    try {
      const ordenId = parseInt(req.params.id, 10);
      const row = db.prepare('SELECT * FROM formato_acta_entrega WHERE orden_id = ?').get(ordenId);
      if (!row) return res.json({ success: true, data: null });
      res.json({
        success: true,
        data: {
          id: row.id,
          ordenId: row.orden_id,
          estadoOperatividad: row.estado_operatividad,
          observaciones: row.observaciones,
          recomendacionesCuidado: row.recomendaciones_cuidado,
          garantiaDias: row.garantia_dias,
          personaRecibeNombre: row.persona_recibe_nombre,
          personaRecibeDocumento: row.persona_recibe_documento,
          checkConformidad: toBool(row.check_conformidad),
          firmaDigitalBase64: row.firma_digital_base64,
          fechaEntrega: row.fecha_entrega,
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
      const existing = db.prepare('SELECT id FROM formato_acta_entrega WHERE orden_id = ?').get(ordenId);

      if (existing) {
        db.prepare(`
          UPDATE formato_acta_entrega SET
            estado_operatividad = ?, observaciones = ?, recomendaciones_cuidado = ?,
            garantia_dias = ?, persona_recibe_nombre = ?, persona_recibe_documento = ?,
            check_conformidad = ?, firma_digital_base64 = ?
          WHERE id = ?
        `).run(
          a.estadoOperatividad || 'OPERATIVO', a.observaciones || null, a.recomendacionesCuidado || null,
          a.garantiaDias || 30, a.personaRecibeNombre, a.personaRecibeDocumento,
          toInt(a.checkConformidad), a.firmaDigitalBase64 || null, existing.id
        );
      } else {
        db.prepare(`
          INSERT INTO formato_acta_entrega (
            orden_id, estado_operatividad, observaciones, recomendaciones_cuidado,
            garantia_dias, persona_recibe_nombre, persona_recibe_documento,
            check_conformidad, firma_digital_base64
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).run(
          ordenId, a.estadoOperatividad || 'OPERATIVO', a.observaciones || null, a.recomendacionesCuidado || null,
          a.garantiaDias || 30, a.personaRecibeNombre, a.personaRecibeDocumento,
          toInt(a.checkConformidad), a.firmaDigitalBase64 || null
        );
      }

      // Cerrar automáticamente la orden
      db.prepare("UPDATE ordenes SET estado = 'ENTREGADO_CERRADO', fecha_cierre = datetime('now') WHERE id = ?").run(ordenId);
      db.prepare('UPDATE equipos SET estado_equipo = ? WHERE id = (SELECT equipo_id FROM ordenes WHERE id = ?)').run(a.estadoOperatividad === 'SIN_SOLUCION' ? 'DE_BAJA' : 'OPERATIVO', ordenId);

      res.json({ success: true, message: 'Acta guardada y orden cerrada con éxito' });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
