const db = require('./db');
const states = ['RECIBIDO', 'EN_DIAGNOSTICO', 'EN_TALLER', 'LISTO_ENTREGA', 'ENTREGADO_CERRADO'];

function validationMiddleware(req, res, next) {
  const fail = (status, error) => res.status(status).json({ success: false, error });
  const body = req.body;
  const write = ['POST', 'PUT', 'DELETE'].includes(req.method);
  if (write && req.method !== 'DELETE' && (!body || typeof body !== 'object' || Array.isArray(body))) return fail(400, 'Se requiere un objeto JSON');
  const required = (object, fields) => object && fields.every(key => typeof object[key] === 'string' && object[key].trim().length > 0);
  if (req.path === '/setup' && req.method === 'POST') {
    if (!body.empresa || !required(body.admin, ['email', 'password'])) return fail(400, 'Datos de configuración incompletos');
    const accounts = [body.admin, body.operador, body.tecnico].filter(Boolean);
    for (const account of accounts) {
      if (!required(account, ['email', 'password']) || account.password.length < 8 || account.password.length > 256) return fail(400, 'Cada cuenta requiere correo y contraseña de 8 a 256 caracteres');
    }
    if (new Set(accounts.map(account => account.email.trim().toLowerCase())).size !== accounts.length) return fail(400, 'Cada cuenta debe tener un correo distinto');
  }
  if (/^\/usuarios(?:\/\d+)?$/.test(req.path) && ['POST', 'PUT'].includes(req.method)) {
    if (!required(body, ['nombre', 'email']) || !['admin', 'solicitante', 'tecnico'].includes(body.rol)) return fail(400, 'Usuario o rol inválido');
    if (req.method === 'POST' && !body.password) return fail(400, 'Contraseña requerida');
    if (body.password && (body.password.length < 8 || body.password.length > 256)) return fail(400, 'La contraseña debe tener entre 8 y 256 caracteres');
  }
  if (req.path === '/ordenes' && req.method === 'POST') {
    if (!required(body.cliente, ['numeroDocumento', 'nombreCompleto', 'telefono', 'direccion']) ||
        !required(body.equipo, ['tipoEquipo', 'marca', 'modelo', 'numeroSerie']) || !required(body.orden, ['titulo', 'descripcion'])) return fail(400, 'Datos de ingreso incompletos');
    body.orden.estado = 'RECIBIDO';
    body.orden.solicitanteId = req.user.id;
    const slaHours = { BAJA: 72, MEDIA: 48, ALTA: 24, CRITICA: 8 };
    if (!Object.hasOwn(slaHours, body.orden.prioridad)) return fail(400, 'Prioridad inválida');
    const now = new Date();
    body.orden.fechaIngreso = now.toISOString();
    body.orden.fechaLimiteSla = new Date(now.getTime() + slaHours[body.orden.prioridad] * 3600000).toISOString();
  }
  const match = req.path.match(/^\/ordenes\/(\d+)(?:\/(.*))?$/);
  let order;
  if (match) order = db.prepare('SELECT * FROM ordenes WHERE id = ?').get(Number(match[1]));
  const child = req.path.match(/^\/(repuestos|fotos)\/(\d+)$/);
  if (child && write) {
    const table = child[1] === 'repuestos' ? 'repuestos_orden' : 'fotos_evidencia';
    order = db.prepare(`SELECT o.* FROM ordenes o JOIN ${table} c ON c.orden_id = o.id WHERE c.id = ?`).get(Number(child[2]));
  }
  if ((match || child) && !order) return fail(404, 'Orden o registro no encontrado');
  if (order && req.user?.rol === 'tecnico' && order.tecnico_id !== req.user.id) return fail(403, 'Orden asignada a otro técnico');
  if (order && write) {
    if (order.estado === 'ENTREGADO_CERRADO') return fail(409, 'La orden entregada es de solo lectura');
    if (match?.[2] === 'estado') {
      const current = states.indexOf(order.estado);
      if (body.nuevoEstado !== order.estado && states.indexOf(body.nuevoEstado) !== current + 1) return fail(409, 'Transición de estado no permitida');
      if (body.nuevoEstado === 'ENTREGADO_CERRADO') return fail(409, 'Cierre la orden mediante el acta de entrega');
    }
    if (match?.[2] === 'acta') {
      if (order.estado !== 'LISTO_ENTREGA' || !required(body, ['personaRecibeNombre', 'personaRecibeDocumento']) || body.checkConformidad !== true) return fail(409, 'Se requiere orden lista, receptor y conformidad para entregar');
      const ot = db.prepare('SELECT diagnostico_preliminar FROM formato_ot WHERE orden_id = ?').get(order.id);
      const activities = db.prepare('SELECT procedimientos_realizados FROM formato_actividades WHERE orden_id = ?').get(order.id);
      if (!ot?.diagnostico_preliminar?.trim() || !activities?.procedimientos_realizados?.trim()) return fail(409, 'Guarde el diagnóstico de la OT y la bitácora antes de entregar');
    }
    if (match?.[2] === 'ot' && !required(body, ['diagnosticoPreliminar'])) return fail(400, 'Escriba el diagnóstico antes de guardar la OT');
    if (match?.[2] === 'actividades' && (!required(body, ['procedimientosRealizados']) || !Number.isFinite(body.costoManoObra ?? 0) || (body.costoManoObra ?? 0) < 0)) return fail(400, 'La bitácora requiere procedimientos y un costo de mano de obra válido, mayor o igual a cero');
    if (match?.[2] === 'repuestos' && (!required(body, ['referencia']) || !Number.isInteger(body.cantidad) || body.cantidad < 1 || !Number.isFinite(body.precioUnitario) || body.precioUnitario < 0)) return fail(400, 'Repuesto, cantidad o precio inválido');
  }
  next();
}

function atomicRoute(handler) {
  return (req, res, next) => {
    db.exec('BEGIN IMMEDIATE');
    const json = res.json.bind(res);
    let finished = false;
    res.json = payload => {
      if (res.statusCode < 400) require('./change-audit').recordChange(req);
      db.exec(res.statusCode >= 400 ? 'ROLLBACK' : 'COMMIT');
      finished = true;
      return json(payload);
    };
    try { handler(req, res, next); }
    catch (err) {
      if (!finished) db.exec('ROLLBACK');
      res.json = json;
      next(err);
    }
  };
}

module.exports = { validationMiddleware, atomicRoute };
