import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../../../core/services/email_service.dart';
import '../../../../core/services/export_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/notificacion_auditoria.dart';
import '../../domain/entities/usuario.dart';
import '../providers/auth_provider.dart';
import '../providers/catalogo_fallas_provider.dart';
import '../providers/ordenes_providers.dart';

class ConfiguracionPageScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const ConfiguracionPageScreen({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<ConfiguracionPageScreen> createState() => _ConfiguracionPageScreenState();
}

class _ConfiguracionPageScreenState extends ConsumerState<ConfiguracionPageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // TAB 1: MI PERFIL
  final _perfilFormKey = GlobalKey<FormState>();
  final _nombrePerfilCtrl = TextEditingController();
  final _emailPerfilCtrl = TextEditingController();
  final _telefonoPerfilCtrl = TextEditingController();
  final _docPerfilCtrl = TextEditingController();
  final _passActualCtrl = TextEditingController();
  final _passNuevaCtrl = TextEditingController();
  final _passConfirmCtrl = TextEditingController();
  bool _guardandoPerfil = false;

  // TAB 2: IDENTIDAD CORPORATIVA
  final _empresaFormKey = GlobalKey<FormState>();
  final _nombreEmpresaCtrl = TextEditingController();
  final _sloganCtrl = TextEditingController();
  final _nitCtrl = TextEditingController();
  final _telefonoEmpresaCtrl = TextEditingController();
  final _emailEmpresaCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _ciudadCtrl = TextEditingController();
  String? _logoBase64;
  String _colorPdfEmpresa = '#1E3A8A';
  bool _guardandoEmpresa = false;

  // TAB 3: GESTIÓN DE USUARIOS
  List<Usuario> _usuarios = [];
  bool _cargandoUsuarios = true;
  bool _mostrandoFormUsuario = false;
  final _newUserFormKey = GlobalKey<FormState>();
  final _newNombreCtrl = TextEditingController();
  final _newEmailCtrl = TextEditingController();
  final _newTelCtrl = TextEditingController();
  final _newDocCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  String _newRol = 'tecnico';
  bool _creandoUsuario = false;

  // TAB 4: SERVIDOR SMTP
  final _smtpFormKey = GlobalKey<FormState>();
  final _smtpHostCtrl = TextEditingController(text: 'smtp.gmail.com');
  final _smtpPortCtrl = TextEditingController(text: '465');
  final _smtpUserCtrl = TextEditingController();
  final _smtpPassCtrl = TextEditingController();
  final _smtpRemitenteCtrl = TextEditingController();
  final _smtpApiUrlCtrl = TextEditingController();
  final _emailPruebaCtrl = TextEditingController();
  bool _ocultarSmtpPass = true;
  bool _guardandoSmtp = false;
  bool _probandoSmtp = false;
  String? _resultadoPruebaSmtp;
  bool? _exitoPruebaSmtp;

  // TAB 5: TEMA VISUAL (3 predefinidos + 1 personalizable)
  Color _customPrimaryColor = const Color(0xFFEA580C);
  Color _customHeaderColor = const Color(0xFF0F172A);
  final _hexColorCtrl = TextEditingController(text: '#EA580C');

  // TAB 7: RESPALDO & DATOS
  bool _exportandoBackup = false;
  bool _exportandoTicketsCsv = false;
  bool _exportandoClientesCsv = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);
    final esAdmin = user?.rol == 'admin';
    final count = esAdmin ? 7 : 1;
    final initialIdx = (widget.initialTabIndex >= count || !esAdmin) ? 0 : widget.initialTabIndex;
    _tabController = TabController(length: count, vsync: this, initialIndex: initialIdx);
    _cargarDatosIniciales();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nombrePerfilCtrl.dispose();
    _emailPerfilCtrl.dispose();
    _telefonoPerfilCtrl.dispose();
    _docPerfilCtrl.dispose();
    _passActualCtrl.dispose();
    _passNuevaCtrl.dispose();
    _passConfirmCtrl.dispose();

    _nombreEmpresaCtrl.dispose();
    _sloganCtrl.dispose();
    _nitCtrl.dispose();
    _telefonoEmpresaCtrl.dispose();
    _emailEmpresaCtrl.dispose();
    _direccionCtrl.dispose();
    _ciudadCtrl.dispose();

    _newNombreCtrl.dispose();
    _newEmailCtrl.dispose();
    _newTelCtrl.dispose();
    _newDocCtrl.dispose();
    _newPassCtrl.dispose();

    _smtpHostCtrl.dispose();
    _smtpPortCtrl.dispose();
    _smtpUserCtrl.dispose();
    _smtpPassCtrl.dispose();
    _smtpRemitenteCtrl.dispose();
    _smtpApiUrlCtrl.dispose();
    _emailPruebaCtrl.dispose();
    _hexColorCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarDatosIniciales() async {
    final repo = ref.read(ordenesRepositoryProvider);
    final user = ref.read(authProvider);

    // Cargar perfil
    if (user != null) {
      _nombrePerfilCtrl.text = user.nombre;
      _emailPerfilCtrl.text = user.email;
      _telefonoPerfilCtrl.text = user.telefono;
      _docPerfilCtrl.text = user.documento;
      _emailPruebaCtrl.text = user.email;
    }

    // Cargar empresa y SMTP
    final config = await repo.getEmpresaConfig();
    _nombreEmpresaCtrl.text = config.nombreEmpresa;
    _sloganCtrl.text = config.slogan;
    _nitCtrl.text = config.nit;
    _telefonoEmpresaCtrl.text = config.telefono;
    _emailEmpresaCtrl.text = config.email;
    _direccionCtrl.text = config.direccion;
    _ciudadCtrl.text = config.ciudad;
    _logoBase64 = config.logoBase64;
    _colorPdfEmpresa = config.colorPrimario;

    _smtpHostCtrl.text = config.smtpHost ?? 'smtp.gmail.com';
    _smtpPortCtrl.text = (config.smtpPort ?? 465).toString();
    _smtpUserCtrl.text = config.smtpUser ?? '';
    _smtpPassCtrl.text = config.smtpPass ?? '';
    _smtpRemitenteCtrl.text = config.email;

    // Cargar usuarios
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    setState(() => _cargandoUsuarios = true);
    final repo = ref.read(ordenesRepositoryProvider);
    final users = await repo.getUsuarios();
    if (mounted) {
      setState(() {
        _usuarios = users;
        _cargandoUsuarios = false;
      });
    }
  }

  // Guardar Mi Perfil
  Future<void> _guardarPerfil() async {
    if (!_perfilFormKey.currentState!.validate()) return;

    final user = ref.read(authProvider);
    if (user == null) return;

    // Si intenta cambiar contraseña, validar contraseña actual y nueva
    if (_passNuevaCtrl.text.isNotEmpty || _passActualCtrl.text.isNotEmpty) {
      if (_passActualCtrl.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor ingrese su contraseña actual para cambiarla'), backgroundColor: Colors.red),
        );
        return;
      }
      if (_passActualCtrl.text != user.password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La contraseña actual no es correcta'), backgroundColor: Colors.red),
        );
        return;
      }
      if (_passNuevaCtrl.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor ingrese la nueva contraseña'), backgroundColor: Colors.red),
        );
        return;
      }
      if (_passNuevaCtrl.text != _passConfirmCtrl.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas nuevas no coinciden'), backgroundColor: Colors.red),
        );
        return;
      }
    }

    setState(() => _guardandoPerfil = true);
    final repo = ref.read(ordenesRepositoryProvider);

    final updated = user.copyWith(
      nombre: _nombrePerfilCtrl.text.trim(),
      telefono: _telefonoPerfilCtrl.text.trim(),
      documento: _docPerfilCtrl.text.trim(),
      password: _passNuevaCtrl.text.isNotEmpty ? _passNuevaCtrl.text.trim() : user.password,
    );

    await repo.updateUsuario(updated);
    ref.read(authProvider.notifier).updateProfile(updated);

    setState(() => _guardandoPerfil = false);
    _passActualCtrl.clear();
    _passNuevaCtrl.clear();
    _passConfirmCtrl.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente'), backgroundColor: SantiConstants.successGreen),
      );
    }
  }

  // Guardar Identidad Corporativa
  Future<void> _guardarEmpresa() async {
    if (!_empresaFormKey.currentState!.validate()) return;

    setState(() => _guardandoEmpresa = true);
    final repo = ref.read(ordenesRepositoryProvider);
    final configActual = await repo.getEmpresaConfig();

    final nuevaConfig = configActual.copyWith(
      nombreEmpresa: _nombreEmpresaCtrl.text.trim(),
      slogan: _sloganCtrl.text.trim(),
      nit: _nitCtrl.text.trim(),
      telefono: _telefonoEmpresaCtrl.text.trim(),
      email: _emailEmpresaCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim(),
      ciudad: _ciudadCtrl.text.trim(),
      logoBase64: _logoBase64,
      colorPrimario: _colorPdfEmpresa,
    );

    await repo.saveEmpresaConfig(nuevaConfig);
    setState(() => _guardandoEmpresa = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Identidad corporativa guardada con éxito'), backgroundColor: SantiConstants.successGreen),
      );
    }
  }

  // Subir Logo
  Future<void> _seleccionarLogo() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);
    if (img != null) {
      final bytes = await img.readAsBytes();
      setState(() {
        _logoBase64 = base64Encode(bytes);
      });
    }
  }

  // Crear Usuario
  Future<void> _crearUsuario() async {
    if (!_newUserFormKey.currentState!.validate()) return;

    setState(() => _creandoUsuario = true);
    final repo = ref.read(ordenesRepositoryProvider);

    final nuevo = Usuario(
      nombre: _newNombreCtrl.text.trim(),
      email: _newEmailCtrl.text.trim(),
      password: _newPassCtrl.text.trim(),
      rol: _newRol,
      telefono: _newTelCtrl.text.trim().isEmpty ? '0' : _newTelCtrl.text.trim(),
      documento: _newDocCtrl.text.trim().isEmpty ? '0' : _newDocCtrl.text.trim(),
      activo: true,
      createdAt: DateTime.now(),
    );

    try {
      await repo.createUsuario(nuevo);
      _newNombreCtrl.clear();
      _newEmailCtrl.clear();
      _newTelCtrl.clear();
      _newDocCtrl.clear();
      _newPassCtrl.clear();
      setState(() {
        _creandoUsuario = false;
        _mostrandoFormUsuario = false;
      });
      _cargarUsuarios();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado satisfactoriamente'), backgroundColor: SantiConstants.successGreen),
        );
      }
    } catch (e) {
      setState(() => _creandoUsuario = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creando usuario: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Alternar Activo Usuario
  Future<void> _toggleUsuario(Usuario u) async {
    final repo = ref.read(ordenesRepositoryProvider);
    final nuevoEstado = !u.activo;
    await repo.toggleUsuarioActivo(u.id!, nuevoEstado);
    _cargarUsuarios();
  }

  // Guardar SMTP
  Future<void> _guardarSmtp() async {
    if (!_smtpFormKey.currentState!.validate()) return;

    setState(() => _guardandoSmtp = true);
    final repo = ref.read(ordenesRepositoryProvider);
    final configActual = await repo.getEmpresaConfig();

    final nuevaConfig = configActual.copyWith(
      smtpHost: _smtpHostCtrl.text.trim(),
      smtpPort: int.tryParse(_smtpPortCtrl.text.trim()) ?? 465,
      smtpUser: _smtpUserCtrl.text.trim(),
      smtpPass: _smtpPassCtrl.text.trim(),
    );

    await repo.saveEmpresaConfig(nuevaConfig);
    setState(() => _guardandoSmtp = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parámetros SMTP actualizados correctamente'), backgroundColor: SantiConstants.successGreen),
      );
    }
  }

  // Probar SMTP
  Future<void> _probarSmtp() async {
    final dest = _emailPruebaCtrl.text.trim();
    if (dest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese un correo destinatario para la prueba'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_smtpUserCtrl.text.trim().isEmpty || _smtpPassCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese usuario y contraseña de aplicación SMTP antes de probar'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _probandoSmtp = true;
      _resultadoPruebaSmtp = null;
    });

    final repo = ref.read(ordenesRepositoryProvider);

    final res = await EmailService.sendEmail(
      apiUrl: _smtpApiUrlCtrl.text.trim(),
      host: _smtpHostCtrl.text.trim(),
      port: int.tryParse(_smtpPortCtrl.text.trim()) ?? 465,
      user: _smtpUserCtrl.text.trim(),
      pass: _smtpPassCtrl.text.trim(),
      to: dest,
      subject: 'Diagnóstico de Conexión SMTP - Santi Inc',
      message: 'Este es un mensaje de prueba generado desde el módulo de configuración de Santi Inc para validar la autenticación y conectividad del servidor SMTP.',
    );

    await repo.registrarNotificacion(
      NotificacionAuditoria(
        destinatario: dest,
        asunto: 'Diagnóstico de Conexión SMTP',
        evento: 'TEST_CONEXION_SMTP',
        estado: res.success ? 'ENVIADO' : 'FALLIDO',
        fechaEnvio: DateTime.now(),
      ),
    );

    if (mounted) {
      setState(() {
        _probandoSmtp = false;
        _exitoPruebaSmtp = res.success;
        _resultadoPruebaSmtp = res.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final esAdmin = user?.rol == 'admin';
    final themeState = ref.watch(appThemeNotifierProvider);
    final expectedLength = esAdmin ? 7 : 1;

    if (_tabController.length != expectedLength) {
      _tabController.dispose();
      _tabController = TabController(length: expectedLength, vsync: this, initialIndex: 0);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(esAdmin ? 'Configuración del Sistema y Parámetros' : 'Mi Perfil y Preferencias'),
        backgroundColor: themeState.headerColor,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: esAdmin
              ? const [
                  Tab(icon: Icon(Icons.person, size: 20), text: 'Mi Perfil'),
                  Tab(icon: Icon(Icons.business, size: 20), text: 'Identidad Corporativa'),
                  Tab(icon: Icon(Icons.people_alt, size: 20), text: 'Gestión de Usuarios'),
                  Tab(icon: Icon(Icons.mark_email_read, size: 20), text: 'Servidor SMTP'),
                  Tab(icon: Icon(Icons.palette, size: 20), text: 'Tema Visual'),
                  Tab(icon: Icon(Icons.build_circle_outlined, size: 20), text: 'Fallas & Diagnósticos'),
                  Tab(icon: Icon(Icons.cloud_download_outlined, size: 20), text: 'Respaldo & Datos'),
                ]
              : const [
                  Tab(icon: Icon(Icons.person, size: 20), text: 'Mi Perfil'),
                ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: esAdmin
            ? [
                _buildTabPerfil(),
                _buildTabEmpresa(),
                _buildTabUsuarios(),
                _buildTabSmtp(),
                _buildTabTema(themeState),
                _buildTabCatalogoFallas(),
                _buildTabRespaldo(),
              ]
            : [
                _buildTabPerfil(),
              ],
      ),
    );
  }

  // ==================== TAB 1: MI PERFIL ====================
  Widget _buildTabPerfil() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Form(
        key: _perfilFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Información Personal y Credenciales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy)),
            const SizedBox(height: 6),
            const Text('Actualice sus datos de contacto y contraseña de acceso.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nombrePerfilCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre Completo *'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _emailPerfilCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Correo Electrónico',
                      helperText: 'El correo electrónico es el identificador único del usuario',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _telefonoPerfilCtrl,
                    decoration: const InputDecoration(labelText: 'Teléfono o Celular'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _docPerfilCtrl,
                    decoration: const InputDecoration(labelText: 'Documento de Identidad'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Divider(),
            const SizedBox(height: 14),
            const Text('Cambiar Contraseña de Acceso', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy)),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _passActualCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña Actual',
                      hintText: 'Ingrese contraseña actual',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _passNuevaCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Nueva Contraseña',
                      hintText: 'Ingrese nueva contraseña',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _passConfirmCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Nueva Contraseña',
                      hintText: 'Repita nueva contraseña',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _guardandoPerfil ? null : _guardarPerfil,
              icon: const Icon(Icons.save),
              label: Text(_guardandoPerfil ? 'Guardando...' : 'Guardar Cambios de Perfil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: SantiConstants.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== TAB 2: IDENTIDAD CORPORATIVA ====================
  Widget _buildTabEmpresa() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Form(
        key: _empresaFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Personalización Multi-Empresa / White-Label', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy)),
                const SizedBox(height: 6),
                const Text('Configure el membrete institucional. Estos datos se reflejarán en toda la interfaz y en las actas de entrega en PDF.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _nombreEmpresaCtrl,
                        decoration: const InputDecoration(labelText: 'Nombre de la Empresa o Taller *'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _nitCtrl,
                        decoration: const InputDecoration(labelText: 'NIT / ID Fiscal *'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _sloganCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Slogan',
                    hintText: 'Slogan',
                    helperText: 'Slogan',
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _telefonoEmpresaCtrl,
                        decoration: const InputDecoration(labelText: 'Teléfono / WhatsApp *'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _emailEmpresaCtrl,
                        decoration: const InputDecoration(labelText: 'Correo Electrónico de Soporte *'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _direccionCtrl,
                        decoration: const InputDecoration(labelText: 'Dirección Física del Local *'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _ciudadCtrl,
                        decoration: const InputDecoration(labelText: 'Ciudad y País *'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Logotipo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _logoBase64 != null
                            ? Image.memory(base64Decode(_logoBase64!), fit: BoxFit.contain)
                            : const Icon(Icons.business, size: 36, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Logotipo Institucional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            const Text('Se renderiza en el encabezado de las actas oficiales de entrega generadas.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _seleccionarLogo,
                                  icon: const Icon(Icons.upload_file, size: 16),
                                  label: const Text('Subir Logo'),
                                ),
                                if (_logoBase64 != null) ...[
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () => setState(() => _logoBase64 = null),
                                    child: const Text('Quitar Logo', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Personalización de Color del PDF
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _parseHexColor(_colorPdfEmpresa, const Color(0xFF1E3A8A)),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Color Oficial de Documentos y Actas PDF',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: SantiConstants.primaryNavy),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Seleccione el color de acento principal que vestirá las actas oficiales impresas y reportes exportados.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          _buildPdfColorChip('#1E3A8A', 'Azul Marino Oficial'),
                          _buildPdfColorChip('#0284C7', 'Azul Tech'),
                          _buildPdfColorChip('#059669', 'Verde Esmeralda'),
                          _buildPdfColorChip('#EA580C', 'Naranja Taller'),
                          _buildPdfColorChip('#4F46E5', 'Índigo Moderno'),
                          _buildPdfColorChip('#DC2626', 'Rojo Corporativo'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: _guardandoEmpresa ? null : _guardarEmpresa,
                  icon: const Icon(Icons.save),
                  label: Text(_guardandoEmpresa ? 'Guardando...' : 'Guardar Identidad Institucional'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SantiConstants.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      }

  Widget _buildPdfColorChip(String hex, String label) {
    final isSelected = _colorPdfEmpresa.toUpperCase() == hex.toUpperCase();
    final color = _parseHexColor(hex, const Color(0xFF1E3A8A));

    return InkWell(
      onTap: () => setState(() => _colorPdfEmpresa = hex),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.black87,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(Icons.check, size: 14, color: color),
            ],
          ],
        ),
      ),
    );
  }

  // ==================== TAB 3: GESTIÓN DE USUARIOS ====================
  Widget _buildTabUsuarios() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gestión de Usuarios y Roles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy)),
                  SizedBox(height: 4),
                  Text('Administre los accesos y roles del equipo de soporte.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _mostrandoFormUsuario = !_mostrandoFormUsuario),
                icon: Icon(_mostrandoFormUsuario ? Icons.close : Icons.person_add),
                label: Text(_mostrandoFormUsuario ? 'Cerrar Formulario' : 'Nuevo Usuario'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _mostrandoFormUsuario ? Colors.grey.shade700 : SantiConstants.primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Formulario Nuevo Usuario
          if (_mostrandoFormUsuario) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _newUserFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Registrar Nuevo Usuario en la Plataforma', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy)),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _newNombreCtrl,
                              decoration: const InputDecoration(labelText: 'Nombre Completo *'),
                              validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _newEmailCtrl,
                              decoration: const InputDecoration(labelText: 'Correo Electrónico (Login) *'),
                              validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: _newRol,
                              decoration: const InputDecoration(labelText: 'Rol Asignado'),
                              items: const [
                                DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                                DropdownMenuItem(value: 'tecnico', child: Text('Técnico')),
                                DropdownMenuItem(value: 'operador', child: Text('Operador')),
                              ],
                              onChanged: (v) => setState(() => _newRol = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _newTelCtrl,
                              decoration: const InputDecoration(labelText: 'Teléfono / Móvil'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _newDocCtrl,
                              decoration: const InputDecoration(labelText: 'Documento Identidad'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _newPassCtrl,
                              obscureText: true,
                              decoration: const InputDecoration(labelText: 'Contraseña Inicial *'),
                              validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _creandoUsuario ? null : _crearUsuario,
                        icon: const Icon(Icons.check),
                        label: Text(_creandoUsuario ? 'Creando...' : 'Crear y Habilitar Usuario'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SantiConstants.successGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Tabla de Usuarios
          if (_cargandoUsuarios)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
          else
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      color: const Color(0xFFF1F5F9),
                      child: const Row(
                        children: [
                          Expanded(flex: 3, child: Text('Usuario', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                          Expanded(flex: 2, child: Text('Rol', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                          Expanded(flex: 2, child: Text('Teléfono', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                          Expanded(flex: 2, child: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                          Expanded(flex: 1, child: Text('Acción', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _usuarios.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final u = _usuarios[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.blue.shade100,
                                      child: Text(
                                        u.nombre.isNotEmpty ? u.nombre[0].toUpperCase() : 'U',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(u.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                        Text(u.email, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: _buildRolBadge(u.rol),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(u.telefono.isNotEmpty ? u.telefono : 'Sin teléfono', style: const TextStyle(fontSize: 12)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  u.activo ? '🟢 Activo' : '🔴 Inactivo',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: u.activo ? Colors.green : Colors.red),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Switch(
                                    value: u.activo,
                                    activeColor: SantiConstants.successGreen,
                                    onChanged: (val) => _toggleUsuario(u),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== TAB 4: SERVIDOR SMTP ====================
  Widget _buildTabSmtp() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Parámetros de Servidor SMTP (Notificaciones por Correo)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy)),
              const SizedBox(height: 6),
              const Text('Configure las credenciales de correo saliente para alertar automáticamente a los clientes sobre cambios de estado y radicación de tickets.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 20),

              Form(
                key: _smtpFormKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _smtpHostCtrl,
                            decoration: const InputDecoration(labelText: 'Host SMTP *', hintText: 'ej. smtp.gmail.com'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _smtpPortCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Puerto *', hintText: '465 / 587'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _smtpUserCtrl,
                            decoration: const InputDecoration(labelText: 'Usuario / Correo Saliente *', hintText: 'ej. soporte@mitaller.com'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _smtpPassCtrl,
                            obscureText: _ocultarSmtpPass,
                            decoration: InputDecoration(
                              labelText: 'Contraseña de Aplicación *',
                              suffixIcon: IconButton(
                                icon: Icon(_ocultarSmtpPass ? Icons.visibility : Icons.visibility_off),
                                onPressed: () => setState(() => _ocultarSmtpPass = !_ocultarSmtpPass),
                              ),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _smtpRemitenteCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre o Correo Remitente (Header FROM) *', hintText: 'ej. Soporte Técnico <contacto@empresa.com>'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _smtpApiUrlCtrl,
                      decoration: const InputDecoration(
                        labelText: 'URL Endpoint Serverless Vercel (Opcional)',
                        hintText: 'https://su-proyecto.vercel.app/api/send-email',
                        helperText: 'Déjelo vacío si la app web corre en el mismo dominio de Vercel. Indique la URL si prueba desde Desktop o en localhost.',
                      ),
                    ),
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        onPressed: _guardandoSmtp ? null : _guardarSmtp,
                        icon: const Icon(Icons.save),
                        label: Text(_guardandoSmtp ? 'Guardando...' : 'Guardar Configuración SMTP'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SantiConstants.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              const Divider(),
              const SizedBox(height: 16),

              // Sección de Prueba
              const Text('Diagnóstico y Prueba de Conexión SMTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy)),
              const SizedBox(height: 6),
              const Text('Envíe un mensaje de prueba al correo especificado para verificar la comunicación con el servidor SMTP.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailPruebaCtrl,
                      decoration: const InputDecoration(labelText: 'Correo Destinatario para Test'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _probandoSmtp ? null : _probarSmtp,
                    icon: _probandoSmtp
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send),
                    label: Text(_probandoSmtp ? 'Probando...' : 'Probar Conexión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ],
              ),
              if (_resultadoPruebaSmtp != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _exitoPruebaSmtp == true ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _exitoPruebaSmtp == true ? Colors.green.shade200 : Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _exitoPruebaSmtp == true ? Icons.check_circle : Icons.error,
                        color: _exitoPruebaSmtp == true ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _resultadoPruebaSmtp!,
                          style: TextStyle(
                            fontSize: 13,
                            color: _exitoPruebaSmtp == true ? Colors.green.shade900 : Colors.red.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      }

  // ==================== TAB 5: TEMA VISUAL (3 PRESETS + 1 PERSONALIZABLE) ====================
  Color _parseHexColor(String hex, Color fallback) {
    try {
      String clean = hex.replaceAll('#', '').trim();
      if (clean.length == 6) clean = 'FF$clean';
      if (clean.length == 8) return Color(int.parse(clean, radix: 16));
    } catch (_) {}
    return fallback;
  }

  Widget _buildTabTema(AppThemeState currentTheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Paleta Institucional y Tema Visual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy)),
          const SizedBox(height: 6),
          const Text('Seleccione el esquema de color corporativo de la interfaz. Dispone de 3 temas predefinidos o personalice el suyo.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 24),

          // 4 Opciones de tema (3 predefinidos + 1 personalizable)
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 750;
              final cards = [
                _buildThemeCard(
                  id: 'AZUL',
                  label: 'Azul Corporativo',
                  subtitle: 'Clásico & Profesional',
                  primary: const Color(0xFF2563EB),
                  header: const Color(0xFF1E3A8A),
                  isSelected: currentTheme.id == 'AZUL',
                  onTap: () {
                    ref.read(appThemeNotifierProvider.notifier).setTheme('AZUL');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tema Azul Corporativo activado'), duration: Duration(seconds: 1)),
                    );
                  },
                ),
                _buildThemeCard(
                  id: 'VERDE',
                  label: 'Verde Esmeralda',
                  subtitle: 'Fresco & Ágil',
                  primary: const Color(0xFF059669),
                  header: const Color(0xFF064E3B),
                  isSelected: currentTheme.id == 'VERDE',
                  onTap: () {
                    ref.read(appThemeNotifierProvider.notifier).setTheme('VERDE');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tema Verde Esmeralda activado'), duration: Duration(seconds: 1)),
                    );
                  },
                ),
                _buildThemeCard(
                  id: 'PURPURA',
                  label: 'Púrpura Tech',
                  subtitle: 'Moderno & Tecnológico',
                  primary: const Color(0xFF7C3AED),
                  header: const Color(0xFF4C1D95),
                  isSelected: currentTheme.id == 'PURPURA',
                  onTap: () {
                    ref.read(appThemeNotifierProvider.notifier).setTheme('PURPURA');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tema Púrpura Tech activado'), duration: Duration(seconds: 1)),
                    );
                  },
                ),
                _buildThemeCard(
                  id: 'CUSTOM',
                  label: 'Personalizado',
                  subtitle: 'Paleta a Tu Medida',
                  primary: _customPrimaryColor,
                  header: _customHeaderColor,
                  isSelected: currentTheme.id == 'CUSTOM',
                  isCustomOption: true,
                  onTap: () {
                    ref.read(appThemeNotifierProvider.notifier).setCustomTheme(
                          primaryColor: _customPrimaryColor,
                          headerColor: _customHeaderColor,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tema Personalizado activado'), duration: Duration(seconds: 1)),
                    );
                  },
                ),
              ];

              if (isNarrow) {
                return Column(
                  children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
                );
              }
              return Row(
                children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
              );
            },
          ),
          const SizedBox(height: 28),

          // PANEL DE CONFIGURACIÓN DEL TEMA PERSONALIZADO
          if (currentTheme.id == 'CUSTOM') ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1)),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _customPrimaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.tune, color: _customPrimaryColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Personalización de Colores', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Defina los colores corporativos primarios y de cabecera.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 28),

                  // 1. Selector de Color Primario (Botones y Acentos)
                  const Text('1. Color Primario (Botones, Acentos y Selección)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildPresetChip('Naranja', const Color(0xFFEA580C)),
                      _buildPresetChip('Rojo', const Color(0xFFDC2626)),
                      _buildPresetChip('Índigo', const Color(0xFF4F46E5)),
                      _buildPresetChip('Teal', const Color(0xFF0D9488)),
                      _buildPresetChip('Ámbar', const Color(0xFFD97706)),
                      _buildPresetChip('Rosa', const Color(0xFFDB2777)),
                      _buildPresetChip('Grafito', const Color(0xFF334155)),
                      _buildPresetChip('Cian', const Color(0xFF0284C7)),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Input Hexadecimal
                  Row(
                    children: [
                      SizedBox(
                        width: 160,
                        child: TextField(
                          controller: _hexColorCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Código HEX',
                            hintText: '#EA580C',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          final parsed = _parseHexColor(_hexColorCtrl.text, _customPrimaryColor);
                          setState(() => _customPrimaryColor = parsed);
                          ref.read(appThemeNotifierProvider.notifier).setCustomTheme(
                                primaryColor: parsed,
                                headerColor: _customHeaderColor,
                              );
                        },
                        icon: const Icon(Icons.colorize, size: 16),
                        label: const Text('Aplicar HEX', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _customPrimaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. Selector de Color de Cabecera (Header / AppBar)
                  const Text('2. Color de Barra Superior / Encabezado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildHeaderPresetChip('Azul Marino', const Color(0xFF0F172A)),
                      _buildHeaderPresetChip('Carbón', const Color(0xFF18181B)),
                      _buildHeaderPresetChip('Noche Profunda', const Color(0xFF111827)),
                      _buildHeaderPresetChip('Índigo Noche', const Color(0xFF1E1B4B)),
                      _buildHeaderPresetChip('Púrpura Noche', const Color(0xFF2E1065)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 3. Vista Previa en Vivo
                  const Text('Vista Previa en Vivo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569))),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Mock AppBar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          color: _customHeaderColor,
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: _customPrimaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.settings, color: Colors.white, size: 16),
                              ),
                              const SizedBox(width: 10),
                              const Text('Panel de Administración', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _customPrimaryColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                ),
                                child: const Text('Acción', style: TextStyle(fontSize: 11)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                                Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _customPrimaryColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text('Acento Activo', style: TextStyle(color: _customPrimaryColor, fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add, size: 14),
                                label: const Text('Nuevo Registro', style: TextStyle(fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _customPrimaryColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: SantiConstants.primaryBlue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'El esquema de colores seleccionado se propaga automáticamente a la barra superior, barra lateral de navegación, botones y acentos de toda la aplicación.',
                    style: TextStyle(fontSize: 12, color: SantiConstants.primaryNavy),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String name, Color color) {
    final isSelected = _customPrimaryColor == color;
    return InkWell(
      onTap: () {
        setState(() {
          _customPrimaryColor = color;
          final hex = color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();
          _hexColorCtrl.text = '#$hex';
        });
        ref.read(appThemeNotifierProvider.notifier).setCustomTheme(
              primaryColor: color,
              headerColor: _customHeaderColor,
            );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : const Color(0xFFCBD5E1), width: isSelected ? 2 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 7, backgroundColor: color),
            const SizedBox(width: 6),
            Text(name, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? color : const Color(0xFF334155))),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderPresetChip(String name, Color color) {
    final isSelected = _customHeaderColor == color;
    return InkWell(
      onTap: () {
        setState(() => _customHeaderColor = color);
        ref.read(appThemeNotifierProvider.notifier).setCustomTheme(
              primaryColor: _customPrimaryColor,
              headerColor: color,
            );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : const Color(0xFFCBD5E1), width: isSelected ? 2 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 7, backgroundColor: color),
            const SizedBox(width: 6),
            Text(name, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: const Color(0xFF334155))),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard({
    required String id,
    required String label,
    required String subtitle,
    required Color primary,
    required Color header,
    required bool isSelected,
    required VoidCallback onTap,
    bool isCustomOption = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : const Color(0xFFE2E8F0),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: primary.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 3))]
              : const [BoxShadow(color: Colors.black12, blurRadius: 3)],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 14, backgroundColor: primary),
                const SizedBox(width: 8),
                CircleAvatar(radius: 14, backgroundColor: header),
                if (isCustomOption) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.palette, size: 16, color: Color(0xFF64748B)),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (isSelected)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: primary, size: 16),
                  const SizedBox(width: 4),
                  Text('Activo', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 11)),
                ],
              )
            else
              Text(
                isCustomOption ? 'Configurar' : 'Seleccionar',
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRolBadge(String rol) {
    Color bg;
    Color fg;
    String label;

    switch (rol) {
      case 'admin':
        bg = Colors.purple.shade50;
        fg = Colors.purple.shade800;
        label = 'ADMIN';
        break;
      case 'tecnico':
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade800;
        label = 'TÉCNICO';
        break;
      case 'operador':
      case 'solicitante':
        bg = Colors.amber.shade50;
        fg = Colors.amber.shade900;
        label = 'OPERADOR';
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade800;
        label = rol.toUpperCase();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: fg)),
      ),
    );
  }

  // ==================== TAB 6: CATÁLOGO DE FALLAS & DIAGNÓSTICO (SOLO ADMIN) ====================
  Widget _buildTabCatalogoFallas() {
    final catalogo = ref.watch(catalogoFallasProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner explicativo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings, color: Color(0xFF2563EB), size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Administración de Tipos de Falla',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3A8A)),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Como Administrador, puede definir y gestionar el catálogo de tipos de fallas disponibles para clasificar las órdenes del taller.',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // SECCIÓN 1: TIPOS DE FALLA - MANTENIMIENTO CORRECTIVO
          _buildSeccionCatalogo(
            titulo: 'Tipos de Falla - Mantenimiento Correctivo',
            subtitulo: 'Averías y categorías técnicas seleccionables al recibir equipos dañados o con falla reportada.',
            color: const Color(0xFFEF4444),
            icono: Icons.report_problem_outlined,
            items: catalogo.tiposCorrectivo,
            onAgregar: _dialogAgregarFallaCorrectivoAdmin,
            onEliminar: (item) => ref.read(catalogoFallasProvider.notifier).removeTipoCorrectivo(item),
          ),

          const SizedBox(height: 24),

          // SECCIÓN 2: ALCANCES - MANTENIMIENTO PREVENTIVO
          _buildSeccionCatalogo(
            titulo: 'Tipos de Falla - Mantenimiento Preventivo',
            subtitulo: 'Procedimientos de limpieza, optimización y mantenimiento periódico.',
            color: const Color(0xFF2563EB),
            icono: Icons.cleaning_services_outlined,
            items: catalogo.tiposPreventivo,
            onAgregar: _dialogAgregarFallaPreventivoAdmin,
            onEliminar: (item) => ref.read(catalogoFallasProvider.notifier).removeTipoPreventivo(item),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSeccionCatalogo({
    required String titulo,
    required String subtitulo,
    required Color color,
    required IconData icono,
    required List<String> items,
    required VoidCallback onAgregar,
    required ValueChanged<String> onEliminar,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icono, color: color, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    titulo,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${items.length} activos',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onAgregar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('+ Agregar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitulo, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 14),
          if (items.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Text(
                'No hay tipos de falla registrados. Haga clic en "+ Agregar" para registrar uno.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontStyle: FontStyle.italic),
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: items.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => onEliminar(item),
                        child: const Icon(Icons.close, size: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Future<void> _dialogAgregarFallaCorrectivoAdmin() async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Tipo de Falla (Correctivo)'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nombre de la Falla',
            hintText: 'ej. Corto en tarjeta madre / Sin video',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final text = ctrl.text.trim();
              if (text.isNotEmpty) {
                ref.read(catalogoFallasProvider.notifier).addTipoCorrectivo(text);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tipo de falla "$text" agregado al catálogo.'),
                    backgroundColor: SantiConstants.successGreen,
                  ),
                );
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  Future<void> _dialogAgregarFallaPreventivoAdmin() async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Alcance (Preventivo)'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nombre del Servicio Preventivo',
            hintText: 'ej. Mantenimiento Preventivo de Servidor Rack',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final text = ctrl.text.trim();
              if (text.isNotEmpty) {
                ref.read(catalogoFallasProvider.notifier).addTipoPreventivo(text);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Servicio preventivo "$text" agregado al catálogo.'),
                    backgroundColor: SantiConstants.successGreen,
                  ),
                );
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  // ==================== TAB 7: RESPALDO & DATOS ====================
  Widget _buildTabRespaldo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Copias de Seguridad & Exportación de Datos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy),
          ),
          const SizedBox(height: 6),
          const Text(
            'Descargue respaldos íntegros de la base de datos o exporte tablas individuales a formato Excel/CSV para auditorías, reportes y salvaguarda de información.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Card 1: Full Backup
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.cloud_download, color: SantiConstants.primaryBlue, size: 28),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Copia de Seguridad Completa (Full Backup JSON)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: SantiConstants.primaryNavy),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Genera un archivo JSON con todos los clientes, equipos, historial de órdenes, catálogo de fallas y configuración institucional.',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _exportandoBackup
                        ? null
                        : () async {
                            setState(() => _exportandoBackup = true);
                            try {
                              final repo = ref.read(ordenesRepositoryProvider);
                              final res = await ExportService.exportFullBackup(repo);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(res ?? 'Copia de seguridad generada exitosamente'),
                                    backgroundColor: SantiConstants.successGreen,
                                    duration: const Duration(seconds: 4),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al generar respaldo: $e'), backgroundColor: Colors.red),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _exportandoBackup = false);
                            }
                          },
                    icon: _exportandoBackup
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.download),
                    label: Text(_exportandoBackup ? 'Generando Respaldo...' : 'Descargar Copia de Seguridad Completa (.JSON)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SantiConstants.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Card 2: Exportar Órdenes a CSV
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.table_chart, color: Colors.green, size: 28),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Historial Operativo de Tickets y Órdenes (.CSV / Excel)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: SantiConstants.primaryNavy),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Exporta todas las órdenes con clientes, equipos asociados, fechas, estado y técnicos asignados con codificación UTF-8 compatible con Excel.',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _exportandoTicketsCsv
                        ? null
                        : () async {
                            setState(() => _exportandoTicketsCsv = true);
                            try {
                              final repo = ref.read(ordenesRepositoryProvider);
                              final ordenes = await repo.getOrdenes();
                              final res = await ExportService.exportOrdenesCsv(ordenes);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(res ?? 'Se exportaron ${ordenes.length} órdenes a CSV'),
                                    backgroundColor: SantiConstants.successGreen,
                                    duration: const Duration(seconds: 4),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al exportar CSV: $e'), backgroundColor: Colors.red),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _exportandoTicketsCsv = false);
                            }
                          },
                    icon: _exportandoTicketsCsv
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.file_download),
                    label: Text(_exportandoTicketsCsv ? 'Exportando...' : 'Exportar Tickets a Excel / CSV'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Card 3: Exportar Clientes y Equipos a CSV
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.people_alt, color: Colors.orange, size: 28),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Directorio de Clientes y Equipos (.CSV / Excel)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: SantiConstants.primaryNavy),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Exporta la base de clientes registrados con sus datos de contacto y total de equipos vinculados.',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _exportandoClientesCsv
                        ? null
                        : () async {
                            setState(() => _exportandoClientesCsv = true);
                            try {
                              final repo = ref.read(ordenesRepositoryProvider);
                              final clientes = await repo.searchClientes('');
                              final equipos = await repo.getInventarioEquipos();
                              final res = await ExportService.exportClientesEquiposCsv(clientes: clientes, equipos: equipos);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(res ?? 'Se exportaron ${clientes.length} clientes a CSV'),
                                    backgroundColor: SantiConstants.successGreen,
                                    duration: const Duration(seconds: 4),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al exportar clientes: $e'), backgroundColor: Colors.red),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _exportandoClientesCsv = false);
                            }
                          },
                    icon: _exportandoClientesCsv
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.file_download),
                    label: Text(_exportandoClientesCsv ? 'Exportando...' : 'Exportar Directorio de Clientes (.CSV)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
