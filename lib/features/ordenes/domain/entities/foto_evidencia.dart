class FotoEvidencia {
  final int? id;
  final int ordenId;
  final String etapa; // 'RECEPCION' | 'PROCESO' | 'ENTREGA'
  final String rutaOBytesBase64;
  final String? notaTecnica;
  final DateTime fechaCaptura;

  const FotoEvidencia({
    this.id,
    required this.ordenId,
    required this.etapa,
    required this.rutaOBytesBase64,
    this.notaTecnica,
    required this.fechaCaptura,
  });

  String get fotoBase64 => rutaOBytesBase64;

  FotoEvidencia copyWith({
    int? id,
    int? ordenId,
    String? etapa,
    String? rutaOBytesBase64,
    String? notaTecnica,
    DateTime? fechaCaptura,
  }) {
    return FotoEvidencia(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      etapa: etapa ?? this.etapa,
      rutaOBytesBase64: rutaOBytesBase64 ?? this.rutaOBytesBase64,
      notaTecnica: notaTecnica ?? this.notaTecnica,
      fechaCaptura: fechaCaptura ?? this.fechaCaptura,
    );
  }
}
