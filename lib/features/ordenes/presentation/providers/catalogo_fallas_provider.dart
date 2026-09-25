import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/tipo_falla.dart';
import 'ordenes_providers.dart';

class CatalogoFallasState {
  final List<String> tiposCorrectivo;
  final List<String> tiposPreventivo;

  const CatalogoFallasState({
    required this.tiposCorrectivo,
    required this.tiposPreventivo,
  });

  factory CatalogoFallasState.initial() => const CatalogoFallasState(
        tiposCorrectivo: [],
        tiposPreventivo: [],
      );

  CatalogoFallasState copyWith({
    List<String>? tiposCorrectivo,
    List<String>? tiposPreventivo,
  }) {
    return CatalogoFallasState(
      tiposCorrectivo: tiposCorrectivo ?? this.tiposCorrectivo,
      tiposPreventivo: tiposPreventivo ?? this.tiposPreventivo,
    );
  }
}

class CatalogoFallasNotifier extends Notifier<CatalogoFallasState> {
  static const _fileName = 'catalogo_fallas.json';

  @override
  CatalogoFallasState build() {
    _cleanupOldResidualJsonAndLoadDb();
    return CatalogoFallasState.initial();
  }

  Future<void> _cleanupOldResidualJsonAndLoadDb() async {
    try {
      // Eliminar cualquier archivo residual json viejo en disco si existiera
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_fileName');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}

    try {
      // Cargar exclusivamente de la base de datos SQLite (inicia en 0 si está vacía)
      final repo = ref.read(ordenesRepositoryProvider);
      final fallasDb = await repo.getTiposFalla();
      final correctivosDb = fallasDb
          .where((f) => f.tipoServicio == 'CORRECTIVO')
          .map((f) => f.nombre)
          .toList();
      final preventivosDb = fallasDb
          .where((f) => f.tipoServicio == 'PREVENTIVO')
          .map((f) => f.nombre)
          .toList();

      state = CatalogoFallasState(
        tiposCorrectivo: correctivosDb,
        tiposPreventivo: preventivosDb,
      );
    } catch (_) {}
  }

  Future<void> addTipoCorrectivo(String tipo) async {
    final trimmed = tipo.trim();
    if (trimmed.isEmpty || state.tiposCorrectivo.contains(trimmed)) return;

    state = state.copyWith(tiposCorrectivo: [...state.tiposCorrectivo, trimmed]);

    // Guardar en la Base de Datos SQLite
    try {
      await ref.read(ordenesRepositoryProvider).addTipoFalla(
            TipoFalla(tipoServicio: 'CORRECTIVO', nombre: trimmed),
          );
      ref.invalidate(countTiposFallaProvider);
    } catch (_) {}
  }

  Future<void> removeTipoCorrectivo(String tipo) async {
    state = state.copyWith(
      tiposCorrectivo: state.tiposCorrectivo.where((t) => t != tipo).toList(),
    );
    await _deleteFromDb(tipo, 'CORRECTIVO');
  }

  Future<void> addTipoPreventivo(String tipo) async {
    final trimmed = tipo.trim();
    if (trimmed.isEmpty || state.tiposPreventivo.contains(trimmed)) return;

    state = state.copyWith(tiposPreventivo: [...state.tiposPreventivo, trimmed]);

    // Guardar en la Base de Datos SQLite
    try {
      await ref.read(ordenesRepositoryProvider).addTipoFalla(
            TipoFalla(tipoServicio: 'PREVENTIVO', nombre: trimmed),
          );
      ref.invalidate(countTiposFallaProvider);
    } catch (_) {}
  }

  Future<void> removeTipoPreventivo(String tipo) async {
    state = state.copyWith(
      tiposPreventivo: state.tiposPreventivo.where((t) => t != tipo).toList(),
    );
    await _deleteFromDb(tipo, 'PREVENTIVO');
  }

  Future<void> _deleteFromDb(String nombre, String tipoServicio) async {
    try {
      final repo = ref.read(ordenesRepositoryProvider);
      final list = await repo.getTiposFalla(tipoServicio: tipoServicio);
      final match = list.where((f) => f.nombre == nombre).firstOrNull;
      if (match?.id != null) {
        await repo.deleteTipoFalla(match!.id!);
        ref.invalidate(countTiposFallaProvider);
      }
    } catch (_) {}
  }

  void restaurarValoresPorDefecto() {
    state = CatalogoFallasState.initial();
  }
}

final catalogoFallasProvider =
    NotifierProvider<CatalogoFallasNotifier, CatalogoFallasState>(
  CatalogoFallasNotifier.new,
);

final countTiposFallaProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(ordenesRepositoryProvider);
  return await repo.countTiposFalla();
});
