class EmpresaConfig {
  final int? id;
  final String nombreEmpresa;
  final String slogan;
  final String nit;
  final String telefono;
  final String email;
  final String direccion;
  final String ciudad;
  final String? logoBase64;
  final String? smtpHost;
  final int? smtpPort;
  final String? smtpUser;
  final String? smtpPass;
  final String colorPrimario;
  final String colorSecundario;
  final bool isSetupCompleted;

  const EmpresaConfig({
    this.id,
    required this.nombreEmpresa,
    required this.slogan,
    required this.nit,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.ciudad,
    this.logoBase64,
    this.smtpHost,
    this.smtpPort,
    this.smtpUser,
    this.smtpPass,
    this.colorPrimario = '#1E3A8A',
    this.colorSecundario = '#0284C7',
    this.isSetupCompleted = false,
  });

  const EmpresaConfig.defaultConfig()
      : id = 1,
        nombreEmpresa = 'Centro de Soporte & Mantenimiento',
        slogan = 'Para un equipo saludable CONTACTANOS',
        nit = '900.000.000-1',
        telefono = '+57 310 000 0000',
        email = 'soporte@empresa.com',
        direccion = 'Avenida Principal # 12-34',
        ciudad = 'Colombia',
        logoBase64 = null,
        smtpHost = null,
        smtpPort = null,
        smtpUser = null,
        smtpPass = null,
        colorPrimario = '#1E3A8A',
        colorSecundario = '#0284C7',
        isSetupCompleted = false;

  EmpresaConfig copyWith({
    int? id,
    String? nombreEmpresa,
    String? slogan,
    String? nit,
    String? telefono,
    String? email,
    String? direccion,
    String? ciudad,
    String? logoBase64,
    String? smtpHost,
    int? smtpPort,
    String? smtpUser,
    String? smtpPass,
    String? colorPrimario,
    String? colorSecundario,
    bool? isSetupCompleted,
  }) {
    return EmpresaConfig(
      id: id ?? this.id,
      nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
      slogan: slogan ?? this.slogan,
      nit: nit ?? this.nit,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      logoBase64: logoBase64 ?? this.logoBase64,
      smtpHost: smtpHost ?? this.smtpHost,
      smtpPort: smtpPort ?? this.smtpPort,
      smtpUser: smtpUser ?? this.smtpUser,
      smtpPass: smtpPass ?? this.smtpPass,
      colorPrimario: colorPrimario ?? this.colorPrimario,
      colorSecundario: colorSecundario ?? this.colorSecundario,
      isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
    );
  }
}
