const db = require('../db');

module.exports = app => {
  app.get('/api/metrics/dashboard', (req, res) => {
    try {
      const total = db.prepare('SELECT COUNT(*) as c FROM ordenes').get().c;
      const enTaller = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE estado IN ('RECIBIDO', 'EN_DIAGNOSTICO', 'EN_TALLER')").get().c;
      const listos = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE estado = 'LISTO_ENTREGA'").get().c;
      const cerrados = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE estado = 'ENTREGADO_CERRADO'").get().c;

      res.json({
        success: true,
        data: {
          totalTickets: total,
          ticketsEnTaller: enTaller,
          ticketsListos: listos,
          ticketsEntregados: cerrados,
          cumplimientoSlaPorcentaje: 100.0,
        },
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });

  app.get('/api/metrics/admin', (req, res) => {
    try {
      const total = db.prepare('SELECT COUNT(*) as c FROM ordenes').get().c;
      const sinAsignar = db.prepare('SELECT COUNT(*) as c FROM ordenes WHERE tecnico_id IS NULL AND estado != \'ENTREGADO_CERRADO\'').get().c;
      const preventivos = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE tipo_servicio = 'PREVENTIVO'").get().c;
      const correctivos = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE tipo_servicio = 'CORRECTIVO'").get().c;
      const vencidos = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE fecha_limite_sla IS NOT NULL AND fecha_limite_sla < datetime('now') AND estado != 'ENTREGADO_CERRADO'").get().c;

      const tecnicos = db.prepare("SELECT id, nombre FROM usuarios WHERE rol = 'tecnico'").all();
      const cargaTecnicos = tecnicos.map(t => {
        const activas = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE tecnico_id = ? AND estado != 'ENTREGADO_CERRADO'").get(t.id).c;
        const cerradas = db.prepare("SELECT COUNT(*) as c FROM ordenes WHERE tecnico_id = ? AND estado = 'ENTREGADO_CERRADO'").get(t.id).c;
        return {
          id: t.id,
          tecnicoId: t.id,
          nombre: t.nombre,
          activas: activas,
          ordenesActivas: activas,
          terminadas: cerradas,
          ordenesCerradas: cerradas,
        };
      });

      res.json({
        success: true,
        data: {
          total,
          vencidos,
          sinAsignar,
          preventivos,
          correctivos,
          tiempoPromedioHoras: 0.0,
          cargaTecnicos,
        },
      });
    } catch (err) {
      res.status(500).json({ success: false, error: 'No se pudo completar la operación' });
    }
  });
};
