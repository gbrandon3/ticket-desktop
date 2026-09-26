import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class EmailResult {
  final bool success;
  final String message;

  const EmailResult({required this.success, required this.message});
}

class EmailService {
  static Future<EmailResult> sendEmail({
    String? apiUrl,
    required String host,
    required int port,
    required String user,
    required String pass,
    required String to,
    required String subject,
    required String message,
  }) async {
    Uri endpoint;
    final trimmedUrl = apiUrl?.trim() ?? '';

    if (trimmedUrl.isNotEmpty) {
      endpoint = Uri.parse(trimmedUrl);
    } else if (kIsWeb) {
      if (Uri.base.host == 'localhost' || Uri.base.host == '127.0.0.1') {
        endpoint = Uri.parse('http://localhost:3000/api/send-email');
      } else {
        endpoint = Uri.base.resolve('/api/send-email');
      }
    } else {
      endpoint = Uri.parse('http://localhost:3000/api/send-email');
    }

    try {
      final response = await http.post(
        endpoint,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'host': host.trim(),
          'port': port,
          'user': user.trim(),
          'pass': pass.trim(),
          'to': to.trim(),
          'subject': subject.trim(),
          'message': message.trim(),
        }),
      ).timeout(const Duration(seconds: 15));

      Map<String, dynamic> data = {};
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {}

      if (response.statusCode >= 200 && response.statusCode < 300 && data['success'] == true) {
        return EmailResult(
          success: true,
          message: data['message'] as String? ?? 'Correo enviado exitosamente a $to',
        );
      } else {
        final errorMsg = data['error'] as String? ??
            'Error al enviar el correo (Código HTTP ${response.statusCode}). Verifique la URL de la función y las credenciales.';
        return EmailResult(success: false, message: errorMsg);
      }
    } catch (e) {
      String detail = e.toString();
      if (trimmedUrl.isEmpty && endpoint.toString().contains('localhost:3000')) {
        detail = 'Servidor local no detectado en http://localhost:3000. Inicie el servidor ejecutando "node server.js" o "npm start" en la terminal.';
      }
      return EmailResult(
        success: false,
        message: 'No se pudo conectar con el servidor de correo: $detail',
      );
    }
  }
}
