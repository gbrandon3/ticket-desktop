import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case 'RECIBIDO':
        bg = const Color(0xFFE0F2FE);
        text = const Color(0xFF0369A1);
        label = 'Recibido';
        break;
      case 'EN_DIAGNOSTICO':
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFFB45309);
        label = 'En Diagnóstico';
        break;
      case 'EN_TALLER':
        bg = const Color(0xFFFFEDD5);
        text = const Color(0xFFC2410C);
        label = 'En Taller';
        break;
      case 'LISTO_ENTREGA':
        bg = const Color(0xFFDCFCE7);
        text = const Color(0xFF15803D);
        label = 'Listo para Entrega';
        break;
      case 'ENTREGADO_CERRADO':
        bg = const Color(0xFFF1F5F9);
        text = const Color(0xFF475569);
        label = 'Entregado / Cerrado';
        break;
      default:
        bg = Colors.grey.shade200;
        text = Colors.grey.shade800;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class PriorityBadge extends StatelessWidget {
  final String priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (priority) {
      case 'CRITICA':
        bg = const Color(0xFFFEE2E2);
        text = const Color(0xFFB91C1C);
        break;
      case 'ALTA':
        bg = const Color(0xFFFFEDD5);
        text = const Color(0xFFC2410C);
        break;
      case 'MEDIA':
        bg = const Color(0xFFEFF6FF);
        text = const Color(0xFF1D4ED8);
        break;
      case 'BAJA':
      default:
        bg = const Color(0xFFF1F5F9);
        text = const Color(0xFF475569);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: text.withOpacity(0.3), width: 0.8),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
