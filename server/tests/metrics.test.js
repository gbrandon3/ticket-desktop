const { test } = require('node:test');
const assert = require('node:assert/strict');
process.env.TICKETS_DB_PATH = ':memory:';
const db = require('../db');
const routes = new Map();
require('../routes/metrics')({ get: (path, handler) => routes.set(path, handler) });
function metrics(path) {
  let body;
  routes.get(path)({}, { json: value => body = value, status: () => { throw new Error('Falló la consulta'); } });
  return body.data;
}
test('Métricas: cierres a tiempo y tardíos, promedio real y fechas ISO con zona', () => {
  db.prepare("INSERT INTO clientes (tipo_documento, numero_documento, nombre_completo, telefono, direccion) VALUES ('CC','1','Cliente','1','Calle')").run();
  db.prepare("INSERT INTO equipos (cliente_id,tipo_equipo,marca,modelo,numero_serie) VALUES (1,'PC','Marca','Modelo','SERIAL')").run();
  const insert = db.prepare(`INSERT INTO ordenes (codigo_orden,cliente_id,equipo_id,tipo_servicio,categoria_falla,prioridad,titulo,descripcion,estado,fecha_ingreso,fecha_limite_sla,fecha_cierre)
    VALUES (?,1,1,'CORRECTIVO','HARDWARE','MEDIA','Prueba','Prueba',?,?,?,?)`);
  assert.equal(metrics('/api/metrics/dashboard').cumplimientoSlaPorcentaje, 100);
  insert.run('A','ENTREGADO_CERRADO','2026-01-01T10:00:00Z','2026-01-02T10:00:00Z','2026-01-02T10:00:00Z');
  insert.run('B','ENTREGADO_CERRADO','2026-01-01T10:00:00Z','2026-01-02T10:00:00Z','2026-01-03T10:00:00Z');
  insert.run('C','EN_TALLER','2026-01-01T10:00:00Z','2026-01-02T10:00:00Z',null);
  insert.run('D','LISTO_ENTREGA','2026-01-01T10:00:00Z','2026-01-02T10:00:00Z',null);
  insert.run('E','ENTREGADO_CERRADO','2026-01-01T10:00:00Z',null,'2026-01-02T10:00:00Z');
  const admin = metrics('/api/metrics/admin');
  assert.equal(admin.vencidos, 1);
  assert.equal(admin.cumplimientoSlaPorcentaje, 50);
  assert.ok(Math.abs(admin.tiempoPromedioHoras - 32) < 0.001);
  assert.equal(metrics('/api/metrics/dashboard').cumplimientoSlaPorcentaje, 50);
});
