class FormatoActaEntrega {
  final int? id;
  final int ordenId;
  final String estadoOperatividad; // 'OPERATIVO' | 'SIN_SOLUCION'
  final String? observaciones;
  final String? recomendacionesCuidado;
  final String garantiaDias; // '30_DIAS' | '60_DIAS' | '90_DIAS' | 'SIN_GARANTIA'
  final String personaRecibeNombre;
  final String personaRecibeDocumento;
  final bool checkConformidad;
  final DateTime fechaEntrega;

  const FormatoActaEntrega({
    this.id,
    required this.ordenId,
    required this.estadoOperatividad,
    this.observaciones,
    this.recomendacionesCuidado,
    required this.garantiaDias,
    required this.personaRecibeNombre,
    required this.personaRecibeDocumento,
    this.checkConformidad = false,
    required this.fechaEntrega,
  });

  FormatoActaEntrega copyWith({
    int? id,
    int? ordenId,
    String? estadoOperatividad,
    String? observaciones,
    String? recomendacionesCuidado,
    String? garantiaDias,
    String? personaRecibeNombre,
    String? personaRecibeDocumento,
    bool? checkConformidad,
    DateTime? fechaEntrega,
  }) {
    return FormatoActaEntrega(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      estadoOperatividad: estadoOperatividad ?? this.estadoOperatividad,
      observaciones: observaciones ?? this.observaciones,
      recomendacionesCuidado: recomendacionesCuidado ?? this.recomendacionesCuidado,
      garantiaDias: garantiaDias ?? this.garantiaDias,
      personaRecibeNombre: personaRecibeNombre ?? this.personaRecibeNombre,
      personaRecibeDocumento: personaRecibeDocumento ?? this.personaRecibeDocumento,
      checkConformidad: checkConformidad ?? this.checkConformidad,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
    );
  }
}
