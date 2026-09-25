import 'cliente.dart';
import 'equipo.dart';
import 'usuario.dart';

class Orden {
  final int? id;
  final String codigoOrden;
  final int clienteId;
  final int equipoId;
  final int? tecnicoId;
  final int? solicitanteId;
  final String tipoServicio; // 'PREVENTIVO' | 'CORRECTIVO'
  final String categoriaFalla; // 'HARDWARE' | 'SOFTWARE' | 'RED' | 'MIXTO'
  final String prioridad; // 'BAJA' | 'MEDIA' | 'ALTA' | 'CRITICA'
  final String titulo;
  final String descripcion;
  final String estado; // 'RECIBIDO' | 'EN_DIAGNOSTICO' | 'EN_TALLER' | 'LISTO_ENTREGA' | 'ENTREGADO_CERRADO'
  final DateTime fechaIngreso;
  final DateTime? fechaLimiteSla;
  final DateTime? fechaCierre;

  // Relaciones cargadas para presentación
  final Cliente? cliente;
  final Equipo? equipo;
  final Usuario? tecnico;

  const Orden({
    this.id,
    required this.codigoOrden,
    required this.clienteId,
    required this.equipoId,
    this.tecnicoId,
    this.solicitanteId,
    required this.tipoServicio,
    required this.categoriaFalla,
    required this.prioridad,
    required this.titulo,
    required this.descripcion,
    this.estado = 'RECIBIDO',
    required this.fechaIngreso,
    this.fechaLimiteSla,
    this.fechaCierre,
    this.cliente,
    this.equipo,
    this.tecnico,
  });

  bool get estaVencidoSla {
    if (fechaLimiteSla == null) return false;
    if (estado == 'ENTREGADO_CERRADO' || estado == 'LISTO_ENTREGA') return false;
    return DateTime.now().isAfter(fechaLimiteSla!);
  }

  Orden copyWith({
    int? id,
    String? codigoOrden,
    int? clienteId,
    int? equipoId,
    int? tecnicoId,
    int? solicitanteId,
    String? tipoServicio,
    String? categoriaFalla,
    String? prioridad,
    String? titulo,
    String? descripcion,
    String? estado,
    DateTime? fechaIngreso,
    DateTime? fechaLimiteSla,
    DateTime? fechaCierre,
    Cliente? cliente,
    Equipo? equipo,
    Usuario? tecnico,
  }) {
    return Orden(
      id: id ?? this.id,
      codigoOrden: codigoOrden ?? this.codigoOrden,
      clienteId: clienteId ?? this.clienteId,
      equipoId: equipoId ?? this.equipoId,
      tecnicoId: tecnicoId ?? this.tecnicoId,
      solicitanteId: solicitanteId ?? this.solicitanteId,
      tipoServicio: tipoServicio ?? this.tipoServicio,
      categoriaFalla: categoriaFalla ?? this.categoriaFalla,
      prioridad: prioridad ?? this.prioridad,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      fechaLimiteSla: fechaLimiteSla ?? this.fechaLimiteSla,
      fechaCierre: fechaCierre ?? this.fechaCierre,
      cliente: cliente ?? this.cliente,
      equipo: equipo ?? this.equipo,
      tecnico: tecnico ?? this.tecnico,
    );
  }
}
