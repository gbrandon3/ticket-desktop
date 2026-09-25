class TipoFalla {
  final int? id;
  final String tipoServicio; // 'CORRECTIVO' o 'PREVENTIVO'
  final String nombre;
  final String? descripcion;
  final bool activo;
  final DateTime? createdAt;

  const TipoFalla({
    this.id,
    required this.tipoServicio,
    required this.nombre,
    this.descripcion,
    this.activo = true,
    this.createdAt,
  });

  TipoFalla copyWith({
    int? id,
    String? tipoServicio,
    String? nombre,
    String? descripcion,
    bool? activo,
    DateTime? createdAt,
  }) {
    return TipoFalla(
      id: id ?? this.id,
      tipoServicio: tipoServicio ?? this.tipoServicio,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
