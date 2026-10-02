import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSession {
  static String? token;
  static String? origin;
  static String? currentPassword;

  static void clear() {
    final previousToken = token;
    final previousOrigin = origin;
    token = null;
    currentPassword = null;
    if (previousToken != null && previousOrigin != null) {
      http.post(Uri.parse('$previousOrigin/api/auth/logout'), headers: {
        'Authorization': 'Bearer $previousToken',
        'Content-Type': 'application/json',
      }, body: '{}').catchError((Object error) => http.Response('', 503));
    }
  }
}

class SessionClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    ApiSession.origin = request.url.origin;
    if (ApiSession.token != null) {
      request.headers['Authorization'] = 'Bearer ${ApiSession.token}';
    }
    final response = await _inner.send(request).timeout(const Duration(seconds: 20));
    if (response.statusCode >= 400 && request.method != 'GET' && request.url.path != '/api/auth/login') {
      final body = await response.stream.bytesToString();
      String message = 'No se pudo guardar (${response.statusCode})';
      try {
        message = (jsonDecode(body) as Map<String, dynamic>)['error'] as String? ?? message;
      } catch (_) {}
      throw Exception(message);
    }
    return response;
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
