import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session_storage.dart';

class ApiSession {
  static const _tokenKey = 'santi_auth_token';
  static const _userKey = 'santi_auth_user';
  static String? _token;
  static String? origin;
  static String? currentPassword;

  static String? get token {
    _token ??= SessionStorage.getItem(_tokenKey);
    return _token;
  }

  static set token(String? value) {
    _token = value;
    if (value != null && value.isNotEmpty) {
      SessionStorage.setItem(_tokenKey, value);
    } else {
      SessionStorage.removeItem(_tokenKey);
    }
  }

  static void clear() {
    final previousToken = token;
    final previousOrigin = origin;
    _token = null;
    currentPassword = null;
    SessionStorage.removeItem(_tokenKey);
    SessionStorage.removeItem(_userKey);
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
    final currentToken = ApiSession.token;
    if (currentToken != null && currentToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $currentToken';
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
