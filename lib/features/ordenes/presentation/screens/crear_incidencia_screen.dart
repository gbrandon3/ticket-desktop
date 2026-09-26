import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/email_service.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/entities/equipo.dart';
import '../../domain/entities/notificacion_auditoria.dart';
import '../../domain/entities/orden.dart';
import '../../domain/entities/usuario.dart';
import '../providers/auth_provider.dart';
import '../providers/catalogo_fallas_provider.dart';
import '../providers/ordenes_providers.dart';

class CrearIncidenciaScreen extends ConsumerStatefulWidget {
  final VoidCallback? onOrdenCreada;

  const CrearIncidenciaScreen({super.key, this.onOrdenCreada});

  @override
  ConsumerState<CrearIncidenciaScreen> createState() => _CrearIncidenciaScreenState();
}

class _CrearIncidenciaScreenState extends ConsumerState<CrearIncidenciaScreen> {
  int _currentStep = 0;
  bool _mostrarAlertaSmtp = true;

  // ==================== PASO 1: CLIENTE ====================
  final _searchClienteCtrl = TextEditingController();
  List<Cliente> _clientesEncontrados = [];
  bool _buscandoClientes = false;
  Cliente? _clienteSeleccionado;

  // ==================== PASO 2: TIPO E INCIDENCIA ====================
  String _tipoServicio = 'CORRECTIVO'; // CORRECTIVO | PREVENTIVO
  String _categoriaFalla = 'Hardware Físico / Componentes';
  final _categoriaFallaCtrl = TextEditingController(text: 'Hardware Físico / Componentes');

  final _tituloCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  String _prioridad = 'Media - Funcionamiento parcial / Falla no bloqueante';

  // ==================== PASO 3: EQUIPO Y ESPECIFICACIONES ====================
  String _tipoEquipo = 'Portátil / Laptop'; // Portátil / Laptop | PC de Mesa | All-in-One
  final _searchEquipoCtrl = TextEditingController();
  List<Equipo> _equiposEncontrados = [];
  bool _buscandoEquipos = false;
  Equipo? _equipoSeleccionado;
  bool _mostrarFormularioEquipo = true;
  bool _sinSerialVisible = false;

  // Campos ficha técnica (vacíos por defecto)
  final _marcaCtrl = TextEditingController();
  final _modeloCtrl = TextEditingController();
  final _serialCtrl = TextEditingController();
  final _soCtrl = TextEditingController();
  final _cpuCtrl = TextEditingController();
  final _ramCtrl = TextEditingController();
  final _discoCtrl = TextEditingController();
  final _gpuCtrl = TextEditingController();
  String? _fotoBase64;

