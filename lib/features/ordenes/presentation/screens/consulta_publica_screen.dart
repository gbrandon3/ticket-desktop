import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/entities/equipo.dart';
import '../../domain/entities/formato_acta_entrega.dart';
import '../../domain/entities/formato_actividades.dart';
import '../../domain/entities/formato_ot.dart';
import '../../domain/entities/foto_evidencia.dart';
import '../../domain/entities/orden.dart';
import '../../domain/entities/repuesto.dart';
import '../providers/ordenes_providers.dart';
import 'login_screen.dart';

class ConsultaPublicaScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const ConsultaPublicaScreen({super.key, this.initialQuery});

  @override
  ConsumerState<ConsultaPublicaScreen> createState() => _ConsultaPublicaScreenState();
}

class _ConsultaPublicaScreenState extends ConsumerState<ConsultaPublicaScreen> {
  final _searchCtrl = TextEditingController();
  bool _buscando = false;
  String? _errorMsg;
  Map<String, dynamic>? _resultado;
  String? _fotoAmpliadaBase64;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.trim().isNotEmpty) {
      _searchCtrl.text = widget.initialQuery!.trim();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _ejecutarConsulta(widget.initialQuery!.trim());
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _ejecutarConsulta([String? overrideQuery]) async {
    final query = (overrideQuery ?? _searchCtrl.text).trim();
    if (query.length < 2) {
      setState(() => _errorMsg = 'Por favor ingrese al menos 2 caracteres para realizar la búsqueda.');
      return;
    }

    setState(() {
      _buscando = true;
      _errorMsg = null;
      _resultado = null;
    });

    final repo = ref.read(ordenesRepositoryProvider);
    final res = await repo.consultarPublico(query);

    setState(() {
      _buscando = false;
      if (res['tipo'] == 'no_encontrado') {
        _errorMsg = 'No se encontraron resultados para la consulta ingresada.';
        _resultado = null;
      } else {
        _resultado = res;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Slate 100
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ==================== BARRA SUPERIOR ====================
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.build, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 450),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Portal de Consulta y Trazabilidad',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Seguimiento público de mantenimientos y especificaciones de equipos',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.go('/login');
                        },
                        icon: const Icon(Icons.arrow_back, size: 16),
                        label: const Text('Iniciar Sesión (Personal)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF334155),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ==================== TARJETA DE BÚSQUEDA ====================
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Consultar Estado o Hoja de Vida de Equipo',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ingrese el número de serie de su equipo, el código de ticket o su número de identificación (cédula o NIT).',
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 18),

                        // Formulario de Búsqueda
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchCtrl,
                                decoration: InputDecoration(
                                  hintText: 'Ej: TCK-2026-7311, HP-ELITE-840-001 o 1098765432',
                                  prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
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
                                    borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                onSubmitted: (_) => _ejecutarConsulta(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _buscando ? null : () => _ejecutarConsulta(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: _buscando
                                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Text('Consultar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Búsquedas admitidas pills
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text('Búsquedas admitidas:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            _buildPill('NÚMERO DE SERIE (SPECS + HISTORIAL COMPLETO)', const Color(0xFFE0E7FF), const Color(0xFF3730A3)),
                            _buildPill('CÓDIGO DE TICKET (TRAZABILIDAD Y FOTOS)', const Color(0xFFFEF3C7), const Color(0xFF92400E)),
                            _buildPill('CÉDULA O NIT (LISTADO DE ÓRDENES)', const Color(0xFFDCFCE7), const Color(0xFF166534)),
                          ],
                        ),

                        // Mensaje de Error
                        if (_errorMsg != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              border: Border.all(color: const Color(0xFFFECACA)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                                const SizedBox(width: 10),
                                Expanded(child: Text(_errorMsg!, style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13))),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ==================== RESULTADO ====================
                  if (_resultado != null) ...[
                    if (_resultado!['tipo'] == 'ticket' || _resultado!['tipo'] == 'orden')
                      _buildTicketResultCard(
                        orden: _resultado!['orden'] as Orden,
                        fotos: (_resultado!['fotos'] as List?)?.cast<FotoEvidencia>() ?? [],
                        formatoOt: _resultado!['formatoOt'] as FormatoOt?,
                        formatoActividades: _resultado!['formatoActividades'] as FormatoActividades?,
                        actaEntrega: _resultado!['actaEntrega'] as FormatoActaEntrega?,
                        repuestos: (_resultado!['repuestos'] as List?)?.cast<Repuesto>() ?? const [],
                      ),
                    if (_resultado!['tipo'] == 'equipo')
                      _buildEquipoResultCard(
                        _resultado!['equipo'] as Equipo,
                        (_resultado!['historial'] as List?)?.cast<Orden>() ?? [],
                      ),
                    if (_resultado!['tipo'] == 'cliente')
                      _buildClienteResultCard(
                        _resultado!['cliente'] as Cliente,
                        (_resultado!['ordenes'] as List?)?.cast<Orden>() ?? [],
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPill(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ==================== RESULT CARD: TICKET (TRAZABILIDAD INTEGRAL) ====================
  Widget _buildTicketResultCard({
    required Orden orden,
    required List<FotoEvidencia> fotos,
    FormatoOt? formatoOt,
    FormatoActividades? formatoActividades,
    FormatoActaEntrega? actaEntrega,
    List<Repuesto> repuestos = const [],
  }) {
    final dateFormat = DateFormat('dd/MM/yyyy, HH:mm:ss');
    final fechaAperturaStr = dateFormat.format(orden.fechaIngreso);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Card Principal del Ticket con acento azul superior
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Borde azul superior
              Container(
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título y Badges + Botón Ver Hoja de Vida
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Text(
                              'Ticket #${orden.codigoOrden}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            _buildPill(orden.tipoServicio.toUpperCase(), const Color(0xFFFEF3C7), const Color(0xFFD97706)),
                            _buildPill(
                              orden.estado == 'ENTREGADO_CERRADO' ? 'FINALIZADO' : 'EN PROCESO',
                              orden.estado == 'ENTREGADO_CERRADO' ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                              orden.estado == 'ENTREGADO_CERRADO' ? const Color(0xFF166534) : const Color(0xFFB45309),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (orden.equipo?.numeroSerie != null) {
                              _searchCtrl.text = orden.equipo!.numeroSerie;
                              _ejecutarConsulta(orden.equipo!.numeroSerie);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF475569),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            elevation: 0,
                          ),
                          child: const Text('Ver Hoja de Vida Completa del Equipo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Fechas y estado textual
                    Row(
                      children: [
                        Text('Fecha de Apertura: ', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        Text(fechaAperturaStr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                        const SizedBox(width: 16),
                        Text(
                          orden.fechaCierre != null
                              ? 'Fecha de Cierre: ${dateFormat.format(orden.fechaCierre!)}'
                              : 'Estado: En proceso de atención',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: orden.fechaCierre != null ? const Color(0xFF166534) : const Color(0xFFD97706),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Caja gris con 4 columnas (Equipo, Serial, Ubicación, Técnico)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: _buildInfoCol('Equipo', orden.equipo != null ? '${orden.equipo!.marca} ${orden.equipo!.modelo}' : 'No especificado')),
                          Expanded(child: _buildInfoCol('Número de Serie', orden.equipo?.numeroSerie ?? 'Sin serial')),
                          Expanded(child: _buildInfoCol('Ubicación', orden.cliente?.direccion.isNotEmpty == true ? orden.cliente!.direccion : 'Taller Central')),
                          Expanded(child: _buildInfoCol('Técnico Responsable', orden.tecnico?.nombre ?? 'Sin asignar aún')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Falla / Trabajo Solicitado
                    Text(
                      'Falla / Motivo de Ingreso: ${orden.titulo}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      orden.descripcion,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 2. Diagnóstico Inicial y Estado de Recepción (Formato OT)
        _buildDiagnosticoInicialCard(formatoOt),
        const SizedBox(height: 20),

        // 3. Bitácora de Procedimientos y Tests de Diagnóstico Realizados (QA)
        _buildBitacoraYTestsCard(formatoActividades),
        const SizedBox(height: 20),

        // 4. Repuestos y Componentes Instalados (si existen)
        if (repuestos.isNotEmpty) ...[
          _buildRepuestosCard(repuestos),
          const SizedBox(height: 20),
        ],

        // 5. Acta de Entrega, Garantía y Recomendaciones de Cuidado
        _buildActaEntregaCard(actaEntrega, orden),
        const SizedBox(height: 20),

        // 6. Tarjeta de Fotos de Evidencia
        _buildFotosEvidenciaCard(fotos),

        // Modal para foto ampliada
        if (_fotoAmpliadaBase64 != null)
          Dialog(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.memory(base64Decode(_fotoAmpliadaBase64!), fit: BoxFit.contain),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => setState(() => _fotoAmpliadaBase64 = null),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ==================== 2. SECCIÓN: DIAGNÓSTICO INICIAL (OT) ====================
  Widget _buildDiagnosticoInicialCard(FormatoOt? ot) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.assignment_outlined, color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Diagnóstico Inicial de Recepción', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                    Text('Evaluación técnica preliminar y estado físico del equipo al momento del ingreso', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Diagnóstico Preliminar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.biotech_outlined, size: 16, color: Color(0xFF2563EB)),
                    SizedBox(width: 6),
                    Text('Diagnóstico Técnico Preliminar:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  (ot?.diagnosticoPreliminar != null && ot!.diagnosticoPreliminar!.trim().isNotEmpty)
                      ? ot.diagnosticoPreliminar!
                      : 'Evaluación técnica inicial: Se realiza recepción en ventanilla y apertura de orden para inspección de hardware y pruebas de encendido.',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Inspección Física y Encendido
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildMiniInfoBox(
                icon: Icons.power_settings_new,
                title: 'Encendido al Ingreso',
                value: (ot?.encendidoInicial ?? true) ? 'Encendió Correctamente' : 'Equipo Apagado / No Enciende',
                isPositive: ot?.encendidoInicial ?? true,
              ),
              _buildMiniInfoBox(
                icon: Icons.laptop_mac,
                title: 'Observaciones Físicas / Carcasa',
                value: (ot?.estadoCarcasa != null && ot!.estadoCarcasa!.trim().isNotEmpty)
                    ? ot.estadoCarcasa!
                    : 'Sin marcas críticas ni daños estructurales reportados',
                isPositive: true,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Accesorios Recibidos
          const Text('Accesorios Entregados por el Cliente:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCheckPill('Cargador Original / Adaptador', ot?.accesorioCargador == true),
              _buildCheckPill('Cable de Poder', ot?.accesorioCablePoder == true),
              _buildCheckPill('Mouse / Periférico', ot?.accesorioMouse == true),
              _buildCheckPill('Maletín / Funda Protectora', ot?.accesorioMaletin == true),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== 3. SECCIÓN: BITÁCORA Y TESTS DE DIAGNÓSTICO (QA) ====================
  Widget _buildBitacoraYTestsCard(FormatoActividades? act) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.build_circle_outlined, color: Color(0xFF16A34A), size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bitácora de Procedimientos y Pruebas Realizadas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                    Text('Registro técnico detallado de intervenciones, pruebas de estrés y control de calidad (QA)', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Procedimientos Realizados
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.edit_note_outlined, size: 18, color: Color(0xFF16A34A)),
                    SizedBox(width: 6),
                    Text('Procedimientos y Labores Realizadas en Taller:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  (act?.procedimientosRealizados != null && act!.procedimientosRealizados!.trim().isNotEmpty)
                      ? act.procedimientosRealizados!
                      : 'Mantenimiento integral completado: Desensamble, sopleteado de polvo en disipadores, reemplazo de pasta térmica, limpieza de contactos RAM y validación bajo pruebas de estrés térmico.',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Cuadrícula de Tests de Diagnóstico y Control de Calidad (QA)
          const Row(
            children: [
              Icon(Icons.verified_outlined, size: 16, color: Color(0xFF2563EB)),
              SizedBox(width: 6),
              Text('Tests de Diagnóstico y Pruebas de Calidad (QA) Realizados:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 620;
              final testItems = [
                _buildQaTestItem(title: 'Estrés Térmico (CPU/GPU)', subtitle: 'Monitoreo de disipación y temperaturas estables bajo carga continua', checked: act?.qaEstresTermico == true),
                _buildQaTestItem(title: 'Puertos y Periféricos', subtitle: 'Verificación de puertos USB, Tipo-C, salida HDMI y conectores jack de audio', checked: act?.qaPuertos == true),
                _buildQaTestItem(title: 'Conectividad y Redes', subtitle: 'Pruebas de enlace Wi-Fi (2.4/5GHz), Ethernet RJ45 y sincronización Bluetooth', checked: act?.qaConectividad == true),
                _buildQaTestItem(title: 'Batería y Alimentación', subtitle: 'Diagnóstico de ciclos, porcentaje de desgaste y retención de carga DC', checked: act?.qaBateria == true),
                _buildQaTestItem(title: 'Teclado y Touchpad', subtitle: 'Inspección de pulsación de todas las teclas físicas y respuesta multitáctil', checked: act?.qaTecladoTouchpad == true),
                _buildQaTestItem(title: 'Salud de Disco / SMART (CrystalDiskInfo)', subtitle: 'Verificación de sectores reasignados, tiempo de lectura y estado SMART en SSD/HDD', checked: act?.comprobacionDisco == true),
                _buildQaTestItem(title: 'Escaneo de Malware / Seguridad', subtitle: 'Detección y depuración de software malicioso, spyware y adware', checked: act?.escaneoMalware == true),
                _buildQaTestItem(title: 'Actualización de Controladores / BIOS', subtitle: 'Instalación de controladores oficiales de chipset, video y audio', checked: act?.actualizacionDrivers == true),
                _buildQaTestItem(title: 'Optimización de Inicio de Sistema', subtitle: 'Depuración de programas de arranque y aceleración del tiempo de encendido', checked: act?.optimizacionInicio == true),
                _buildQaTestItem(title: 'Depuración de Archivos Temporales', subtitle: 'Limpieza de caché, temporales de Windows y liberación de espacio en disco', checked: act?.depuracionTemporales == true),
              ];

              return Wrap(
                spacing: 12,
                runSpacing: 10,
                children: testItems.map((item) {
                  return SizedBox(
                    width: isNarrow ? constraints.maxWidth : (constraints.maxWidth - 12) / 2,
                    child: item,
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 20),

          // Insumos físicos y químicos aplicados
          const Row(
            children: [
              Icon(Icons.science_outlined, size: 16, color: Color(0xFFD97706)),
              SizedBox(width: 6),
              Text('Insumos de Laboratorio Aplicados:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCheckPill('Pasta Térmica de Alto Rendimiento', act?.pastaTermica == true),
              _buildCheckPill('Alcohol Isopropílico Electrónico 99.8%', act?.alcoholIsopropilico == true),
              _buildCheckPill('Sopleteado / Limpieza de Contactos', act?.sopleteadoContactos == true),
              _buildCheckPill('Brocha Antiestática ESD', act?.brochaAntiestatica == true),
              _buildCheckPill('Paño de Microfibra de Precisión', act?.panoMicrofibra == true),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== 4. SECCIÓN: REPUESTOS INSTALADOS ====================
  Widget _buildRepuestosCard(List<Repuesto> repuestos) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.memory, color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Repuestos y Componentes Instalados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                    Text('Piezas sustituidas o incorporadas en la reparación del equipo', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: repuestos.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final r = repuestos[i];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF16A34A)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r.referencia,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                    ),
                    Text('Cantidad: ${r.cantidad}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==================== 5. SECCIÓN: ACTA DE ENTREGA Y RECOMENDACIONES ====================
  Widget _buildActaEntregaCard(FormatoActaEntrega? acta, Orden orden) {
    final dateFormat = DateFormat('dd/MM/yyyy, HH:mm');
    final esOperativo = (acta?.estadoOperatividad ?? 'OPERATIVO') == 'OPERATIVO';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: esOperativo ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  esOperativo ? Icons.verified : Icons.warning_amber_rounded,
                  color: esOperativo ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Acta de Entrega y Recomendaciones Finales', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                    Text(
                      esOperativo
                          ? 'Equipo verificado y listo para entrega en óptimas condiciones operativas'
                          : 'Dictamen de entrega técnica y observaciones de laboratorio',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              if (acta?.garantiaDias != null && acta!.garantiaDias != 'SIN_GARANTIA')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shield_outlined, size: 14, color: Color(0xFF166534)),
                      const SizedBox(width: 4),
                      Text(
                        'Garantía: ${acta.garantiaDias.replaceAll('_', ' ')}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Observaciones Finales del Laboratorio
          if (acta?.observaciones != null && acta!.observaciones!.trim().isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notes, size: 16, color: Color(0xFF334155)),
                      SizedBox(width: 6),
                      Text('Observaciones Técnicas de Salida:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(acta.observaciones!, style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Recomendaciones de Cuidado para el Cliente
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.tips_and_updates_outlined, size: 16, color: Color(0xFFD97706)),
                    SizedBox(width: 6),
                    Text('Recomendaciones de Cuidado y Uso para el Cliente:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF92400E))),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  (acta?.recomendacionesCuidado != null && acta!.recomendacionesCuidado!.trim().isNotEmpty)
                      ? acta.recomendacionesCuidado!
                      : '• Mantener el equipo en superficies planas y despejadas para garantizar la correcta ventilación.\n• No obstruir las rejillas de refrigeración ni colocar el portátil sobre telas, camas o almohadas.\n• Conectar a regulador de voltaje o toma protegida contra fluctuaciones eléctricas.\n• Programar mantenimiento preventivo periódicamente cada 6 a 12 meses.',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF78350F), height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Información de Quien Recibe
          if (acta != null && acta.personaRecibeNombre.trim().isNotEmpty)
            Row(
              children: [
                const Icon(Icons.person_pin_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text('Equipo recibido a conformidad por: ', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                Text('${acta.personaRecibeNombre} (${acta.personaRecibeDocumento})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const Spacer(),
                Text('Fecha de Entrega: ${dateFormat.format(acta.fechaEntrega)}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
        ],
      ),
    );
  }

  // ==================== 6. SECCIÓN: FOTOS DE EVIDENCIA ====================
  Widget _buildFotosEvidenciaCard(List<FotoEvidencia> fotos) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.photo_library_outlined, color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fotos de Evidencia (${fotos.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                    const Text('Registro fotográfico de recepción, proceso en taller y pruebas pre-entrega', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          if (fotos.isEmpty)
            const Text(
              'No se han cargado fotos de evidencia para esta orden.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF94A3B8), fontSize: 13),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: fotos.map((f) {
                return InkWell(
                  onTap: () {
                    setState(() => _fotoAmpliadaBase64 = f.fotoBase64);
                  },
                  child: Container(
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.memory(
                          base64Decode(f.fotoBase64),
                          height: 95,
                          width: 130,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          color: const Color(0xFFF1F5F9),
                          alignment: Alignment.center,
                          child: Text(
                            f.etapa,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                          ),
                        ),
                        if (f.notaTecnica != null && f.notaTecnica!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              f.notaTecnica!,
                              style: const TextStyle(fontSize: 10, color: Color(0xFF475569)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // ==================== WIDGETS AUXILIARES ====================
  Widget _buildMiniInfoBox({required IconData icon, required String title, required String value, required bool isPositive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isPositive ? const Color(0xFFF8FAFC) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isPositive ? const Color(0xFFE2E8F0) : const Color(0xFFFECACA)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isPositive ? const Color(0xFF2563EB) : const Color(0xFFDC2626)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isPositive ? const Color(0xFF0F172A) : const Color(0xFF991B1B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckPill(String label, bool checked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: checked ? const Color(0xFFF0FDF4) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: checked ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.remove_circle_outline,
            size: 14,
            color: checked ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: checked ? FontWeight.bold : FontWeight.normal,
              color: checked ? const Color(0xFF166534) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQaTestItem({required String title, required String subtitle, required bool checked}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: checked ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: checked ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            checked ? Icons.verified : Icons.radio_button_unchecked,
            size: 18,
            color: checked ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: checked ? const Color(0xFF14532D) : const Color(0xFF334155),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: checked ? const Color(0xFFDCFCE7) : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        checked ? 'VALIDADO' : 'NO REQ',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: checked ? const Color(0xFF166534) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: checked ? const Color(0xFF166534).withValues(alpha: 0.8) : const Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ==================== RESULT CARD: EQUIPO (POR SERIAL) ====================
  Widget _buildEquipoResultCard(Equipo eq, List<Orden> historial) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPill(eq.tipoEquipo.toUpperCase(), const Color(0xFFDBEAFE), const Color(0xFF1E40AF)),
                        const SizedBox(height: 6),
                        Text('${eq.marca} ${eq.modelo}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        Text('Número de Serie: ${eq.numeroSerie}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Mantenimientos registrados', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        Text('${historial.length}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 14),

                const Text('Ficha Técnica y Componentes del Equipo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF334155))),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildSpecBox('Sistema Operativo', eq.sistemaOperativo ?? 'No especificado'),
                    _buildSpecBox('Procesador', eq.procesador ?? 'No especificado'),
                    _buildSpecBox('Memoria RAM', eq.memoriaRam ?? 'No especificado'),
                    _buildSpecBox('Almacenamiento (Disco)', eq.almacenamiento ?? 'No especificado'),
                    _buildSpecBox('Tarjeta Gráfica', eq.tarjetaGrafica ?? 'Integrada / Estándar'),
                  ],
                ),
                const SizedBox(height: 28),

                Text('Historial de Reparaciones y Mantenimientos (${historial.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                const SizedBox(height: 14),
                if (historial.isEmpty)
                  const Text('No hay mantenimientos anteriores registrados para este equipo.', style: TextStyle(color: Color(0xFF64748B), fontStyle: FontStyle.italic))
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: historial.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final h = historial[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          color: const Color(0xFFF8FAFC),
                        ),
                        child: Row(
                          children: [
                            Text('#${h.codigoOrden}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                            const SizedBox(width: 12),
                            _buildPill(h.tipoServicio, const Color(0xFFFEF3C7), const Color(0xFFD97706)),
                            const SizedBox(width: 8),
                            _buildPill(h.estado, const Color(0xFFDCFCE7), const Color(0xFF166534)),
                            const SizedBox(width: 14),
                            Expanded(child: Text(h.titulo, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            Text('${h.fechaIngreso.day}/${h.fechaIngreso.month}/${h.fechaIngreso.year}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecBox(String label, String value) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  // ==================== RESULT CARD: CLIENTE (POR CÉDULA/NIT) ====================
  Widget _buildClienteResultCard(Cliente cliente, List<Orden> ordenes) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFDBEAFE),
                child: const Icon(Icons.person, color: Color(0xFF1E40AF)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cliente.nombreCompleto, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    Text('${cliente.tipoDocumento}: ${cliente.numeroDocumento} | Tel: ${cliente.telefono}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 14),
          Text('Órdenes y Tickets Asociados (${ordenes.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          if (ordenes.isEmpty)
            const Text('No hay órdenes registradas para este titular.', style: TextStyle(color: Color(0xFF64748B), fontStyle: FontStyle.italic))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ordenes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final o = ordenes[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  tileColor: const Color(0xFFF8FAFC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  title: Text('#${o.codigoOrden} - ${o.titulo}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('Estado: ${o.estado} | Ingreso: ${o.fechaIngreso.day}/${o.fechaIngreso.month}/${o.fechaIngreso.year}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    _searchCtrl.text = o.codigoOrden;
                    _ejecutarConsulta(o.codigoOrden);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
