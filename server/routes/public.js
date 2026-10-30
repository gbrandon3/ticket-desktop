const { eq, or, asc, sql } = require('drizzle-orm');
const { orm, schema } = require('../orm');
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
      const ordenRow = orm
        .select()
        .from(schema.ordenes)
        .where(
          or(
            sql`UPPER(${schema.ordenes.codigoOrden}) = ${cleanQ}`,
            sql`UPPER(${schema.ordenes.codigoOrden}) = ${`ORD-${cleanQ}`}`,
            sql`UPPER(${schema.ordenes.codigoOrden}) = ${`TCK-${cleanQ}`}`
          )
        )
        .get();

      function formatOt(row) {
        if (!row) return null;
        let chips = [];
        try {
          chips = JSON.parse(row.herramientasChips || '[]');
        } catch (_) {}
        return {
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
        };
      }

      function formatActividades(row) {
        if (!row) return null;
        return {
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
        };
      }

      function formatActa(row) {
        if (!row) return null;
        return {
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
        };
      }

      if (ordenRow) {
        const fotosRows = orm
          .select()
          .from(schema.fotosEvidencia)
          .where(eq(schema.fotosEvidencia.ordenId, ordenRow.id))
          .orderBy(asc(schema.fotosEvidencia.id))
          .all();
        const fotos = fotosRows.map(f => ({
          id: f.id,
          ordenId: f.ordenId,
          etapa: f.etapa,
          rutaOBytesBase64: f.rutaOBytesBase64,
          notaTecnica: f.notaTecnica,
          fechaCaptura: f.fechaCaptura,
        }));
        const otRow = orm
          .select()
          .from(schema.formatoOt)
          .where(eq(schema.formatoOt.ordenId, ordenRow.id))
          .get();
        const actRow = orm
          .select()
          .from(schema.formatoActividades)
          .where(eq(schema.formatoActividades.ordenId, ordenRow.id))
          .get();
        const actaRow = orm
          .select()
          .from(schema.formatoActaEntrega)
          .where(eq(schema.formatoActaEntrega.ordenId, ordenRow.id))
          .get();
        const repRows = orm
          .select()
          .from(schema.repuestosOrden)
          .where(eq(schema.repuestosOrden.ordenId, ordenRow.id))
          .all();

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
              ordenId: r.ordenId,
              referencia: r.referencia,
              cantidad: r.cantidad,
              precioUnitario: r.precioUnitario,
              subtotal: r.cantidad * r.precioUnitario,
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
