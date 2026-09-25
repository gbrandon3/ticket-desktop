import '../entities/cliente.dart';
import '../entities/equipo.dart';
import '../entities/orden.dart';
import '../repositories/i_ordenes_repository.dart';

class CreateOrdenUseCase {
  final IOrdenesRepository repository;

  CreateOrdenUseCase(this.repository);

  Future<String> call({
    required Cliente cliente,
    required Equipo equipo,
    required Orden orden,
    String? fotoIngresoBase64,
  }) async {
    return await repository.registrarOrdenCompleta(
      cliente: cliente,
      equipo: equipo,
      orden: orden,
      fotoIngresoBase64: fotoIngresoBase64,
    );
  }
}
