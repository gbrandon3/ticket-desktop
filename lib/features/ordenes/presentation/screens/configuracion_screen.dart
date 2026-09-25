import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../domain/entities/empresa_config.dart';
import '../providers/ordenes_providers.dart';

class ConfiguracionScreen extends ConsumerStatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  ConsumerState<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends ConsumerState<ConfiguracionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _sloganController = TextEditingController();
  final _nitController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _direccionController = TextEditingController();
  final _ciudadController = TextEditingController();

  String? _logoBase64;
  bool _loading = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarConfiguracion();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _sloganController.dispose();
    _nitController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    super.dispose();
  }

  Future<void> _cargarConfiguracion() async {
    setState(() => _loading = true);
    final repo = ref.read(ordenesRepositoryProvider);
    final config = await repo.getEmpresaConfig();

    _nombreController.text = config.nombreEmpresa;
    _sloganController.text = config.slogan;
    _nitController.text = config.nit;
    _telefonoController.text = config.telefono;
    _emailController.text = config.email;
    _direccionController.text = config.direccion;
    _ciudadController.text = config.ciudad;
    _logoBase64 = config.logoBase64;

    setState(() => _loading = false);
  }

  Future<void> _seleccionarLogo() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _logoBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error seleccionando logo: $e')),
        );
      }
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final nuevaConfig = EmpresaConfig(
      nombreEmpresa: _nombreController.text.trim(),
      slogan: _sloganController.text.trim(),
      nit: _nitController.text.trim(),
      telefono: _telefonoController.text.trim(),
      email: _emailController.text.trim(),
      direccion: _direccionController.text.trim(),
      ciudad: _ciudadController.text.trim(),
      logoBase64: _logoBase64,
    );

    final repo = ref.read(ordenesRepositoryProvider);
    await repo.saveEmpresaConfig(nuevaConfig);

    setState(() => _guardando = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuración del taller guardada exitosamente.'),
          backgroundColor: SantiConstants.successGreen,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración del Taller / Empresa'),
        backgroundColor: SantiConstants.primaryNavy,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encabezado descriptivo
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.business, color: SantiConstants.primaryBlue, size: 28),
                              SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Personalización Multi-Empresa',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: SantiConstants.primaryNavy),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Personalice el nombre de su empresa, NIT, contacto y membrete. Toda la aplicación y los PDFs generados reflejarán estos datos.',
                                      style: TextStyle(fontSize: 12, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Formulario
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _nombreController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre de la Empresa o Taller *',
                                  hintText: 'ej. TechPro Soluciones Informáticas',
                                ),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _nitController,
                                decoration: const InputDecoration(
                                  labelText: 'NIT / RUT / ID Fiscal *',
                                  hintText: 'ej. 900.123.456-7',
                                ),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _sloganController,
                          decoration: const InputDecoration(
                            labelText: 'Lema o Slogan Institucional',
                            hintText: 'ej. Tu soporte técnico de confianza',
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _telefonoController,
                                decoration: const InputDecoration(
                                  labelText: 'Teléfono / WhatsApp de Contacto *',
                                  hintText: 'ej. +57 310 123 4567',
                                ),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Correo Electrónico de Soporte *',
                                  hintText: 'ej. contacto@taller.com',
                                ),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _direccionController,
                                decoration: const InputDecoration(
                                  labelText: 'Dirección Física del Local / Mesón de Trabajo *',
                                  hintText: 'ej. Carrera 15 # 45-20, Local 3',
                                ),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _ciudadController,
                                decoration: const InputDecoration(
                                  labelText: 'Ciudad y País *',
                                  hintText: 'ej. Bogotá, Colombia',
                                ),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Sección de Logotipo
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: _logoBase64 != null
                                    ? Image.memory(
                                        base64Decode(_logoBase64!),
                                        fit: BoxFit.contain,
                                      )
                                    : const Icon(Icons.business, color: Colors.grey, size: 36),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Logotipo del Taller', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    const Text('Se incluirá en el encabezado de las actas y documentos oficiales emitidos.', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                                            child: const Text('Quitar', style: TextStyle(color: Colors.red)),
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
                        const SizedBox(height: 32),

                        // Botón de Guardado
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _guardando ? null : _guardar,
                            icon: const Icon(Icons.save),
                            label: Text(_guardando ? 'Guardando...' : 'Guardar Configuración del Taller'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SantiConstants.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
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
