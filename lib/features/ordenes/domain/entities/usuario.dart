class Usuario {
  final int? id;
  final String nombre;
  final String email;
  final String password;
  final String documento;
  final String telefono;
  final String rol; // 'admin', 'tecnico', 'solicitante', 'cliente'
  final bool activo;
  final DateTime? createdAt;

  const Usuario({
    this.id,
    required this.nombre,
    required this.email,
    required this.password,
    required this.documento,
    required this.telefono,
    required this.rol,
    this.activo = true,
    this.createdAt,
  });

  Usuario copyWith({
    int? id,
    String? nombre,
    String? email,
    String? password,
    String? documento,
    String? telefono,
    String? rol,
    bool? activo,
    DateTime? createdAt,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      password: password ?? this.password,
      documento: documento ?? this.documento,
      telefono: telefono ?? this.telefono,
      rol: rol ?? this.rol,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
