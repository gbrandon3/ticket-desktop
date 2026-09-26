import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../domain/entities/empresa_config.dart';
import '../../domain/entities/usuario.dart';
import '../providers/auth_provider.dart';
import '../providers/ordenes_providers.dart';

class SetupWizardScreen extends ConsumerStatefulWidget {
  const SetupWizardScreen({super.key});

  @override
  ConsumerState<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends ConsumerState<SetupWizardScreen> {
  int _currentStep = 0;
  final _formKeyPaso1 = GlobalKey<FormState>();
  final _formKeyPaso2 = GlobalKey<FormState>();
  final _formKeyPaso3 = GlobalKey<FormState>();

  // Paso 1: Empresa
  final _nombreEmpresaCtrl = TextEditingController();
  final _nitCtrl = TextEditingController();
  final _telefonoEmpresaCtrl = TextEditingController();
  final _emailEmpresaCtrl = TextEditingController();
  final _direccionEmpresaCtrl = TextEditingController();
  final _ciudadCtrl = TextEditingController();
  final String _colorPdfSeleccionado = '#1E3A8A';

  // Paso 2: Administrador Principal
  final _adminNombreCtrl = TextEditingController();
  final _adminDocCtrl = TextEditingController();
  final _adminEmailCtrl = TextEditingController();
  final _adminPassCtrl = TextEditingController();
  final _adminTelCtrl = TextEditingController();
  bool _obscurePass = true;

  // Paso 3: Personal Inicial (Opcionales)
  final _opNombreCtrl = TextEditingController();
  final _opEmailCtrl = TextEditingController();
  final _opPassCtrl = TextEditingController();
  final _opDocCtrl = TextEditingController();
  final _opTelCtrl = TextEditingController();

  final _tecNombreCtrl = TextEditingController();
  final _tecEmailCtrl = TextEditingController();
  final _tecPassCtrl = TextEditingController();
  final _tecDocCtrl = TextEditingController();
  final _tecTelCtrl = TextEditingController();

  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verificarSiYaEstaConfigurado();
    });
  }

  Future<void> _verificarSiYaEstaConfigurado() async {
    try {
      final repo = ref.read(ordenesRepositoryProvider);
      final yaListo = await repo.isSetupCompleted();
      if (yaListo && mounted) {
        context.go('/login');
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _nombreEmpresaCtrl.dispose();
    _nitCtrl.dispose();
    _telefonoEmpresaCtrl.dispose();
    _emailEmpresaCtrl.dispose();
    _direccionEmpresaCtrl.dispose();
    _ciudadCtrl.dispose();
    _adminNombreCtrl.dispose();
    _adminDocCtrl.dispose();
    _adminEmailCtrl.dispose();
    _adminPassCtrl.dispose();
    _adminTelCtrl.dispose();
    _opNombreCtrl.dispose();
    _opEmailCtrl.dispose();
    _opPassCtrl.dispose();
    _opDocCtrl.dispose();
    _opTelCtrl.dispose();
    _tecNombreCtrl.dispose();
    _tecEmailCtrl.dispose();
    _tecPassCtrl.dispose();
    _tecDocCtrl.dispose();
    _tecTelCtrl.dispose();
    super.dispose();
  }

  Future<void> _finalizarSetup() async {
    setState(() => _guardando = true);

    try {
      final empresa = EmpresaConfig(
        nombreEmpresa: _nombreEmpresaCtrl.text.trim(),
        slogan: '',
        nit: _nitCtrl.text.trim(),
        telefono: _telefonoEmpresaCtrl.text.trim(),
        email: _emailEmpresaCtrl.text.trim(),
        direccion: _direccionEmpresaCtrl.text.trim(),
        ciudad: _ciudadCtrl.text.trim(),
        colorPrimario: _colorPdfSeleccionado,
        isSetupCompleted: true,
      );

      final admin = Usuario(
        nombre: _adminNombreCtrl.text.trim(),
        email: _adminEmailCtrl.text.trim().toLowerCase(),
        password: _adminPassCtrl.text.trim(),
        documento: _adminDocCtrl.text.trim(),
        telefono: _adminTelCtrl.text.trim(),
        rol: 'admin',
      );

      Usuario? operador;
      if (_opNombreCtrl.text.trim().isNotEmpty && _opEmailCtrl.text.trim().isNotEmpty) {
        operador = Usuario(
          nombre: _opNombreCtrl.text.trim(),
          email: _opEmailCtrl.text.trim().toLowerCase(),
          password: _opPassCtrl.text.trim().isEmpty ? '123456' : _opPassCtrl.text.trim(),
          documento: _opDocCtrl.text.trim().isEmpty ? '0' : _opDocCtrl.text.trim(),
          telefono: _opTelCtrl.text.trim().isEmpty ? '0' : _opTelCtrl.text.trim(),
          rol: 'operador',
        );
      }

      Usuario? tecnico;
      if (_tecNombreCtrl.text.trim().isNotEmpty && _tecEmailCtrl.text.trim().isNotEmpty) {
        tecnico = Usuario(
          nombre: _tecNombreCtrl.text.trim(),
          email: _tecEmailCtrl.text.trim().toLowerCase(),
          password: _tecPassCtrl.text.trim().isEmpty ? '123456' : _tecPassCtrl.text.trim(),
          documento: _tecDocCtrl.text.trim().isEmpty ? '0' : _tecDocCtrl.text.trim(),
          telefono: _tecTelCtrl.text.trim().isEmpty ? '0' : _tecTelCtrl.text.trim(),
          rol: 'tecnico',
        );
      }

      final repo = ref.read(ordenesRepositoryProvider);
      await repo.completeSetup(
        empresa: empresa,
        admin: admin,
        operador: operador,
        tecnico: tecnico,
      );

      // Iniciar sesión automáticamente con el admin creado
      final adminLogueado = await repo.login(admin.email, admin.password);
      if (adminLogueado != null) {
        ref.read(authProvider.notifier).login(adminLogueado);
      }
      ref.invalidate(setupCompletedProvider);

      if (mounted) {
        setState(() => _guardando = false);
        context.go('/dashboard');
      }
    } catch (e) {
      setState(() => _guardando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error completando configuración: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _onSiguiente() {
    if (_currentStep == 0) {
      if (_formKeyPaso1.currentState!.validate()) {
        setState(() => _currentStep = 1);
      }
    } else if (_currentStep == 1) {
      if (_formKeyPaso2.currentState!.validate()) {
        setState(() => _currentStep = 2);
      }
    } else if (_currentStep == 2) {
      _finalizarSetup();
    }
  }

  void _onAtras() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 850),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Cabecera institucional
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    decoration: const BoxDecoration(
                      color: SantiConstants.primaryNavy,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.auto_fix_high, color: Colors.cyanAccent, size: 32),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Asistente de Configuración Inicial',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Bienvenido. Configure los datos iniciales de su empresa y la cuenta de administrador principal.',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Barra de progreso y pasos
                  _buildStepBar(),

                  // Contenido según el paso activo
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: _guardando
                        ? const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Guardando configuración e inicializando sistema...'),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_currentStep == 0) _buildPaso1(),
                              if (_currentStep == 1) _buildPaso2(),
                              if (_currentStep == 2) _buildPaso3(),
                              const SizedBox(height: 32),
                              // Botones de acción
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: _onSiguiente,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: SantiConstants.primaryBlue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                    ),
                                    child: Text(_currentStep == 2 ? 'Finalizar e Ingresar' : 'Continuar al Siguiente Paso'),
                                  ),
                                  if (_currentStep > 0) ...[
                                    const SizedBox(width: 12),
                                    OutlinedButton(
                                      onPressed: _onAtras,
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                      ),
                                      child: const Text('Atrás'),
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
          ),
        ),
      ),
    );
  }

  Widget _buildStepBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          _buildStepItem(0, '1. Empresa & Taller', Icons.business),
          _buildStepDivider(0),
          _buildStepItem(1, '2. Administrador', Icons.admin_panel_settings),
          _buildStepDivider(1),
          _buildStepItem(2, '3. Personal Opcional', Icons.people_alt),
        ],
      ),
    );
  }

  Widget _buildStepItem(int stepIndex, String title, IconData icon) {
    final isCurrent = _currentStep == stepIndex;
    final isDone = _currentStep > stepIndex;

    Color color;
    Color bgColor;

    if (isDone) {
      color = Colors.white;
      bgColor = SantiConstants.successGreen;
    } else if (isCurrent) {
      color = Colors.white;
      bgColor = SantiConstants.primaryBlue;
    } else {
      color = Colors.grey.shade600;
      bgColor = Colors.grey.shade200;
    }

    return Expanded(
      child: InkWell(
        onTap: () {
          if (stepIndex < _currentStep) {
            setState(() => _currentStep = stepIndex);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: bgColor,
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Icon(icon, size: 14, color: color),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  color: isCurrent ? SantiConstants.primaryNavy : Colors.grey.shade700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepDivider(int afterStep) {
    final isDone = _currentStep > afterStep;
    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isDone ? SantiConstants.successGreen : Colors.grey.shade300,
    );
  }

  // ==================== PASO 1: EMPRESA ====================
  Widget _buildPaso1() {
    return Form(
      key: _formKeyPaso1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Paso 1: Datos de la Empresa o Taller', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: SantiConstants.primaryNavy)),
          const SizedBox(height: 6),
          const Text('Configure la razón social y membrete oficial que aparecerá en actas y en la plataforma.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nombreEmpresaCtrl,
            decoration: const InputDecoration(labelText: 'Nombre de la Empresa o Proyecto *', hintText: 'ej. TechPro Soluciones Informáticas'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nitCtrl,
                  decoration: const InputDecoration(labelText: 'NIT / RUT / ID Fiscal *', hintText: 'ej. 900.123.456-7'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _telefonoEmpresaCtrl,
                  decoration: const InputDecoration(labelText: 'Teléfono Móvil o WhatsApp *', hintText: 'ej. +57 310 123 4567'),
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
                  controller: _emailEmpresaCtrl,
                  decoration: const InputDecoration(labelText: 'Correo Electrónico de Soporte *', hintText: 'ej. soporte@empresa.com'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _ciudadCtrl,
                  decoration: const InputDecoration(labelText: 'Ciudad y País *', hintText: 'ej. Bogotá, Colombia'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _direccionEmpresaCtrl,
            decoration: const InputDecoration(labelText: 'Dirección Física del Taller *', hintText: 'ej. Cra 15 # 45-20 Local 101'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
          ),
        ],
      ),
    );
  }

  // ==================== PASO 2: ADMINISTRADOR ====================
  Widget _buildPaso2() {
    return Form(
      key: _formKeyPaso2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Paso 2: Cuenta del Administrador Principal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: SantiConstants.primaryNavy)),
          const SizedBox(height: 6),
          const Text('Este usuario tendrá permisos globales de supervisión y gestión del sistema.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 20),
          TextFormField(
            controller: _adminNombreCtrl,
            decoration: const InputDecoration(labelText: 'Nombre Completo del Administrador *'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _adminDocCtrl,
                  decoration: const InputDecoration(labelText: 'Cédula / Documento de Identidad *'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _adminTelCtrl,
                  decoration: const InputDecoration(labelText: 'Teléfono Móvil *'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _adminEmailCtrl,
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico de Acceso *',
            ),
            validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _adminPassCtrl,
            obscureText: _obscurePass,
            decoration: InputDecoration(
              labelText: 'Contraseña de Acceso *',
              suffixIcon: IconButton(
                icon: Icon(_obscurePass ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePass = !_obscurePass),
              ),
            ),
            validator: (v) => v == null || v.length < 4 ? 'Mínimo 4 caracteres' : null,
          ),
        ],
      ),
    );
  }

  // ==================== PASO 3: PERSONAL INICIAL ====================
  Widget _buildPaso3() {
    return Form(
      key: _formKeyPaso3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Paso 3: Personal Inicial Opcional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: SantiConstants.primaryNavy)),
          const SizedBox(height: 6),
          const Text(
            'Puede registrar de inmediato al primer Operador de Mesa y Técnico de Taller, o pulsar "Finalizar e Ingresar" para agregarlos después en Configuración.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Operador
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.headset_mic, color: SantiConstants.primaryBlue, size: 20),
                    SizedBox(width: 8),
                    Text('Primer Operador o Mesa de Ayuda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _opNombreCtrl, decoration: const InputDecoration(labelText: 'Nombre Completo'))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _opEmailCtrl, decoration: const InputDecoration(labelText: 'Correo Electrónico'))),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _opPassCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña inicial: 123456'))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _opTelCtrl, decoration: const InputDecoration(labelText: 'Teléfono Móvil'))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Técnico
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.build, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text('Primer Técnico Especialista', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _tecNombreCtrl, decoration: const InputDecoration(labelText: 'Nombre Completo'))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _tecEmailCtrl, decoration: const InputDecoration(labelText: 'Correo Electrónico'))),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _tecPassCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña inicial: 123456'))),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _tecTelCtrl, decoration: const InputDecoration(labelText: 'Teléfono Móvil'))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
