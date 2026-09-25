class Repuesto {
  final int? id;
  final int ordenId;
  final String referencia;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const Repuesto({
    this.id,
    required this.ordenId,
    required this.referencia,
    this.cantidad = 1,
    required this.precioUnitario,
    required this.subtotal,
  });

  Repuesto copyWith({
    int? id,
    int? ordenId,
    String? referencia,
    int? cantidad,
    double? precioUnitario,
    double? subtotal,
  }) {
    return Repuesto(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      referencia: referencia ?? this.referencia,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}
