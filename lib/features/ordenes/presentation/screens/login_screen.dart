import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../domain/entities/empresa_config.dart';
import '../providers/auth_provider.dart';
import '../providers/ordenes_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _cargando = false;
  String? _errorMsg;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      setState(() => _errorMsg = 'Por favor ingrese correo electrónico y contraseña.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingrese correo electrónico y contraseña.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _cargando = true;
      _errorMsg = null;
    });

    try {
      final repo = ref.read(ordenesRepositoryProvider);
      final user = await repo.login(email, pass);

      if (!mounted) return;
      setState(() => _cargando = false);

      if (user != null) {
        ref.read(authProvider.notifier).login(user);
      } else {
        setState(() {
          _errorMsg = 'Credenciales no válidas. Verifique su correo y contraseña o use las cuentas de prueba.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Credenciales no válidas o usuario no encontrado.'),
            backgroundColor: Color(0xFFDC2626),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _errorMsg = 'Error al procesar inicio de sesión: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de autenticación: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  Future<void> _mostrarRecuperacion() async {
    final emailCtrl = TextEditingController(text: _emailCtrl.text.trim());
    final codeCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var processing = false;
    var obscure = true;
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Restablecer contraseña'),
            content: SizedBox(
              width: 440,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Esta opción funciona sin correo SMTP. En el equipo donde corre el servidor, obtenga la clave con:',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                        child: const SelectableText('npm run recovery-code', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Correo de la cuenta', prefixIcon: Icon(Icons.email_outlined)),
                        validator: (value) => value == null || !value.contains('@') ? 'Ingrese un correo válido' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: codeCtrl,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(labelText: 'Clave de recuperación', prefixIcon: Icon(Icons.key_outlined)),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Ingrese la clave del servidor' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: passCtrl,
                        obscureText: obscure,
                        decoration: InputDecoration(
                          labelText: 'Contraseña nueva',
                          prefixIcon: const Icon(Icons.lock_reset),
                          suffixIcon: IconButton(
                            onPressed: () => setDialogState(() => obscure = !obscure),
                            icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                        validator: (value) => (value?.length ?? 0) < 8 ? 'Use al menos 8 caracteres' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: confirmCtrl,
                        obscureText: obscure,
                        decoration: const InputDecoration(labelText: 'Confirmar contraseña nueva', prefixIcon: Icon(Icons.lock_outline)),
                        validator: (value) => value != passCtrl.text ? 'Las contraseñas no coinciden' : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: processing ? null : () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: processing ? null : () async {
                  if (formKey.currentState?.validate() != true) return;
                  setDialogState(() => processing = true);
                  try {
                    await ref.read(ordenesRepositoryProvider).recoverPassword(emailCtrl.text, codeCtrl.text, passCtrl.text);
                    if (!dialogContext.mounted) return;
                    Navigator.pop(dialogContext);
                    _emailCtrl.text = emailCtrl.text.trim();
                    _passCtrl.clear();
                    ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
                      content: Text('Contraseña restablecida. Inicie sesión con la contraseña nueva.'),
                      backgroundColor: Color(0xFF16A34A),
                    ));
                  } catch (error) {
                    if (!dialogContext.mounted) return;
                    setDialogState(() => processing = false);
                    ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(
                      content: Text(error.toString().replaceFirst('Exception: ', '')),
                      backgroundColor: const Color(0xFFDC2626),
                    ));
                  }
                },
                child: processing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Restablecer'),
              ),
            ],
          ),
        ),
      );
    } finally {
      emailCtrl.dispose();
      codeCtrl.dispose();
      passCtrl.dispose();
      confirmCtrl.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final empresaAsync = ref.watch(empresaConfigStreamProvider);
    final empresa = empresaAsync.asData?.value ?? const EmpresaConfig.defaultConfig();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 460),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Encabezado
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 24),
                    decoration: const BoxDecoration(
                      color: SantiConstants.primaryNavy,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: SantiConstants.primaryBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.security, color: Colors.white, size: 34),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          empresa.nombreEmpresa,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Portal de Autenticación & Control de Soporte',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // Formulario
                  Padding(
                    padding: const EdgeInsets.all(26.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_errorMsg != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFFCA5A5)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMsg!,
                                    style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],

                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Correo Electrónico',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          onFieldSubmitted: (_) => _iniciarSesion(),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscurePass,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePass ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _obscurePass = !_obscurePass),
                            ),
                          ),
                          onFieldSubmitted: (_) => _iniciarSesion(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _cargando ? null : _mostrarRecuperacion,
                            child: const Text('¿Olvidaste tu contraseña?'),
                          ),
                        ),
                        const SizedBox(height: 8),

                        ElevatedButton(
                          onPressed: _cargando ? null : _iniciarSesion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SantiConstants.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _cargando
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Iniciar Sesión', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 14),

                        // Enlace a Consulta Pública
                        InkWell(
                          onTap: () {
                            context.go('/consulta');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  '¿Deseas consultar el estado de tu equipo sin iniciar sesión?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF1E3A8A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Haz clic aquí para Consulta Pública',
                                        style: TextStyle(fontSize: 12, color: Color(0xFF0284C7)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward, size: 14, color: Color(0xFF0284C7)),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
}
