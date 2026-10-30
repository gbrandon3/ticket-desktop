import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/usuario.dart';
import 'ordenes_providers.dart';
import '../../../../core/services/api_session.dart';
import '../../../../core/services/session_storage.dart';

class AuthNotifier extends Notifier<Usuario?> {
  static const _userKey = 'santi_auth_user';

  @override
  Usuario? build() {
    try {
      final token = ApiSession.token;
      final raw = SessionStorage.getItem(_userKey);
      if (token != null && token.isNotEmpty && raw != null && raw.isNotEmpty) {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        return Usuario(
          id: map['id'] as int?,
          nombre: (map['nombre'] as String?) ?? '',
          email: (map['email'] as String?) ?? '',
          password: '',
          documento: (map['documento'] as String?) ?? '',
          telefono: (map['telefono'] as String?) ?? '',
          rol: (map['rol'] as String?) ?? 'solicitante',
          activo: (map['activo'] as bool?) ?? true,
        );
      }
    } catch (_) {}
    return null;
  }

  void _saveUser(Usuario usuario) {
    try {
      SessionStorage.setItem(
        _userKey,
        jsonEncode({
          'id': usuario.id,
          'nombre': usuario.nombre,
          'email': usuario.email,
          'documento': usuario.documento,
          'telefono': usuario.telefono,
          'rol': usuario.rol,
          'activo': usuario.activo,
        }),
      );
    } catch (_) {}
  }

  void login(Usuario usuario) {
    _saveUser(usuario);
    state = usuario;
  }

  void logout() {
    ApiSession.clear();
    state = null;
  }

  void updateProfile(Usuario updated) {
    _saveUser(updated);
    state = updated;
  }
}

final authProvider = NotifierProvider<AuthNotifier, Usuario?>(AuthNotifier.new);

// Estado de Setup Inicial
final setupCompletedProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(ordenesRepositoryProvider);
  return await repo.isSetupCompleted();
});
