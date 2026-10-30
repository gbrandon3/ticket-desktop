const { eq } = require('drizzle-orm');
const { orm, schema } = require('../orm');

function parseDateMs(value) {
  if (!value) return null;
  const normalized = value.includes('T') ? value : value.replace(' ', 'T') + 'Z';
  const ms = Date.parse(normalized);
  return Number.isNaN(ms) ? null : ms;
}

function cumplimientoSla(ordenesRows) {
  const closedWithSla = ordenesRows.filter(
    o =>
      o.estado === 'ENTREGADO_CERRADO' &&
      parseDateMs(o.fechaCierre) !== null &&
      parseDateMs(o.fechaLimiteSla) !== null
  );
  if (closedWithSla.length === 0) return 100.0;
  const onTime = closedWithSla.filter(
    o => parseDateMs(o.fechaCierre) <= parseDateMs(o.fechaLimiteSla)
  ).length;
  return (100.0 * onTime) / closedWithSla.length;
}

module.exports = app => {
  app.get('/api/metrics/dashboard', (req, res) => {
    try {
      const allOrders = orm.select().from(schema.ordenes).all();
      const total = allOrders.length;
      const enTaller = allOrders.filter(o =>
        ['RECIBIDO', 'EN_DIAGNOSTICO', 'EN_TALLER'].includes(o.estado)
      ).length;
      const listos = allOrders.filter(o => o.estado === 'LISTO_ENTREGA').length;
      const cerrados = allOrders.filter(o => o.estado === 'ENTREGADO_CERRADO').length;

      res.json({
        success: true,
        data: {
          totalTickets: total,
          ticketsEnTaller: enTaller,
          ticketsListos: listos,
          ticketsEntregados: cerrados,
          cumplimientoSlaPorcentaje: cumplimientoSla(allOrders),
        },
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/metrics/admin', (req, res) => {
    try {
      const allOrders = orm.select().from(schema.ordenes).all();
      const nowMs = Date.now();

      const total = allOrders.length;
      const sinAsignar = allOrders.filter(
        o => o.tecnicoId === null && o.estado !== 'ENTREGADO_CERRADO'
      ).length;
      const preventivos = allOrders.filter(o => o.tipoServicio === 'PREVENTIVO').length;
      const correctivos = allOrders.filter(o => o.tipoServicio === 'CORRECTIVO').length;
      const vencidos = allOrders.filter(o => {
        const slaMs = parseDateMs(o.fechaLimiteSla);
        return (
          slaMs !== null &&
          slaMs < nowMs &&
          !['ENTREGADO_CERRADO', 'LISTO_ENTREGA'].includes(o.estado)
        );
      }).length;

      const tecnicos = orm
        .select({ id: schema.usuarios.id, nombre: schema.usuarios.nombre })
        .from(schema.usuarios)
        .where(eq(schema.usuarios.rol, 'tecnico'))
        .all();

      const cargaTecnicos = tecnicos.map(t => {
        const activas = allOrders.filter(
          o => o.tecnicoId === t.id && o.estado !== 'ENTREGADO_CERRADO'
        ).length;
        const cerradas = allOrders.filter(
          o => o.tecnicoId === t.id && o.estado === 'ENTREGADO_CERRADO'
        ).length;
        return {
          id: t.id,
          tecnicoId: t.id,
          nombre: t.nombre,
          activas,
          ordenesActivas: activas,
          terminadas: cerradas,
          ordenesCerradas: cerradas,
        };
      });

      const validClosedDurations = allOrders
        .filter(o => {
          if (o.estado !== 'ENTREGADO_CERRADO') return false;
          const start = parseDateMs(o.fechaIngreso);
          const end = parseDateMs(o.fechaCierre);
          return start !== null && end !== null && end >= start;
        })
        .map(o => (parseDateMs(o.fechaCierre) - parseDateMs(o.fechaIngreso)) / 3600000);

      const tiempoPromedioHoras =
        validClosedDurations.length > 0
          ? validClosedDurations.reduce((a, b) => a + b, 0) / validClosedDurations.length
          : 0.0;

      res.json({
        success: true,
        data: {
          total,
          vencidos,
          sinAsignar,
          preventivos,
          correctivos,
          cumplimientoSlaPorcentaje: cumplimientoSla(allOrders),
          tiempoPromedioHoras,
          cargaTecnicos,
        },
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
