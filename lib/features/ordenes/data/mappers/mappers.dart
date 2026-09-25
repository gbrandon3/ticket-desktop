import 'dart:convert';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/entities/empresa_config.dart';
import '../../domain/entities/equipo.dart';
import '../../domain/entities/formato_acta_entrega.dart';
import '../../domain/entities/formato_actividades.dart';
import '../../domain/entities/formato_ot.dart';
import '../../domain/entities/foto_evidencia.dart';
import '../../domain/entities/notificacion_auditoria.dart';
import '../../domain/entities/orden.dart';
import '../../domain/entities/repuesto.dart';
import '../../domain/entities/usuario.dart';

class Mappers {
  static Usuario toDomainUsuario(UsuariosTableData data) {
    return Usuario(
      id: data.id,
      nombre: data.nombre,
      email: data.email,
      password: data.password,
      documento: data.documento,
      telefono: data.telefono,
      rol: data.rol,
      activo: data.activo,
      createdAt: data.createdAt,
    );
  }

  static Cliente toDomainCliente(ClientesTableData data) {
    return Cliente(
      id: data.id,
      tipoDocumento: data.tipoDocumento,
      numeroDocumento: data.numeroDocumento,
      nombreCompleto: data.nombreCompleto,
      telefono: data.telefono,
      email: data.email,
      direccion: data.direccion,
      createdAt: data.createdAt,
    );
  }

  static Equipo toDomainEquipo(EquiposTableData data) {
    return Equipo(
      id: data.id,
      clienteId: data.clienteId,
      tipoEquipo: data.tipoEquipo,
      marca: data.marca,
      modelo: data.modelo,
      numeroSerie: data.numeroSerie,
      sistemaOperativo: data.sistemaOperativo,
      procesador: data.procesador,
      memoriaRam: data.memoriaRam,
      almacenamiento: data.almacenamiento,
      tarjetaGrafica: data.tarjetaGrafica,
      estadoEquipo: data.estadoEquipo,
      createdAt: data.createdAt,
    );
  }

  static Orden toDomainOrden(
    OrdenesTableData data, {
    Cliente? cliente,
    Equipo? equipo,
    Usuario? tecnico,
  }) {
    return Orden(
      id: data.id,
      codigoOrden: data.codigoOrden,
      clienteId: data.clienteId,
      equipoId: data.equipoId,
      tecnicoId: data.tecnicoId,
      solicitanteId: data.solicitanteId,
      tipoServicio: data.tipoServicio,
      categoriaFalla: data.categoriaFalla,
      prioridad: data.prioridad,
      titulo: data.titulo,
      descripcion: data.descripcion,
      estado: data.estado,
      fechaIngreso: data.fechaIngreso,
      fechaLimiteSla: data.fechaLimiteSla,
      fechaCierre: data.fechaCierre,
      cliente: cliente,
      equipo: equipo,
      tecnico: tecnico,
    );
  }

  static FormatoOt toDomainFormatoOt(FormatoOtTableData data) {
    List<String> chips = [];
    try {
      final decoded = jsonDecode(data.herramientasChips);
      if (decoded is List) {
        chips = decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}

    return FormatoOt(
      id: data.id,
      ordenId: data.ordenId,
      diagnosticoPreliminar: data.diagnosticoPreliminar,
      herramientasChips: chips,
      tiempoEstimadoEntrega: data.tiempoEstimadoEntrega,
      accesorioCargador: data.accesorioCargador,
      accesorioCablePoder: data.accesorioCablePoder,
      accesorioMouse: data.accesorioMouse,
      accesorioMaletin: data.accesorioMaletin,
      encendidoInicial: data.encendidoInicial,
      estadoCarcasa: data.estadoCarcasa,
      pinContrasena: data.pinContrasena,
    );
  }

  static FormatoActividades toDomainFormatoActividades(FormatoActividadesTableData data) {
    return FormatoActividades(
      id: data.id,
      ordenId: data.ordenId,
      procedimientosRealizados: data.procedimientosRealizados,
      pastaTermica: data.pastaTermica,
      alcoholIsopropilico: data.alcoholIsopropilico,
      sopleteadoContactos: data.sopleteadoContactos,
      brochaAntiestatica: data.brochaAntiestatica,
      panoMicrofibra: data.panoMicrofibra,
      depuracionTemporales: data.depuracionTemporales,
      optimizacionInicio: data.optimizacionInicio,
      escaneoMalware: data.escaneoMalware,
      actualizacionDrivers: data.actualizacionDrivers,
      comprobacionDisco: data.comprobacionDisco,
      qaEstresTermico: data.qaEstresTermico,
      qaPuertos: data.qaPuertos,
      qaConectividad: data.qaConectividad,
      qaBateria: data.qaBateria,
      qaTecladoTouchpad: data.qaTecladoTouchpad,
      costoManoObra: data.costoManoObra,
    );
  }

  static Repuesto toDomainRepuesto(RepuestosOrdenTableData data) {
    return Repuesto(
      id: data.id,
      ordenId: data.ordenId,
      referencia: data.referencia,
      cantidad: data.cantidad,
      precioUnitario: data.precioUnitario,
      subtotal: data.subtotal,
    );
  }

  static FormatoActaEntrega toDomainActaEntrega(FormatoActaEntregaTableData data) {
    return FormatoActaEntrega(
      id: data.id,
      ordenId: data.ordenId,
      estadoOperatividad: data.estadoOperatividad,
      observaciones: data.observaciones,
      recomendacionesCuidado: data.recomendacionesCuidado,
      garantiaDias: data.garantiaDias,
      personaRecibeNombre: data.personaRecibeNombre,
      personaRecibeDocumento: data.personaRecibeDocumento,
      checkConformidad: data.checkConformidad,
      fechaEntrega: data.fechaEntrega,
    );
  }

  static FotoEvidencia toDomainFoto(FotosEvidenciaTableData data) {
    return FotoEvidencia(
      id: data.id,
      ordenId: data.ordenId,
      etapa: data.etapa,
      rutaOBytesBase64: data.rutaOBytesBase64,
      notaTecnica: data.notaTecnica,
      fechaCaptura: data.fechaCaptura,
    );
  }

  static EmpresaConfig toDomainEmpresaConfig(ConfiguracionEmpresaTableData data) {
    return EmpresaConfig(
      id: data.id,
      nombreEmpresa: data.nombreEmpresa,
      slogan: data.slogan,
      nit: data.nit,
      telefono: data.telefono,
      email: data.email,
      direccion: data.direccion,
      ciudad: data.ciudad,
      logoBase64: data.logoBase64,
      smtpHost: data.smtpHost,
      smtpPort: data.smtpPort,
      smtpUser: data.smtpUser,
      smtpPass: data.smtpPass,
      colorPrimario: data.colorPrimario,
      colorSecundario: data.colorSecundario,
      isSetupCompleted: data.isSetupCompleted,
    );
  }

  static NotificacionAuditoria toDomainNotificacion(NotificacionesAuditoriaTableData data) {
    return NotificacionAuditoria(
      id: data.id,
      destinatario: data.destinatario,
      asunto: data.asunto,
      evento: data.evento,
      estado: data.estado,
      fechaEnvio: data.fechaEnvio,
    );
  }
}
