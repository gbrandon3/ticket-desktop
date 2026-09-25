import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/usuario.dart';
import 'ordenes_providers.dart';

class AuthNotifier extends Notifier<Usuario?> {
  @override
  Usuario? build() {
    return null;
  }

  void login(Usuario usuario) {
    state = usuario;
  }

  void logout() {
    state = null;
  }

  void updateProfile(Usuario updated) {
    state = updated;
  }
}

final authProvider = NotifierProvider<AuthNotifier, Usuario?>(AuthNotifier.new);

// Estado de Setup Inicial
final setupCompletedProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(ordenesRepositoryProvider);
  return await repo.isSetupCompleted();
});
