import 'package:flutter/material.dart';
import '../../../../core/services/server_maintenance_service.dart';
import '../../../../core/utils/file_exporter.dart';

class ServerBackupPanel extends StatefulWidget {
  const ServerBackupPanel({super.key});

  @override
  State<ServerBackupPanel> createState() => _ServerBackupPanelState();
}

class _ServerBackupPanelState extends State<ServerBackupPanel> {
  final _service = ServerMaintenanceService();
  late Future<Map<String, dynamic>> _status;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    _status = _service.backupStatus();
  }

  @override
  void dispose() {
    _service.close();
    super.dispose();
  }

  Future<void> _download() async {
    setState(() => _downloading = true);
    try {
      final bytes = await _service.downloadBackup();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final result = await FileExporter.exportBytes(fileName: 'santi_respaldo_$timestamp.sqlite', bytes: bytes);
      if (!mounted) return;
      setState(() => _status = _service.backupStatus());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result ?? 'Respaldo descargado')));
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo generar el respaldo: $error')));
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Respaldo completo del servidor (SQLite)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        const Text('Incluye usuarios, órdenes, formatos, evidencias e historial. El servidor conserva también la clave SMTP junto a su copia.'),
        const SizedBox(height: 8),
        FutureBuilder<Map<String, dynamic>>(future: _status, builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Estado automático no disponible.');
          if (!snapshot.hasData) return const Text('Consultando respaldos automáticos...');
          final status = snapshot.data!;
          return Text(status['enabled'] == true
              ? 'Respaldo automático al iniciar y cada ${status['intervalHours']} horas mientras el servidor esté encendido.'
              : 'Los respaldos automáticos están desactivados.');
        }),
        const SizedBox(height: 16),
        ElevatedButton.icon(onPressed: _downloading ? null : _download,
            icon: const Icon(Icons.save_alt), label: Text(_downloading ? 'Generando respaldo...' : 'Descargar respaldo SQLite')),
      ],
    )));
  }
}
