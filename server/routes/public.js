const db = require('../db');
const { formatOrden, toBool } = require('../serializers');

module.exports = app => {
  app.get('/api/consulta-publica', (req, res) => {
    try {
      const q = (req.query.q || '').trim();
      if (!q) {
        return res.json({ success: true, data: { tipo: 'no_encontrado' } });
      }

      const cleanQ = q.toUpperCase().replace('#', '').trim();

      // 1. Buscar por Código de Orden exacto o parcial
      const ordenRow = db.prepare(`
        SELECT * FROM ordenes
        WHERE UPPER(codigo_orden) = ?
           OR UPPER(codigo_orden) = ?
           OR UPPER(codigo_orden) = ?

      `).get(cleanQ, `ORD-${cleanQ}`, `TCK-${cleanQ}`);

  function formatOt(row) {
    if (!row) return null;
    let chips = [];
    try { chips = JSON.parse(row.herramientas_chips || '[]'); } catch (_) {}
    return {
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

    };
  }

  function formatActividades(row) {
    if (!row) return null;
    return {
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
    };
  }

  function formatActa(row) {
    if (!row) return null;
    return {
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
    };
  }

      if (ordenRow) {
        const fotosRows = db.prepare('SELECT * FROM fotos_evidencia WHERE orden_id = ? ORDER BY id ASC').all(ordenRow.id);
        const fotos = fotosRows.map(f => ({
          id: f.id,
          ordenId: f.orden_id,
          etapa: f.etapa,
          rutaOBytesBase64: f.ruta_o_bytes_base64,
          notaTecnica: f.nota_tecnica,
          fechaCaptura: f.fecha_captura,
        }));
        const otRow = db.prepare('SELECT * FROM formato_ot WHERE orden_id = ?').get(ordenRow.id);
        const actRow = db.prepare('SELECT * FROM formato_actividades WHERE orden_id = ?').get(ordenRow.id);
        const actaRow = db.prepare('SELECT * FROM formato_acta_entrega WHERE orden_id = ?').get(ordenRow.id);
        const repRows = db.prepare('SELECT * FROM repuestos_orden WHERE orden_id = ?').all(ordenRow.id);

        return res.json({
          success: true,
          data: {
            tipo: 'ticket',
            orden: { ...formatOrden(ordenRow), cliente: null, tecnico: null, solicitanteId: null },
            fotos,
            formatoOt: formatOt(otRow),
            formatoActividades: formatActividades(actRow),
            actaEntrega: formatActa(actaRow),
            repuestos: repRows.map(r => ({
              id: r.id,
              ordenId: r.orden_id,
              referencia: r.referencia,
              cantidad: r.cantidad,
              precioUnitario: r.precio_unitario,
              subtotal: r.cantidad * r.precio_unitario,
            })),
          },
        });
      }

      res.json({ success: true, data: { tipo: 'no_encontrado' } });
    } catch (err) {
      res.status(500).json({ success: false, error: 'Error consultando la orden' });
    }
  });

};
