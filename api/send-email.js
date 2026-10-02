function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[char]);
}
const nodemailer = require('nodemailer');

function createEmailHandler(createTransport = nodemailer.createTransport) {
  return async (req, res) => {
  if (!req.user) {
    return res.status(401).json({ success: false, error: 'Inicie sesión para enviar correo' });
  }
  // This handler is mounted behind authentication in server/app.js.
  if (req.method !== 'POST') {
    return res.status(405).json({ success: false, error: 'Método no permitido. Utilice POST.' });
  }

  try {
    let body = req.body;
    if (typeof body === 'string') {
      try {
        body = JSON.parse(body);
      } catch (e) {
        // keep as is
      }
    }
    const { host, port, user, pass, to, subject, message, trackingUrl } = body || {};

    if (!to || !subject || !message) {
      return res.status(400).json({
        success: false,
        error: 'Faltan parámetros requeridos: destinatario (to), asunto (subject) o mensaje (message).'
      });
    }

    if (trackingUrl && !/^https?:\/\//i.test(trackingUrl)) return res.status(400).json({ success: false, error: 'Enlace de seguimiento inválido' });

    const smtpHost = (host && host.trim()) || 'smtp.gmail.com';
    const smtpPort = Number(port) || 465;
    const smtpUser = (user && user.trim()) || process.env.SMTP_USER;
    const smtpPass = (pass && pass.trim()) || process.env.SMTP_PASS;

    if (!smtpUser || !smtpPass) {
      return res.status(400).json({
        success: false,
        error: 'Credenciales incompletas: Por favor ingrese el correo saliente y la contraseña de aplicación de Gmail.'
      });
    }

    // Configurar transporte con Nodemailer usando SSL/TLS
    const transporter = createTransport({
      host: smtpHost,
      port: smtpPort,
      secure: smtpPort === 465,
      auth: {
        user: smtpUser,
        pass: smtpPass.replace(/\s+/g, '') // Eliminar espacios si vienen de Google
      },
      tls: {
        rejectUnauthorized: true
      }
    });

    // Validar conexión y credenciales con el servidor SMTP
    await transporter.verify();

    // Enviar el correo electrónico
    const info = await transporter.sendMail({
      from: `"Santi Inc — Soporte Técnico" <${smtpUser}>`,
      to: to,
      subject: subject,
      text: message,
      html: `
        <div style="font-family: Arial, sans-serif; padding: 24px; border: 1px solid #e2e8f0; border-radius: 12px; max-width: 600px; margin: auto; background-color: #ffffff;">
          <div style="border-bottom: 2px solid #2563eb; padding-bottom: 12px; margin-bottom: 16px;">
            <h2 style="color: #2563eb; margin: 0; font-size: 20px;">Santi Inc — Notificación de Servicio</h2>
            <small style="color: #64748b;">Laboratorio de Mantenimiento y Soporte Técnico</small>
          </div>
          <div style="font-size: 15px; color: #1e293b; line-height: 1.6; margin-bottom: 24px;">
            ${escapeHtml(message).replace(/\n/g, '<br/>')}
          </div>
          ${trackingUrl ? `
            <div style="text-align: center; margin: 28px 0; padding: 18px; background-color: #f8fafc; border-radius: 8px; border: 1px dashed #cbd5e1;">
              <p style="margin: 0 0 12px 0; font-size: 13px; color: #475569; font-weight: 500;">
                Haga clic para ver el estado, procedimientos y evidencias en vivo:
              </p>
              <a href="${escapeHtml(trackingUrl)}" target="_blank" style="background-color: #2563eb; color: #ffffff; padding: 13px 26px; text-decoration: none; font-weight: bold; border-radius: 8px; display: inline-block; font-size: 14px; box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2);">
                🔍 Consultar Estado de mi Incidencia en Vivo
              </a>
              <div style="margin-top: 10px; font-size: 11px; color: #94a3b8;">
                Enlace directo: <a href="${escapeHtml(trackingUrl)}" style="color: #2563eb; word-break: break-all;">${escapeHtml(trackingUrl)}</a>
              </div>
            </div>
          ` : ''}
          <div style="border-top: 1px solid #e2e8f0; padding-top: 12px; font-size: 12px; color: #94a3b8; text-align: center;">
            Este es un mensaje automático de confirmación generado por el sistema de tickets de Santi Inc.
          </div>
        </div>
      `
    });

    return res.status(200).json({
      success: true,
      message: `Correo enviado exitosamente a ${to}`,
      messageId: info.messageId
    });

  } catch (error) {
    console.error('Error enviando correo SMTP:', error);
    let errorMsg = error.message || 'Error desconocido al autenticar con el servidor SMTP';
    
    if (error.code === 'EAUTH' || error.responseCode === 535) {
      errorMsg = 'Error de autenticación SMTP (535): La contraseña de aplicación o el correo de Gmail son incorrectos.';
    } else if (error.code === 'ETIMEDOUT' || error.code === 'ECONNECTION') {
      errorMsg = 'Tiempo de espera agotado al conectar con el servidor SMTP. Verifique el host y puerto.';
    }

    return res.status(400).json({
      success: false,
      error: errorMsg
    });
  }
};
}

module.exports = createEmailHandler();
module.exports.createEmailHandler = createEmailHandler;
