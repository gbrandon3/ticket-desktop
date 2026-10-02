import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/server_maintenance_service.dart';

class ChangeHistoryPanel extends StatefulWidget {
  const ChangeHistoryPanel({super.key});

  @override
  State<ChangeHistoryPanel> createState() => _ChangeHistoryPanelState();
}

class _ChangeHistoryPanelState extends State<ChangeHistoryPanel> {
  final _service = ServerMaintenanceService();
  late Future<List<Map<String, dynamic>>> _history;

  @override
  void initState() {
    super.initState();
    _history = _service.history();
  }

  @override
  void dispose() {
    _service.close();
    super.dispose();
  }

  String _description(Map<String, dynamic> row) {
    final route = row['ruta'] as String? ?? '';
    final order = RegExp(r'/ordenes/(\d+)').firstMatch(route)?.group(1);
    final target = order == null ? '' : ' en la orden #$order';
    if (route.endsWith('/estado')) return 'Actualizó el estado$target';
    if (route.endsWith('/tecnico')) return 'Asignó un técnico$target';
    if (route.endsWith('/acta')) return 'Registró la entrega$target';
    if (route.endsWith('/ot')) return 'Guardó el diagnóstico$target';
    if (route.endsWith('/actividades')) return 'Guardó la bitácora$target';
    if (route.contains('/repuestos')) return 'Modificó repuestos$target';
    if (route.contains('/fotos')) return 'Modificó evidencias$target';
    if (route.endsWith('/ordenes')) return 'Registró una orden';
    if (route.contains('/usuarios')) return 'Modificó una cuenta de usuario';
    if (route.endsWith('/config')) return 'Actualizó la configuración';
    if (route.contains('/tipos-falla')) return 'Modificó el catálogo de fallas';
    if (route.contains('/clientes')) return 'Actualizó datos de cliente';
    if (route.contains('/backups')) return 'Generó un respaldo';
    return 'Actualizó un registro';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: Text('Historial de Cambios', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          IconButton(tooltip: 'Actualizar historial', icon: const Icon(Icons.refresh),
              onPressed: () => setState(() => _history = _service.history())),
        ]),
        const Text('Últimos 100 cambios guardados, con usuario y fecha.'),
        const SizedBox(height: 16),
        Expanded(child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _history,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return const Center(child: Text('No se pudo consultar el historial. Inicie sesión y vuelva a intentarlo.'));
            final rows = snapshot.data ?? [];
            if (rows.isEmpty) return const Center(child: Text('Todavía no hay cambios registrados.'));
            return ListView.separated(
              itemCount: rows.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                final row = rows[index];
                final utc = DateTime.tryParse('${row['fecha']}Z');
                final date = utc == null ? '' : DateFormat('dd/MM/yyyy HH:mm').format(utc.toLocal());
                return ListTile(leading: const Icon(Icons.history), title: Text(_description(row)),
                    subtitle: Text('${row['usuarioNombre']} · $date'));
              },
            );
          },
        )),
      ]),
    );
  }
}
