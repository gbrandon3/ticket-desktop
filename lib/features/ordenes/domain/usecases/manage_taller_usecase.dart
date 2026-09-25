import '../entities/formato_acta_entrega.dart';
import '../entities/formato_actividades.dart';
import '../entities/formato_ot.dart';
import '../entities/foto_evidencia.dart';
import '../entities/orden.dart';
import '../entities/repuesto.dart';
import '../repositories/i_ordenes_repository.dart';

class ManageTallerUseCase {
  final IOrdenesRepository repository;

  ManageTallerUseCase(this.repository);

  Future<Orden?> getOrden(int id) => repository.getOrdenById(id);
  Future<FormatoOt?> getFormatoOt(int ordenId) => repository.getFormatoOt(ordenId);
  Future<void> saveFormatoOt(FormatoOt ot) => repository.saveFormatoOt(ot);

  Future<FormatoActividades?> getFormatoActividades(int ordenId) => repository.getFormatoActividades(ordenId);
  Future<void> saveFormatoActividades(FormatoActividades act) => repository.saveFormatoActividades(act);

  Future<List<Repuesto>> getRepuestos(int ordenId) => repository.getRepuestos(ordenId);
  Future<void> addRepuesto(Repuesto r) => repository.addRepuesto(r);
  Future<void> deleteRepuesto(int repuestoId) => repository.deleteRepuesto(repuestoId);

  Future<List<FotoEvidencia>> getFotos(int ordenId) => repository.getFotosEvidencia(ordenId);
  Future<void> addFoto(FotoEvidencia f) => repository.addFotoEvidencia(f);
  Future<void> deleteFoto(int fotoId) => repository.deleteFotoEvidencia(fotoId);

  Future<FormatoActaEntrega?> getActa(int ordenId) => repository.getActaEntrega(ordenId);
  Future<void> cerrarOrdenConActa(FormatoActaEntrega acta) => repository.cerrarOrdenConActa(acta);
  Future<void> updateEstado(int ordenId, String estado) => repository.updateEstadoOrden(ordenId, estado);
}
