import '../entities/orden.dart';
import '../repositories/i_ordenes_repository.dart';

class WatchOrdenesUseCase {
  final IOrdenesRepository repository;

  WatchOrdenesUseCase(this.repository);

  Stream<List<Orden>> call({String? busqueda, String? estado, String? tipo}) {
    return repository.watchOrdenes(busqueda: busqueda, estado: estado, tipo: tipo);
  }
}
