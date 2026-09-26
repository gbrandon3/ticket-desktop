import '../entities/cliente.dart';
import '../entities/dashboard_metrics.dart';
import '../entities/empresa_config.dart';
import '../entities/equipo.dart';
import '../entities/formato_acta_entrega.dart';
import '../entities/formato_actividades.dart';
import '../entities/formato_ot.dart';
import '../entities/foto_evidencia.dart';
import '../entities/notificacion_auditoria.dart';
import '../entities/orden.dart';
import '../entities/repuesto.dart';
import '../entities/tipo_falla.dart';
import '../entities/usuario.dart';

abstract class IOrdenesRepository {
  // Autenticación y Usuarios
  Future<Usuario?> login(String email, String password);
  Future<List<Usuario>> getUsuarios({String? rol});
  Future<Usuario> createUsuario(Usuario usuario);
  Future<void> updateUsuario(Usuario usuario);
  Future<void> toggleUsuarioActivo(int id, bool activo);
  Future<void> deleteUsuario(int id);
  Future<void> seedTestUsers();

  // Setup Wizard
  Future<bool> isSetupCompleted();
  Future<void> completeSetup({
    required EmpresaConfig empresa,
    required Usuario admin,
    Usuario? operador,
    Usuario? tecnico,
  });

  // Métricas y Dashboard
  Future<DashboardMetrics> getDashboardMetrics();
  Future<Map<String, dynamic>> getAdminMetrics();
  Stream<List<Orden>> watchOrdenes({String? busqueda, String? estado, String? tipo, int? tecnicoId, int? solicitanteId});
  Future<List<Orden>> getOrdenes({String? busqueda, String? estado, String? tipo, int? tecnicoId, int? solicitanteId});
  Future<Orden?> getOrdenById(int id);
  Future<void> asignarTecnico(int ordenId, int tecnicoId);

  // Clientes y Consulta Pública
  Future<Cliente?> findClienteByDocumento(String documento);
  Future<List<Cliente>> searchClientes(String query);
  Future<Cliente> saveCliente(Cliente cliente);
  Future<Orden?> consultaPublica(String codigoOOT, String documento);
  Future<Map<String, dynamic>> consultarPublico(String query);
  Future<List<Equipo>> getEquiposByClienteId(int clienteId);
  Future<List<Equipo>> searchEquipos({int? clienteId, String? tipo, String? query});
  Future<List<Orden>> getOrdenesByClienteId(int clienteId);

  // Registro de Órdenes
  Future<String> registrarOrdenCompleta({
    required Cliente cliente,
    required Equipo equipo,
    required Orden orden,
    String? fotoIngresoBase64,
  });

  // Formatos SENA
  Future<FormatoOt?> getFormatoOt(int ordenId);
  Future<void> saveFormatoOt(FormatoOt formatoOt);
  Future<FormatoActividades?> getFormatoActividades(int ordenId);
  Future<void> saveFormatoActividades(FormatoActividades actividades);
  Future<List<Repuesto>> getRepuestos(int ordenId);
  Future<void> addRepuesto(Repuesto repuesto);
  Future<void> deleteRepuesto(int repuestoId);
  Future<List<FotoEvidencia>> getFotosEvidencia(int ordenId);
  Future<void> addFotoEvidencia(FotoEvidencia foto);
  Future<void> deleteFotoEvidencia(int fotoId);
  Future<FormatoActaEntrega?> getActaEntrega(int ordenId);
  Future<void> cerrarOrdenConActa(FormatoActaEntrega acta);
  Future<void> updateEstadoOrden(int ordenId, String nuevoEstado);

  // Inventario de Equipos y Hoja de Vida
  Future<List<Equipo>> getInventarioEquipos({String? tipo, String? estado, String? busqueda});
  Future<List<Orden>> getHistorialEquipo(int equipoId);
  Future<void> updateEstadoEquipo(int equipoId, String nuevoEstado);

  // Configuración de Empresa y SMTP
  Future<EmpresaConfig> getEmpresaConfig();
  Future<void> saveEmpresaConfig(EmpresaConfig config);
  Stream<EmpresaConfig> watchEmpresaConfig();

  // Auditoría de Notificaciones
  Future<List<NotificacionAuditoria>> getAuditoriaNotificaciones();
  Future<void> registrarNotificacion(NotificacionAuditoria notif);

  // Catálogo de Tipos de Fallas en Base de Datos
  Future<List<TipoFalla>> getTiposFalla({String? tipoServicio});
  Future<TipoFalla> addTipoFalla(TipoFalla tipoFalla);
  Future<void> deleteTipoFalla(int id);
  Future<int> countTiposFalla();
}
