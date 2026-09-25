class Cliente {
  final int? id;
  final String tipoDocumento;
  final String numeroDocumento;
  final String nombreCompleto;
  final String telefono;
  final String? email;
  final String direccion;
  final DateTime? createdAt;

  const Cliente({
    this.id,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.nombreCompleto,
    required this.telefono,
    this.email,
    required this.direccion,
    this.createdAt,
  });

  Cliente copyWith({
    int? id,
    String? tipoDocumento,
    String? numeroDocumento,
    String? nombreCompleto,
    String? telefono,
    String? email,
    String? direccion,
    DateTime? createdAt,
  }) {
    return Cliente(
      id: id ?? this.id,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
