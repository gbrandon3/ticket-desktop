import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../data/repositories/ordenes_repository_impl.dart';
import '../../domain/entities/dashboard_metrics.dart';
import '../../domain/entities/empresa_config.dart';
import '../../domain/entities/orden.dart';
import '../../domain/repositories/i_ordenes_repository.dart';
import '../../domain/usecases/create_orden_usecase.dart';
import '../../domain/usecases/get_dashboard_metrics_usecase.dart';
import '../../domain/usecases/manage_taller_usecase.dart';
import '../../domain/usecases/watch_ordenes_usecase.dart';

// Database Singleton
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Repository
final ordenesRepositoryProvider = Provider<IOrdenesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OrdenesRepositoryImpl(db);
});

// Use Cases
final getDashboardMetricsUseCaseProvider = Provider<GetDashboardMetricsUseCase>((ref) {
  return GetDashboardMetricsUseCase(ref.watch(ordenesRepositoryProvider));
});

final watchOrdenesUseCaseProvider = Provider<WatchOrdenesUseCase>((ref) {
  return WatchOrdenesUseCase(ref.watch(ordenesRepositoryProvider));
});

final createOrdenUseCaseProvider = Provider<CreateOrdenUseCase>((ref) {
  return CreateOrdenUseCase(ref.watch(ordenesRepositoryProvider));
});

final manageTallerUseCaseProvider = Provider<ManageTallerUseCase>((ref) {
  return ManageTallerUseCase(ref.watch(ordenesRepositoryProvider));
});

// Notifiers para filtros de UI (Estándar Riverpod 3)
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String q) => state = q;
}
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class EstadoFilterNotifier extends Notifier<String> {
  @override
  String build() => 'TODOS';
  void setEstado(String e) => state = e;
}
final estadoFilterProvider = NotifierProvider<EstadoFilterNotifier, String>(EstadoFilterNotifier.new);

class TipoFilterNotifier extends Notifier<String> {
  @override
  String build() => 'TODOS';
  void setTipo(String t) => state = t;
}
final tipoFilterProvider = NotifierProvider<TipoFilterNotifier, String>(TipoFilterNotifier.new);

// Stream de Órdenes filtradas
final filteredOrdenesStreamProvider = StreamProvider<List<Orden>>((ref) {
  final useCase = ref.watch(watchOrdenesUseCaseProvider);
  final query = ref.watch(searchQueryProvider);
  final estado = ref.watch(estadoFilterProvider);
  final tipo = ref.watch(tipoFilterProvider);

  return useCase(
    busqueda: query,
    estado: estado == 'TODOS' ? null : estado,
    tipo: tipo == 'TODOS' ? null : tipo,
  );
});

// Métricas de Dashboard (reactivas a los cambios de las órdenes)
final dashboardMetricsProvider = FutureProvider<DashboardMetrics>((ref) async {
  // Re-evaluar cuando las órdenes cambien
  ref.watch(filteredOrdenesStreamProvider);
  final useCase = ref.watch(getDashboardMetricsUseCaseProvider);
  return await useCase();
});

// Configuración Dinámica de Empresa / Taller
final empresaConfigStreamProvider = StreamProvider<EmpresaConfig>((ref) {
  final repo = ref.watch(ordenesRepositoryProvider);
  return repo.watchEmpresaConfig();
});
