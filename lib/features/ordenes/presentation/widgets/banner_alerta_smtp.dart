import 'package:flutter/material.dart';

class BannerAlertaSmtp extends StatefulWidget {
  final VoidCallback onConfigurarSmtp;

  const BannerAlertaSmtp({super.key, required this.onConfigurarSmtp});

  @override
  State<BannerAlertaSmtp> createState() => _BannerAlertaSmtpState();
}

class _BannerAlertaSmtpState extends State<BannerAlertaSmtp> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFDE68A)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mail_outline, color: Color(0xFFD97706), size: 20),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Servidor de Correo SMTP no configurado',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF92400E)),
                ),
                SizedBox(height: 2),
                Text(
                  'Las alertas automáticas por correo electrónico a los clientes están deshabilitadas hasta configurar las credenciales salientes.',
                  style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: widget.onConfigurarSmtp,
            icon: const Icon(Icons.settings, size: 16),
            label: const Text('Configurar Ahora', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              elevation: 0,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Color(0xFF92400E)),
            onPressed: () => setState(() => _visible = false),
            tooltip: 'Ocultar aviso',
          ),
        ],
      ),
    );
  }
}