  // ==================== PASO 4: ASIGNAR TÉCNICO ====================
  final _searchTecnicoCtrl = TextEditingController();
  List<Usuario> _todosTecnicos = [];
  List<Usuario> _tecnicosFiltrados = [];
  Usuario? _tecnicoSeleccionado;
  bool _cargandoTecnicos = false;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _inicializarDatos();
  }

  Future<void> _inicializarDatos() async {
    _buscarClientesRealtime('');
    _cargarTecnicos();
  }

  Future<void> _buscarClientesRealtime(String query) async {
    setState(() => _buscandoClientes = true);
    final repo = ref.read(ordenesRepositoryProvider);
    try {
      final list = await repo.searchClientes(query);
      if (mounted) {
        setState(() {
          _clientesEncontrados = list;
          _buscandoClientes = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _buscandoClientes = false);
    }
  }

  Future<void> _cargarTecnicos() async {
    setState(() => _cargandoTecnicos = true);
    final repo = ref.read(ordenesRepositoryProvider);
    try {
      final tecs = await repo.getUsuarios(rol: 'tecnico');
      if (mounted) {
        setState(() {
          _todosTecnicos = tecs;
          _tecnicosFiltrados = tecs;
          _cargandoTecnicos = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _cargandoTecnicos = false);
    }
  }

  void _filtrarTecnicos(String query) {
    final clean = query.trim().toLowerCase();
    setState(() {
      if (clean.isEmpty) {
        _tecnicosFiltrados = _todosTecnicos;
      } else {
        _tecnicosFiltrados = _todosTecnicos.where((t) {
          return t.nombre.toLowerCase().contains(clean) ||
              t.email.toLowerCase().contains(clean) ||
              t.documento.contains(clean);
        }).toList();
      }
    });
  }

  Future<void> _buscarEquipos([String? query]) async {
    setState(() => _buscandoEquipos = true);
    final repo = ref.read(ordenesRepositoryProvider);
    try {
      final list = await repo.searchEquipos(
        clienteId: _clienteSeleccionado?.id,
        tipo: _tipoEquipo,
        query: query ?? _searchEquipoCtrl.text,
      );
      if (mounted) {
        setState(() {
          _equiposEncontrados = list;
          _buscandoEquipos = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _buscandoEquipos = false);
    }
  }

  String _obtenerPrefijoSegunTipo() {
    switch (_tipoEquipo) {
      case 'Portátil / Laptop':
        return 'LAP';
      case 'All-in-One':
        return 'AIO';
      case 'PC de Mesa':
      default:
        return 'MESA';
    }
  }

  void _autogenerarSerialSegunTipo() {
    final prefix = _obtenerPrefijoSegunTipo();
    final randomNum = Random().nextInt(9000) + 1000;
    setState(() {
      _serialCtrl.text = '$prefix-$randomNum';
    });
  }

  Future<void> _tomarFoto() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _fotoBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar imagen: $e')),
        );
      }
    }
  }

  void _abrirModalNuevoCliente() {
    final tipoDocCtrl = ValueNotifier<String>('CC');
    final docCtrl = TextEditingController();
    final nombreCtrl = TextEditingController();
    final telCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final dirCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person_add, color: Color(0xFF2563EB)),
            SizedBox(width: 8),
            Text('Registrar Nuevo Cliente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: tipoDocCtrl,
                    builder: (context, value, _) {
                      return DropdownButtonFormField<String>(
                        value: value,
                        decoration: const InputDecoration(labelText: 'Tipo de Documento *'),
                        items: const [
                          DropdownMenuItem(value: 'CC', child: Text('Cédula de Ciudadanía (CC)')),
                          DropdownMenuItem(value: 'NIT', child: Text('NIT (Empresarial)')),
                          DropdownMenuItem(value: 'CE', child: Text('Cédula de Extranjería (CE)')),
                          DropdownMenuItem(value: 'PASAPORTE', child: Text('Pasaporte')),
                        ],
                        onChanged: (v) => tipoDocCtrl.value = v ?? 'CC',
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: docCtrl,
                    decoration: const InputDecoration(labelText: 'Número de Documento *'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre Completo / Razón Social *'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: telCtrl,
                    decoration: const InputDecoration(labelText: 'Teléfono / Móvil *'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Correo Electrónico (Opcional)'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: dirCtrl,
                    decoration: const InputDecoration(labelText: 'Dirección (Opcional)'),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final nuevoCliente = Cliente(
                  tipoDocumento: tipoDocCtrl.value,
                  numeroDocumento: docCtrl.text.trim(),
                  nombreCompleto: nombreCtrl.text.trim(),
                  telefono: telCtrl.text.trim(),
                  email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
                  direccion: dirCtrl.text.trim(),
                );
                final repo = ref.read(ordenesRepositoryProvider);
                final saved = await repo.saveCliente(nuevoCliente);
                if (!mounted) return;
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                }
                setState(() {
                  _clienteSeleccionado = saved;
                });
                _buscarClientesRealtime('');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cliente ${saved.nombreCompleto} registrado y seleccionado.'),
                    backgroundColor: const Color(0xFF16A34A),
                  ),
                );
              }
            },
            child: const Text('Guardar y Seleccionar'),
          ),
        ],
      ),
    );
  }

  void _seleccionarEquipoDeTabla(Equipo equipo) {
    setState(() {
      _equipoSeleccionado = equipo;
      _tipoEquipo = equipo.tipoEquipo;
      _marcaCtrl.text = equipo.marca;
      _modeloCtrl.text = equipo.modelo;
      _serialCtrl.text = equipo.numeroSerie;
      _soCtrl.text = equipo.sistemaOperativo ?? '';
      _cpuCtrl.text = equipo.procesador ?? '';
      _ramCtrl.text = equipo.memoriaRam ?? '';
      _discoCtrl.text = equipo.almacenamiento ?? '';
      _gpuCtrl.text = equipo.tarjetaGrafica ?? '';
      _mostrarFormularioEquipo = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Equipo seleccionado: ${equipo.marca} ${equipo.modelo} (${equipo.numeroSerie})'),
        backgroundColor: const Color(0xFF16A34A),
      ),
    );
  }

  void _validarYAvanzarPaso1() {
    if (_clienteSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor busque y elija un cliente de la tabla antes de continuar.'),
          backgroundColor: Color(0xFFEAB308),
        ),
      );
      return;
    }
    setState(() => _currentStep = 1);
  }

  Future<void> _dialogCrearTipoFalla() async {
    final nuevoTipoCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.add_circle, color: Color(0xFF2563EB)),
            const SizedBox(width: 8),
            Text(
              _tipoServicio == 'PREVENTIVO'
                  ? 'Crear Tipo de Servicio Preventivo'
                  : 'Crear Tipo o Categoría de Falla',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Defina el nuevo tipo o categoría de falla según el problema del equipo:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nuevoTipoCtrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Nombre del Tipo de Falla / Alcance *',
                hintText: _tipoServicio == 'PREVENTIVO'
                    ? 'ej. Mantenimiento Preventivo de Servidor'
                    : 'ej. Corto en etapa de potencia / Mosfet quemado',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final text = nuevoTipoCtrl.text.trim();
              if (text.isNotEmpty) {
                if (_tipoServicio == 'PREVENTIVO') {
                  ref.read(catalogoFallasProvider.notifier).addTipoPreventivo(text);
                } else {
                  ref.read(catalogoFallasProvider.notifier).addTipoCorrectivo(text);
                }
                setState(() {
                  _categoriaFalla = text;
                  _categoriaFallaCtrl.text = text;
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tipo de falla "$text" guardado en el catálogo y seleccionado.'),
                    backgroundColor: const Color(0xFF16A34A),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Crear y Seleccionar'),
          ),
        ],
      ),
    );
  }

  void _validarYAvanzarPaso2() {
    final catFinal = _categoriaFallaCtrl.text.trim().isNotEmpty
        ? _categoriaFallaCtrl.text.trim()
        : _categoriaFalla;
    if (catFinal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor indique o cree el tipo o categoría de falla.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }
    if (_tituloCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_tipoServicio == 'PREVENTIVO'
              ? 'Por favor ingrese el motivo o alcance del mantenimiento preventivo.'
              : 'Por favor ingrese el título o síntoma reportado.'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
      return;
    }
    if (_descripcionCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_tipoServicio == 'PREVENTIVO'
              ? 'Por favor describa el servicio preventivo requerido.'
              : 'Por favor describa el comportamiento o falla detallada.'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
      return;
    }
    setState(() => _currentStep = 2);
  }

  void _validarYAvanzarPaso3() {
    if (_tipoEquipo == 'PC de Mesa') {
      // Para PC de Mesa: no exigir marca de fabricante ni modelo comercial
      if (_marcaCtrl.text.trim().isEmpty) {
        _marcaCtrl.text = 'Clon / Ensamblado';
      }
      if (_modeloCtrl.text.trim().isEmpty) {
        _modeloCtrl.text = 'Torre ATX';
      }
      if (_serialCtrl.text.trim().isEmpty) {
        _autogenerarSerialSegunTipo();
      }
      setState(() => _currentStep = 3);
      return;
    }

    // Para Portátiles y All-in-One: validar datos del fabricante
    if (_marcaCtrl.text.trim().isEmpty || _modeloCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete la marca y modelo del equipo.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }
    if (_serialCtrl.text.trim().isEmpty) {
      if (_sinSerialVisible) {
        _autogenerarSerialSegunTipo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor ingrese el número de serie o marque "Equipo sin número de serie visible".'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        return;
      }
    }
    setState(() => _currentStep = 3);
  }

  Future<void> _finalizarYRadicarOrden() async {
    setState(() => _guardando = true);
    final usuarioActual = ref.read(authProvider);

    try {
      final cliente = _clienteSeleccionado!;

      final equipo = Equipo(
        id: _equipoSeleccionado?.id,
        clienteId: cliente.id ?? 0,
        tipoEquipo: _tipoEquipo,
        marca: _marcaCtrl.text.trim(),
        modelo: _modeloCtrl.text.trim(),
        numeroSerie: _serialCtrl.text.trim(),
        sistemaOperativo: _soCtrl.text.trim(),
        procesador: _cpuCtrl.text.trim(),
        memoriaRam: _ramCtrl.text.trim(),
        almacenamiento: _discoCtrl.text.trim(),
        tarjetaGrafica: _gpuCtrl.text.trim(),
      );

      final prioridadCorta = _prioridad.startsWith('Baja')
          ? 'BAJA'
          : _prioridad.startsWith('Alta')
              ? 'ALTA'
              : _prioridad.startsWith('Crítica')
                  ? 'CRITICA'
                  : 'MEDIA';

      final orden = Orden(
        codigoOrden: '',
        clienteId: cliente.id ?? 0,
        equipoId: 0,
        tecnicoId: _tecnicoSeleccionado?.id,
        solicitanteId: usuarioActual?.id,
        tipoServicio: _tipoServicio,
        categoriaFalla: _categoriaFallaCtrl.text.trim().isNotEmpty
            ? _categoriaFallaCtrl.text.trim()
            : _categoriaFalla,
        prioridad: prioridadCorta,
        titulo: _tituloCtrl.text.trim(),
        descripcion: _descripcionCtrl.text.trim(),
        fechaIngreso: DateTime.now(),
      );

      final useCase = ref.read(createOrdenUseCaseProvider);
      final codigo = await useCase(
        cliente: cliente,
        equipo: equipo,
        orden: orden,
        fotoIngresoBase64: _fotoBase64,
      );

      bool correoEnviado = false;
      String? errorCorreo;

      if (cliente.email != null && cliente.email!.trim().isNotEmpty) {
        try {
          final repo = ref.read(ordenesRepositoryProvider);
          final config = await repo.getEmpresaConfig();

          if (config.smtpUser != null &&
              config.smtpPass != null &&
              config.smtpUser!.trim().isNotEmpty &&
              config.smtpPass!.trim().isNotEmpty) {
            String baseUrl = 'https://ticket-desktop.vercel.app';
            if (config.portalHostUrl != null && config.portalHostUrl!.trim().isNotEmpty) {
              baseUrl = config.portalHostUrl!.trim();
              if (baseUrl.endsWith('/')) {
                baseUrl = baseUrl.substring(0, baseUrl.length - 1);
              }
            } else if (kIsWeb && Uri.base.hasAuthority && Uri.base.host.isNotEmpty) {
              baseUrl = Uri.base.origin;
            }
            final trackingUrl = '$baseUrl/#/consulta';

            final msg = '''Estimado(a) ${cliente.nombreCompleto},

Su orden de servicio técnico ha sido radicada exitosamente en ${config.nombreEmpresa}.

RESUMEN DE LA INCIDENCIA:
• Código de Ticket: $codigo
• Equipo: $_tipoEquipo - ${_marcaCtrl.text.trim()} ${_modeloCtrl.text.trim()}
• Número de Serie: ${_serialCtrl.text.trim().isNotEmpty ? _serialCtrl.text.trim() : 'N/A'}
• Tipo de Servicio: $_tipoServicio
• Falla / Motivo: ${_categoriaFallaCtrl.text.trim().isNotEmpty ? _categoriaFallaCtrl.text.trim() : _categoriaFalla}
• Prioridad: $prioridadCorta
• Fecha de Radicación: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}

SEGUIMIENTO EN VIVO:
Puede consultar en tiempo real el avance, diagnósticos y fotografías de evidencia de su equipo ingresando al portal de consulta con su código de ticket ($codigo):
$trackingUrl

Atentamente,
${config.nombreEmpresa}
Área de Soporte & Mantenimiento Técnico''';

            final resEmail = await EmailService.sendEmail(
              apiUrl: config.smtpApiUrl,
              host: config.smtpHost ?? 'smtp.gmail.com',
              port: config.smtpPort ?? 465,
              user: config.smtpUser!,
              pass: config.smtpPass!,
              to: cliente.email!.trim(),
              subject: 'Incidencia Radicada #$codigo - ${config.nombreEmpresa}',
              message: msg,
              trackingUrl: trackingUrl,
            );

            correoEnviado = resEmail.success;
            if (!resEmail.success) {
              errorCorreo = resEmail.message;
            }

            await repo.registrarNotificacion(
              NotificacionAuditoria(
                destinatario: cliente.email!.trim(),
                asunto: 'Incidencia Radicada #$codigo',
                evento: 'NUEVA_ORDEN_CLIENTE',
                estado: resEmail.success ? 'ENVIADO' : 'FALLIDO',
                fechaEnvio: DateTime.now(),
              ),
            );
          }
        } catch (err) {
          errorCorreo = err.toString();
        }
      }

      setState(() => _guardando = false);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 30),
                SizedBox(width: 10),
                Text('¡Incidencia Radicada con Éxito!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'La orden de trabajo de mantenimiento técnico ha sido generada correctamente en el sistema.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('CÓDIGO DE ORDEN / TICKET: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                            Text(
                              codigo,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
                            ),
                          ],
                        ),
                        const Divider(height: 18),
                        Text('• Cliente: ${cliente.nombreCompleto} (${cliente.numeroDocumento})', style: const TextStyle(fontSize: 12)),
                        Text('• Equipo: $_tipoEquipo - ${_marcaCtrl.text} ${_modeloCtrl.text} [SN: ${_serialCtrl.text}]', style: const TextStyle(fontSize: 12)),
                        Text('• Tipo de Servicio: $_tipoServicio | Falla: $_categoriaFalla', style: const TextStyle(fontSize: 12)),
                        Text(
                          '• Técnico Asignado: ${_tecnicoSeleccionado != null ? _tecnicoSeleccionado!.nombre : "Bolsa General (Sin Asignar)"}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _tecnicoSeleccionado != null ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                          ),
                        ),
                        if (cliente.email != null && cliente.email!.trim().isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: correoEnviado ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: correoEnviado ? const Color(0xFFBBF7D0) : const Color(0xFFFDE68A)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  correoEnviado ? Icons.mark_email_read : Icons.mail_outline,
                                  size: 16,
                                  color: correoEnviado ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    correoEnviado
                                        ? 'Notificación enviada con enlace de seguimiento a ${cliente.email}'
                                        : (errorCorreo != null
                                            ? 'No se pudo enviar correo: $errorCorreo'
                                            : 'Aviso: Configure el servidor SMTP para enviar enlaces automáticos.'),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: correoEnviado ? const Color(0xFF15803D) : const Color(0xFFB45309),
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
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (widget.onOrdenCreada != null) {
                    widget.onOrdenCreada!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Aceptar y Finalizar', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() => _guardando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al radicar incidencia: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Abrir Nueva Orden de Mantenimiento'),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: _guardando
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Radicando orden de trabajo y generando registro...', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                      // Banner SMTP (Image 3)
                      if (_mostrarAlertaSmtp) _buildSmtpBanner(),

                      const SizedBox(height: 14),

                      // Título y Subtítulo
                      const Text(
                        'Abrir Nueva Orden de Mantenimiento',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Complete el formulario guiado paso a paso para registrar la incidencia y asignar un técnico.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Stepper Horizontal de 4 pasos (Images 3, 4, 5)
                      _buildStepperHeader(),

                      const SizedBox(height: 20),

                      // Tarjeta Principal del Paso
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_currentStep == 0) _buildPaso1Content(),
                            if (_currentStep == 1) _buildPaso2Content(),
                            if (_currentStep == 2) _buildPaso3Content(),
                            if (_currentStep == 3) _buildPaso4Content(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
  }

  // ==================== ALERTA SMTP ====================
  Widget _buildSmtpBanner() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 650;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEFCE8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFEF08A)),
          ),
          child: isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.mail_outline, color: Color(0xFFD97706), size: 24),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Servidor de Correo Electrónico (SMTP) no configurado',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF92400E)),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18, color: Color(0xFF92400E)),
                          onPressed: () => setState(() => _mostrarAlertaSmtp = false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Configure los datos de su correo saliente para que el sistema pueda enviar notificaciones automáticas a los clientes y al personal técnico.',
                      style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Acceda al módulo de Configuración para configurar SMTP')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.settings, size: 14),
                      label: const Text('Configurar Ahora →'),
                    ),
                  ],
                )
              : Row(
                  children: [
                    const Icon(Icons.mail_outline, color: Color(0xFFD97706), size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Servidor de Correo Electrónico (SMTP) no configurado',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF92400E)),
                          ),
                          Text(
                            'Configure los datos de su correo saliente para que el sistema pueda enviar notificaciones automáticas a los clientes y al personal técnico.',
                            style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Acceda al módulo de Configuración para configurar SMTP')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.settings, size: 14),
                          SizedBox(width: 6),
                          Text('Configurar Ahora →'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18, color: Color(0xFF92400E)),
                      onPressed: () => setState(() => _mostrarAlertaSmtp = false),
                    ),
                  ],
                ),
        );
      },
    );
  }

  // ==================== STEPPER HEADER (4 PASOS) ====================
  Widget _buildStepperHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 900;
          if (isNarrow) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStepNode(
                    stepIndex: 0,
                    number: '1',
                    title: 'Paso 1',
                    subtitle: 'Buscar Cliente',
                    activeColor: const Color(0xFFEA580C),
                  ),
                  _buildStepLine(fromStep: 0, expanded: false),
                  _buildStepNode(
                    stepIndex: 1,
                    number: '2',
                    title: 'Paso 2',
                    subtitle: 'Tipo e Incidencia',
                    activeColor: const Color(0xFF2563EB),
                  ),
                  _buildStepLine(fromStep: 1, expanded: false),
                  _buildStepNode(
                    stepIndex: 2,
                    number: '3',
                    title: 'Paso 3',
                    subtitle: 'Equipo y Especificaciones',
                    activeColor: const Color(0xFF16A34A),
                  ),
                  _buildStepLine(fromStep: 2, expanded: false),
                  _buildStepNode(
                    stepIndex: 3,
                    number: '4',
                    title: 'Paso 4',
                    subtitle: 'Asignar Técnico',
                    activeColor: const Color(0xFF7C3AED),
                  ),
                ],
              ),
            );
          }

          return Row(
            children: [
              _buildStepNode(
                stepIndex: 0,
                number: '1',
                title: 'Paso 1',
                subtitle: 'Buscar Cliente',
                activeColor: const Color(0xFFEA580C),
              ),
              _buildStepLine(fromStep: 0, expanded: true),
              _buildStepNode(
                stepIndex: 1,
                number: '2',
                title: 'Paso 2',
                subtitle: 'Tipo e Incidencia',
                activeColor: const Color(0xFF2563EB),
              ),
              _buildStepLine(fromStep: 1, expanded: true),
              _buildStepNode(
                stepIndex: 2,
                number: '3',
                title: 'Paso 3',
                subtitle: 'Equipo y Especificaciones',
                activeColor: const Color(0xFF16A34A),
              ),
              _buildStepLine(fromStep: 2, expanded: true),
              _buildStepNode(
                stepIndex: 3,
                number: '4',
                title: 'Paso 4',
                subtitle: 'Asignar Técnico',
                activeColor: const Color(0xFF7C3AED),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepNode({
    required int stepIndex,
    required String number,
    required String title,
    required String subtitle,
    required Color activeColor,
  }) {
    final isDone = _currentStep > stepIndex;
    final isCurrent = _currentStep == stepIndex;

    Widget circleContent;
    Color circleBg;

    if (isDone) {
      circleBg = const Color(0xFF16A34A); // Green check
      circleContent = const Icon(Icons.check, color: Colors.white, size: 14);
    } else if (isCurrent) {
      circleBg = activeColor;
      circleContent = Text(
        number,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      );
    } else {
      circleBg = const Color(0xFFE2E8F0);
      circleContent = Text(
        number,
        style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 13),
      );
    }

    return InkWell(
      onTap: () {
        // Permitir retroceder a pasos ya visitados
        if (stepIndex < _currentStep) {
          setState(() => _currentStep = stepIndex);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleBg,
            ),
            child: Center(child: circleContent),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                  color: isCurrent
                      ? const Color(0xFF0F172A)
                      : (isDone ? const Color(0xFF16A34A) : const Color(0xFF94A3B8)),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isCurrent ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine({required int fromStep, bool expanded = true}) {
    final isDone = _currentStep > fromStep;
    final line = Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: isDone ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0),
    );
    if (expanded) {
      return Expanded(child: line);
    }
    return SizedBox(width: 36, child: line);
  }

  // ==================== PASO 1: BUSCAR Y ELEGIR CLIENTE (Image 3) ====================
  Widget _buildPaso1Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado
        const Row(
          children: [
            Icon(Icons.person_outline, color: Color(0xFFEA580C), size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Paso 1: Buscar y Elegir Cliente Receptor',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFEA580C),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
            children: [
              TextSpan(text: 'Busque por '),
              TextSpan(text: 'Cédula, NIT, Pasaporte o Nombre', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              TextSpan(text: '. La tabla se actualiza en tiempo real con máximo 5 resultados.'),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Barra de búsqueda y botón nuevo cliente
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchClienteCtrl,
                onChanged: _buscarClientesRealtime,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                  hintText: 'Buscar por Cédula, NIT, Pasaporte o Nombre del cliente...',
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            ElevatedButton.icon(
              onPressed: _abrirModalNuevoCliente,
              icon: const Icon(Icons.person_add_alt_1, size: 16),
              label: const Text('+ Nuevo Cliente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF334155), // Slate oscuro
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Tabla de clientes
        Text(
          'Clientes encontrados (${_clientesEncontrados.length} de máx. 5):',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _buscandoClientes
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              : _clientesEncontrados.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No se encontraron clientes registrados con ese criterio. Puede crear uno nuevo con el botón "+ Nuevo Cliente".',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: constraints.maxWidth),
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                              headingTextStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF64748B),
                                letterSpacing: 0.5,
                              ),
                              dataTextStyle: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                              columns: const [
                                DataColumn(label: Text('TIPO DOC.')),
                                DataColumn(label: Text('DOCUMENTO')),
                                DataColumn(label: Text('NOMBRE / RAZÓN SOCIAL')),
                                DataColumn(label: Text('TELÉFONO')),
                                DataColumn(label: Text('SELECCIONAR')),
                              ],
                              rows: _clientesEncontrados.map((cli) {
                                final isSelected = _clienteSeleccionado?.id == cli.id ||
                                    (_clienteSeleccionado?.numeroDocumento == cli.numeroDocumento && cli.numeroDocumento.isNotEmpty);

                                return DataRow(
                                  color: WidgetStateProperty.all(
                                    isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                                  ),
                                  cells: [
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: const Color(0xFFBFDBFE)),
                                        ),
                                        child: Text(
                                          cli.tipoDocumento.toUpperCase(),
                                          style: const TextStyle(
                                            color: Color(0xFF2563EB),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(cli.numeroDocumento, style: const TextStyle(fontWeight: FontWeight.bold))),
                                    DataCell(Text(cli.nombreCompleto)),
                                    DataCell(Text(cli.telefono)),
                                    DataCell(
                                      isSelected
                                          ? ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF16A34A),
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                elevation: 0,
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.check, size: 14),
                                                  SizedBox(width: 4),
                                                  Text('Seleccionado', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            )
                                          : ElevatedButton(
                                              onPressed: () {
                                                setState(() => _clienteSeleccionado = cli);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF2563EB),
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                elevation: 0,
                                              ),
                                              child: const Text('Elegir Cliente', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                            ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
        ),

        const SizedBox(height: 18),

        // Banner informativo
        if (_clienteSeleccionado == null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEFCE8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFEF08A)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFFB45309), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Busque y seleccione un cliente en la tabla para continuar.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF92400E)),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Cliente seleccionado: ${_clienteSeleccionado!.nombreCompleto} (${_clienteSeleccionado!.tipoDocumento}: ${_clienteSeleccionado!.numeroDocumento}) - Tel: ${_clienteSeleccionado!.telefono}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 24),

        // Botón Siguiente
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _validarYAvanzarPaso1,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Siguiente: Tipo de Incidencia', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== PASO 2: TIPO E INCIDENCIA (Image 4) ====================
  Widget _buildPaso2Content() {
    final catalogo = ref.watch(catalogoFallasProvider);
    final tiposCorrectivo = catalogo.tiposCorrectivo;
    final tiposPreventivo = catalogo.tiposPreventivo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado
        const Row(
          children: [
            Icon(Icons.build_circle_outlined, color: Color(0xFF2563EB), size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Paso 2: Tipo de Incidencia y Detalles',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Tipo de Mantenimiento *
        const Text(
          'Tipo de Mantenimiento *',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _buildSelectableCard(
                selected: _tipoServicio == 'CORRECTIVO',
                activeBorderColor: const Color(0xFFEF4444), // Rojo
                activeBgColor: const Color(0xFFFEF2F2),
                title: 'Mantenimiento Correctivo',
                titleColor: const Color(0xFFEF4444),
                subtitle: 'Reparación de fallas, averías, componentes dañados o mal funcionamiento.',
                onTap: () {
                  setState(() {
                    _tipoServicio = 'CORRECTIVO';
                    if (!tiposCorrectivo.contains(_categoriaFalla)) {
                      _categoriaFalla = tiposCorrectivo.isNotEmpty ? tiposCorrectivo.first : 'Hardware Físico';
                    }
                    _categoriaFallaCtrl.text = _categoriaFalla;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSelectableCard(
                selected: _tipoServicio == 'PREVENTIVO',
                activeBorderColor: const Color(0xFF3B82F6), // Azul
                activeBgColor: const Color(0xFFEFF6FF),
                title: 'Mantenimiento Preventivo',
                titleColor: const Color(0xFF2563EB),
                subtitle: 'Rutina programada, limpieza interna, inspección y optimización.',
                onTap: () {
                  setState(() {
                    _tipoServicio = 'PREVENTIVO';
                    if (!tiposPreventivo.contains(_categoriaFalla)) {
                      _categoriaFalla = tiposPreventivo.isNotEmpty ? tiposPreventivo.first : 'Preventivo General';
                    }
                    _categoriaFallaCtrl.text = _categoriaFalla;
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        // Categoría / Tipo de Falla Dinámica
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _tipoServicio == 'PREVENTIVO'
                  ? 'Tipo / Alcance del Servicio Preventivo *'
                  : 'Tipo / Categoría de Falla Tecnológica *',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
            ),
            TextButton.icon(
              onPressed: _dialogCrearTipoFalla,
              icon: const Icon(Icons.add_circle_outline, size: 16, color: Color(0xFF2563EB)),
              label: const Text(
                '+ Crear Nuevo Tipo de Falla',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: (_tipoServicio == 'PREVENTIVO' ? tiposPreventivo : tiposCorrectivo).contains(_categoriaFalla)
              ? _categoriaFalla
              : null,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            hintText: 'Seleccione un tipo existente o escriba uno nuevo...',
            prefixIcon: Icon(
              _tipoServicio == 'PREVENTIVO' ? Icons.cleaning_services_outlined : Icons.report_problem_outlined,
              color: _tipoServicio == 'PREVENTIVO' ? const Color(0xFF2563EB) : const Color(0xFFEF4444),
            ),
          ),
          items: [
            ...(_tipoServicio == 'PREVENTIVO' ? tiposPreventivo : tiposCorrectivo).map((tipo) {
              return DropdownMenuItem<String>(
                value: tipo,
                child: Text(tipo, style: const TextStyle(fontSize: 13)),
              );
            }),
            const DropdownMenuItem<String>(
              value: '__CREAR_NUEVO__',
              child: Row(
                children: [
                  Icon(Icons.add, color: Color(0xFF2563EB), size: 16),
                  SizedBox(width: 8),
                  Text('+ Definir / Crear otro tipo...', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB), fontSize: 13)),
                ],
              ),
            ),
          ],
          onChanged: (val) {
            if (val == '__CREAR_NUEVO__') {
              _dialogCrearTipoFalla();
            } else if (val != null) {
              setState(() {
                _categoriaFalla = val;
                _categoriaFallaCtrl.text = val;
              });
            }
          },
        ),
        const SizedBox(height: 10),
        // Campo editable directo para afinar o personalizar el tipo de falla
        TextField(
          controller: _categoriaFallaCtrl,
          decoration: InputDecoration(
            labelText: 'Detalle o Nombre Específico de la Falla',
            helperText: 'Puede editar o escribir libremente el tipo de falla detectado',
            prefixIcon: const Icon(Icons.edit_note, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
          onChanged: (val) {
            _categoriaFalla = val.trim();
          },
        ),

        const SizedBox(height: 22),

        // Título / Síntoma Reportado *
        Text(
          _tipoServicio == 'PREVENTIVO'
              ? 'Motivo / Alcance del Servicio *'
              : 'Título / Síntoma Reportado *',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _tituloCtrl,
          decoration: InputDecoration(
            hintText: _tipoServicio == 'PREVENTIVO'
                ? 'Ej. Mantenimiento preventivo semestral programado y limpieza de polvo'
                : 'Ej. Pantalla con líneas verticales y artefactos visuales, no enciende',
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),

        const SizedBox(height: 20),

        // Descripción Detallada *
        Text(
          _tipoServicio == 'PREVENTIVO'
              ? 'Descripción del Servicio Preventivo Requerido *'
              : 'Descripción Detallada de la Falla *',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descripcionCtrl,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: _tipoServicio == 'PREVENTIVO'
                ? 'Describa el trabajo preventivo requerido (limpieza de disipador, pasta térmica, optimización de software, etc.)...'
                : 'Describa el comportamiento anómalo del equipo y los síntomas observados...',
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),

        const SizedBox(height: 20),

        // Nivel de Prioridad
        const Text(
          'Nivel de Prioridad',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _prioridad,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          items: const [
            DropdownMenuItem(
              value: 'Baja - Mantenimiento preventivo o mejora no urgente',
              child: Text('Baja - Mantenimiento preventivo o mejora no urgente'),
            ),
            DropdownMenuItem(
              value: 'Media - Funcionamiento parcial / Falla no bloqueante',
              child: Text('Media - Funcionamiento parcial / Falla no bloqueante'),
            ),
            DropdownMenuItem(
              value: 'Alta - Equipo inoperativo / Bloquea trabajo crítico',
              child: Text('Alta - Equipo inoperativo / Bloquea trabajo crítico'),
            ),
            DropdownMenuItem(
              value: 'Crítica - Emergencia operativa / Afecta servicio general',
              child: Text('Crítica - Emergencia operativa / Afecta servicio general'),
            ),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _prioridad = v);
          },
        ),

        const SizedBox(height: 28),

        // Botones Anterior / Siguiente
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _currentStep = 0),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF475569), // Slate
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, size: 16),
                  SizedBox(width: 8),
                  Text('Anterior'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _validarYAvanzarPaso2,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Siguiente: Datos del Equipo', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectableCard({
    required bool selected,
    required Color activeBorderColor,
    required Color activeBgColor,
    required String title,
    Color? titleColor,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? activeBgColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? activeBorderColor : const Color(0xFFCBD5E1),
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                size: 18,
                color: selected ? activeBorderColor : const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: titleColor ?? const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== PASO 3: EQUIPO Y ESPECIFICACIONES (Image 5) ====================
  Widget _buildPaso3Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado
        const Row(
          children: [
            Icon(Icons.memory, color: Color(0xFF16A34A), size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Paso 3: Identificación del Equipo y Especificaciones',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF16A34A),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // 1. Seleccione el Tipo de Equipo:
        const Text(
          '1. Seleccione el Tipo de Equipo:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _buildDeviceTypeCard(
                icon: Icons.laptop_mac,
                title: 'Portátil / Laptop',
                subtitle: 'Dispositivo móvil con número de serie del fabricante',
                selected: _tipoEquipo == 'Portátil / Laptop',
                onTap: () {
                  setState(() {
                    _tipoEquipo = 'Portátil / Laptop';
                    _sinSerialVisible = false;
                    if (_serialCtrl.text.startsWith('MESA-') || _serialCtrl.text.startsWith('AIO-')) {
                      _serialCtrl.clear();
                    }
                    if (_marcaCtrl.text == 'Clon / Ensamblado') _marcaCtrl.clear();
                    if (_modeloCtrl.text == 'Torre ATX') _modeloCtrl.clear();
                  });
                  _buscarEquipos('');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDeviceTypeCard(
                icon: Icons.desktop_windows,
                title: 'PC de Mesa',
                subtitle: 'Torre / Ensamblado (sin marca de fabricante, código automático)',
                selected: _tipoEquipo == 'PC de Mesa',
                onTap: () {
                  setState(() {
                    _tipoEquipo = 'PC de Mesa';
                    if (_marcaCtrl.text.isEmpty) _marcaCtrl.text = 'Clon / Ensamblado';
                    if (_modeloCtrl.text.isEmpty) _modeloCtrl.text = 'Torre ATX';
                    if (_serialCtrl.text.isEmpty || _serialCtrl.text.startsWith('LAP-') || _serialCtrl.text.startsWith('AIO-')) {
                      _autogenerarSerialSegunTipo();
                    }
                  });
                  _buscarEquipos('');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDeviceTypeCard(
                icon: Icons.desktop_mac,
                title: 'All-in-One',
                subtitle: 'Todo en uno con número de serie del chasis',
                selected: _tipoEquipo == 'All-in-One',
                onTap: () {
                  setState(() {
                    _tipoEquipo = 'All-in-One';
                    _sinSerialVisible = false;
                    if (_serialCtrl.text.startsWith('MESA-') || _serialCtrl.text.startsWith('LAP-')) {
                      _serialCtrl.clear();
                    }
                    if (_marcaCtrl.text == 'Clon / Ensamblado') _marcaCtrl.clear();
                    if (_modeloCtrl.text == 'Torre ATX') _modeloCtrl.clear();
                  });
                  _buscarEquipos('');
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        // 2. Buscar en equipos registrados
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Q 2. Buscar en equipos registrados ($_tipoEquipo):',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchEquipoCtrl,
                      decoration: InputDecoration(
                        hintText: 'Escriba número de serie, modelo o marca (vacío muestra todos)...',
                        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _buscarEquipos(_searchEquipoCtrl.text),
                    icon: const Icon(Icons.search, size: 16),
                    label: const Text('Buscar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _sinSerialVisible,
                    activeColor: const Color(0xFF2563EB),
                    onChanged: (val) {
                      setState(() {
                        _sinSerialVisible = val ?? false;
                        if (_sinSerialVisible) {
                          _autogenerarSerialSegunTipo();
                        } else {
                          if (_tipoEquipo != 'PC de Mesa' &&
                              (_serialCtrl.text.startsWith('LAP-') || _serialCtrl.text.startsWith('AIO-'))) {
                            _serialCtrl.clear();
                          }
                        }
                      });
                    },
                  ),
                  const Text('Equipo sin número de serie visible', style: TextStyle(fontSize: 13, color: Color(0xFF334155))),
                ],
              ),

              const SizedBox(height: 12),

              // Alerta amarilla o tabla de resultados
              if (_buscandoEquipos)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_equiposEncontrados.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEFCE8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFEF08A)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'No se encontró ningún equipo.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF92400E)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mostrarFormularioEquipo = true;
                            _equipoSeleccionado = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB45309), // Amber oscuro
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('+ Agregar y Llenar Datos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Equipos encontrados:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 6),
                    ..._equiposEncontrados.map((eq) {
                      final isSel = _equipoSeleccionado?.id == eq.id;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFFF0FDF4) : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: isSel ? const Color(0xFF22C55E) : const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${eq.marca} ${eq.modelo} [SN: ${eq.numeroSerie}] - ${eq.sistemaOperativo}'),
                            ElevatedButton(
                              onPressed: () => _seleccionarEquipoDeTabla(eq),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSel ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              ),
                              child: Text(isSel ? '✓ Seleccionado' : 'Elegir Equipo', style: const TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Nota punteada
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
          ),
          child: const Center(
            child: Text(
              'Elija un equipo de la tabla anterior o presione el botón "+ Agregar y Llenar Datos" para ingresar sus especificaciones técnicas.',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Formulario de Especificaciones de Hardware
        if (_mostrarFormularioEquipo) ...[
          const Text(
            'Ficha Técnica y Hardware del Dispositivo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _marcaCtrl,
                  decoration: InputDecoration(
                    labelText: _tipoEquipo == 'PC de Mesa' ? 'Marca / Ensamblador (Opcional)' : 'Marca *',
                    hintText: _tipoEquipo == 'PC de Mesa' ? 'ej. Clon, Ensamblado, Asus' : 'ej. Lenovo, HP, Dell',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _modeloCtrl,
                  decoration: InputDecoration(
                    labelText: _tipoEquipo == 'PC de Mesa' ? 'Gabinete / Modelo (Opcional)' : 'Modelo *',
                    hintText: _tipoEquipo == 'PC de Mesa' ? 'ej. Torre ATX, Personalizado' : 'ej. ThinkPad, Pavilion',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _serialCtrl,
                  decoration: InputDecoration(
                    labelText: _tipoEquipo == 'PC de Mesa' ? 'Placa / Tag Interno (Automático)' : 'Número de Serie *',
                    hintText: _tipoEquipo == 'PC de Mesa'
                        ? 'ej. MESA-XXXX (Código interno taller)'
                        : (_tipoEquipo == 'Portátil / Laptop' ? 'ej. LAP-XXXX o Serial Fabricante' : 'ej. AIO-XXXX o Serial'),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      tooltip: 'Generar código ${_obtenerPrefijoSegunTipo()}-XXXX',
                      onPressed: _autogenerarSerialSegunTipo,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _soCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Sistema Operativo',
                    hintText: 'ej. Windows 11 Pro 64-bit, Ubuntu, macOS',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _cpuCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Procesador (CPU)',
                    hintText: 'ej. Intel Core i5, AMD Ryzen 5',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ramCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Memoria RAM',
                    hintText: 'ej. 8 GB DDR4, 16 GB DDR5',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _discoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Almacenamiento (Disco)',
                    hintText: 'ej. SSD 512GB NVMe, HDD 1TB',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _gpuCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tarjeta Gráfica (GPU)',
                    hintText: 'ej. Intel Iris Xe, NVIDIA RTX, Integrada',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 24),

        // Evidencia Fotográfica de Ingreso (Opcional) (Image 5)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.photo_camera_outlined, color: Color(0xFF2563EB), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Evidencia Fotográfica de Ingreso (Opcional)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Recepción física', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Puede adjuntar una foto del estado estético o visual del equipo al momento de su entrega en el taller. No es obligatoria.',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 12),
              if (_fotoBase64 != null)
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(_fotoBase64!),
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Foto adjunta correctamente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF16A34A))),
                        const SizedBox(height: 6),
                        OutlinedButton.icon(
                          onPressed: () => setState(() => _fotoBase64 = null),
                          icon: const Icon(Icons.delete, size: 14, color: Colors.red),
                          label: const Text('Eliminar Foto', style: TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                )
              else
                OutlinedButton.icon(
                  onPressed: _tomarFoto,
                  icon: const Icon(Icons.add_a_photo, size: 16),
                  label: const Text('Adjuntar Foto de Evidencia'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // Botones Anterior / Siguiente
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _currentStep = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF475569),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, size: 16),
                  SizedBox(width: 8),
                  Text('Anterior'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _validarYAvanzarPaso3,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Siguiente: Asignar Técnico', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeviceTypeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 84, // Altura uniforme idéntica para todas las tarjetas
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? const Color(0xFF22C55E) : const Color(0xFFCBD5E1),
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: selected ? const Color(0xFF16A34A) : const Color(0xFF64748B)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: selected ? const Color(0xFF15803D) : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== PASO 4: ASIGNAR TÉCNICO (Solicitado por el usuario) ====================
  Widget _buildPaso4Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado
        const Row(
          children: [
            Icon(Icons.engineering_outlined, color: Color(0xFF7C3AED), size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Paso 4: Asignar Técnico y Confirmación',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF7C3AED),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Seleccione el técnico de laboratorio que se encargará del diagnóstico y servicio, o déjela en asignación general.',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 18),

        // Barra de búsqueda de técnicos
        TextField(
          controller: _searchTecnicoCtrl,
          onChanged: _filtrarTecnicos,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
            hintText: 'Buscar técnico por nombre, cédula o correo...',
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),

        const SizedBox(height: 14),

        // Tabla de Técnicos
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _cargandoTecnicos
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              : _tecnicosFiltrados.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No hay técnicos disponibles o no se encontraron con ese filtro.',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: constraints.maxWidth),
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                              headingTextStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF64748B),
                                letterSpacing: 0.5,
                              ),
                              columns: const [
                                DataColumn(label: Text('TÉCNICO')),
                                DataColumn(label: Text('DOCUMENTO')),
                                DataColumn(label: Text('TELÉFONO')),
                                DataColumn(label: Text('ESTADO')),
                                DataColumn(label: Text('ACCIÓN')),
                              ],
                              rows: _tecnicosFiltrados.map((tec) {
                                final isSelected = _tecnicoSeleccionado?.id == tec.id;
                                return DataRow(
                                  color: WidgetStateProperty.all(
                                    isSelected ? const Color(0xFFF5F3FF) : Colors.white,
                                  ),
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundColor: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                                            child: Text(
                                              tec.nombre.isNotEmpty ? tec.nombre[0].toUpperCase() : 'T',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF7C3AED)),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(tec.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                              Text(tec.email, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(Text(tec.documento)),
                                    DataCell(Text(tec.telefono)),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0FDF4),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: const Color(0xFFBBF7D0)),
                                        ),
                                        child: const Text('Disponible', style: TextStyle(color: Color(0xFF15803D), fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    DataCell(
                                      isSelected
                                          ? ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF16A34A),
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.check, size: 14),
                                                  SizedBox(width: 4),
                                                  Text('Asignado', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            )
                                          : ElevatedButton(
                                              onPressed: () {
                                                setState(() => _tecnicoSeleccionado = tec);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF7C3AED),
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                              ),
                                              child: const Text('Asignar', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                            ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
        ),

        const SizedBox(height: 12),

        // Opción bolsa general
        OutlinedButton.icon(
          onPressed: () {
            setState(() => _tecnicoSeleccionado = null);
          },
          icon: Icon(
            _tecnicoSeleccionado == null ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: _tecnicoSeleccionado == null ? const Color(0xFFD97706) : const Color(0xFF64748B),
          ),
          label: const Text('Dejar sin asignar directamente (Bolsa General del Taller)'),
          style: OutlinedButton.styleFrom(
            foregroundColor: _tecnicoSeleccionado == null ? const Color(0xFF92400E) : const Color(0xFF475569),
            backgroundColor: _tecnicoSeleccionado == null ? const Color(0xFFFEFCE8) : Colors.transparent,
          ),
        ),

        const SizedBox(height: 22),

        // Tarjeta Resumen de la Orden
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.receipt_long, color: Color(0xFF0F172A), size: 20),
                  SizedBox(width: 8),
                  Text('Resumen de la Orden de Mantenimiento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              const Divider(height: 20),
              _buildResumenItem('Cliente Receptor:', '${_clienteSeleccionado?.nombreCompleto} (${_clienteSeleccionado?.tipoDocumento}: ${_clienteSeleccionado?.numeroDocumento})'),
              _buildResumenItem('Contacto:', 'Tel: ${_clienteSeleccionado?.telefono} | Email: ${_clienteSeleccionado?.email ?? "N/A"}'),
              _buildResumenItem('Tipo de Servicio:', '$_tipoServicio - $_categoriaFalla ($_prioridad)'),
              _buildResumenItem(_tipoServicio == 'PREVENTIVO' ? 'Motivo / Alcance:' : 'Síntoma / Falla:', _tituloCtrl.text),
              _buildResumenItem('Equipo y Hardware:', '$_tipoEquipo - ${_marcaCtrl.text} ${_modeloCtrl.text} [SN: ${_serialCtrl.text}]'),
              _buildResumenItem('Especificaciones:', '${_cpuCtrl.text} | ${_ramCtrl.text} | ${_discoCtrl.text} | ${_soCtrl.text}'),
              _buildResumenItem(
                'Técnico Asignado:',
                _tecnicoSeleccionado != null ? '${_tecnicoSeleccionado!.nombre} (${_tecnicoSeleccionado!.email})' : 'Bolsa General (Pendiente de Asignación)',
                isHighlight: true,
              ),
              if (_fotoBase64 != null) _buildResumenItem('Evidencia Fotográfica:', '1 Fotografía capturada para recepción estética'),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // Botones Anterior / Radicar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _currentStep = 2),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF475569),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, size: 16),
                  SizedBox(width: 8),
                  Text('Anterior'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _finalizarYRadicarOrden,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A), // Verde radicar
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline, size: 18),
                  SizedBox(width: 8),
                  Text('Radicar Incidencia / Crear Orden de Servicio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResumenItem(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF475569)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
                color: isHighlight ? const Color(0xFF15803D) : const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
