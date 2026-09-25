import '../entities/dashboard_metrics.dart';
import '../repositories/i_ordenes_repository.dart';

class GetDashboardMetricsUseCase {
  final IOrdenesRepository repository;

  GetDashboardMetricsUseCase(this.repository);

  Future<DashboardMetrics> call() async {
    return await repository.getDashboardMetrics();
  }
}
