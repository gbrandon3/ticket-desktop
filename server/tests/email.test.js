const { test } = require('node:test');
const assert = require('node:assert/strict');
const { createEmailHandler } = require('../../api/send-email');

function response() {
  return { statusCode: 200, status(code) { this.statusCode = code; return this; }, json(body) { this.body = body; return this; } };
}

test('Correo: preparación de SMTP, confirmación y contenido escapado sin envíos reales', async () => {
  let options, delivered, verified = false;
  const handler = createEmailHandler(config => {
    options = config;
    return {
      async verify() { verified = true; },
      async sendMail(message) { delivered = message; return { messageId: 'test-message' }; },
    };
  });
  const res = response();
  await handler({ method: 'POST', user: { id: 1 }, body: {
    host: 'smtp.example.com', port: 465, user: 'demo@example.com', pass: 'test-password',
    to: 'client@example.com', subject: 'Orden lista', message: 'Revisión completada <script>test</script>\nEquipo listo.',
    trackingUrl: 'http://localhost:3000/#/consulta?q=ORD-DEMO',
  } }, res);
  assert.equal(res.statusCode, 200);
  assert.ok(res.body.success);
  assert.ok(verified);
  assert.equal(options.secure, true);
  assert.equal(options.tls.rejectUnauthorized, true);
  assert.equal(delivered.to, 'client@example.com');
  assert.ok(delivered.html.includes('&lt;script&gt;'));
  assert.ok(delivered.html.includes('<br/>'));
});

test('Correo: rechaza solicitud sin sesión ni destinatario', async () => {
  const handler = createEmailHandler(() => { throw new Error('No debe conectar a SMTP'); });
  const anonymous = response();
  await handler({ method: 'POST', body: {} }, anonymous);
  assert.equal(anonymous.statusCode, 401);
  const incomplete = response();
  await handler({ method: 'POST', user: { id: 1 }, body: {} }, incomplete);
  assert.equal(incomplete.statusCode, 400);
});
