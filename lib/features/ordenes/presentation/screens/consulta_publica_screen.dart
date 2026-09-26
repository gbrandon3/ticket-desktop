import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/entities/equipo.dart';
import '../../domain/entities/foto_evidencia.dart';
import '../../domain/entities/orden.dart';
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
                    if (_resultado!['tipo'] == 'ticket') _buildTicketResultCard(_resultado!['orden'] as Orden, _resultado!['fotos'] as List<FotoEvidencia>),
                    if (_resultado!['tipo'] == 'equipo') _buildEquipoResultCard(_resultado!['equipo'] as Equipo, _resultado!['historial'] as List<Orden>),
                    if (_resultado!['tipo'] == 'cliente') _buildClienteResultCard(_resultado!['cliente'] as Cliente, _resultado!['ordenes'] as List<Orden>),
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

  // ==================== RESULT CARD: TICKET (IMAGEN 1) ====================
  Widget _buildTicketResultCard(Orden orden, List<FotoEvidencia> fotos) {
    final dateFormat = DateFormat('dd/MM/yyyy, HH:mm:ss');
    final fechaAperturaStr = dateFormat.format(orden.fechaIngreso);

    return Column(
      children: [
        // Card Principal del Ticket con acento azul superior
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
                          Expanded(child: _buildInfoCol('Ubicación', orden.cliente?.direccion ?? 'Taller Central')),
                          Expanded(child: _buildInfoCol('Técnico Responsable', orden.tecnico?.nombre ?? 'Sin asignar aún')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Falla / Trabajo Solicitado
                    Text(
                      'Falla / Trabajo Solicitado: ${orden.titulo}',
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

        // Tarjeta de Fotos de Evidencia
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fotos de Evidencia (${fotos.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 12),
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
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Image.memory(
                              base64Decode(f.fotoBase64),
                              height: 90,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              color: const Color(0xFFF1F5F9),
                              alignment: Alignment.center,
                              child: Text(
                                f.etapa,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
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
        ),

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
