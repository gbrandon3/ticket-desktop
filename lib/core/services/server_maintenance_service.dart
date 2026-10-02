import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../features/ordenes/data/repositories/api_ordenes_repository.dart';
import 'api_session.dart';

class ServerMaintenanceService {
  final http.Client _client;
  final String baseUrl;

  ServerMaintenanceService({http.Client? client, String? baseUrl})
      : _client = client ?? SessionClient(),
        baseUrl = baseUrl ?? ApiOrdenesRepository.resolveDefaultBaseUrl();

  Future<dynamic> _read(String path) async {
    final response = await _client.get(Uri.parse('$baseUrl/api/$path'));
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception(data['error'] ?? 'No se pudo consultar el servidor');
    }
    return data['data'];
  }

  Future<List<Map<String, dynamic>>> history() async {
    final rows = await _read('historial-cambios') as List;
    return rows.map((row) => Map<String, dynamic>.from(row as Map)).toList();
  }

  Future<Map<String, dynamic>> backupStatus() async {
    return Map<String, dynamic>.from(await _read('backups/status') as Map);
  }

  Future<Uint8List> downloadBackup() async {
    final response = await _client.post(Uri.parse('$baseUrl/api/backups'),
        headers: {'Content-Type': 'application/json'}, body: '{}');
    if (response.statusCode != 200) throw Exception('No se pudo crear el respaldo');
    return response.bodyBytes;
  }

  void close() => _client.close();
}
