class NotificacionAuditoria {
  final int? id;
  final String destinatario;
  final String asunto;
  final String evento;
  final String estado; // 'ENVIADO' | 'FALLIDO'
  final DateTime fechaEnvio;

  const NotificacionAuditoria({
    this.id,
    required this.destinatario,
    required this.asunto,
    required this.evento,
    required this.estado,
    required this.fechaEnvio,
  });
}
