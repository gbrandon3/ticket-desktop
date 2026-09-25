import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../domain/entities/notificacion_auditoria.dart';
import '../../domain/entities/orden.dart';
import '../../domain/entities/usuario.dart';
import '../providers/auth_provider.dart';
import '../providers/catalogo_fallas_provider.dart';
import '../providers/ordenes_providers.dart';
import '../widgets/status_badge.dart';
import 'configuracion_page_screen.dart';
import 'detalle_taller_screen.dart';
import 'documento_oficial_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  Map<String, dynamic>? _metrics;
  List<Usuario> _tecnicos = [];
  List<NotificacionAuditoria> _auditoria = [];
  bool _loading = true;

  int? _filtroTecnicoId;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() => _loading = true);
    final repo = ref.read(ordenesRepositoryProvider);
    final metrics = await repo.getAdminMetrics();
    final tecnicos = await repo.getUsuarios(rol: 'tecnico');
    final audit = await repo.getAuditoriaNotificaciones();

    setState(() {
      _metrics = metrics;
      _tecnicos = tecnicos;
      _auditoria = audit;
      _loading = false;
    });
  }

  Future<void> _asignarTecnico(int ordenId, int tecnicoId) async {
    final repo = ref.read(ordenesRepositoryProvider);
    await repo.asignarTecnico(ordenId, tecnicoId);
    _cargarDatos();
  }

  void _exportarCsv(List<Orden> ordenes) {
    final sb = StringBuffer();
    // UTF-8 BOM
    sb.write('\uFEFF');
    sb.writeln('Codigo,Cliente,Documento,Equipo,Serie,Tipo,Estado,Prioridad,Tecnico,Fecha Ingreso');

    for (final o in ordenes) {
      sb.writeln(
        '"${o.codigoOrden}","${o.cliente?.nombreCompleto ?? ''}","${o.cliente?.numeroDocumento ?? ''}","${o.equipo?.tipoEquipo ?? ''} ${o.equipo?.marca ?? ''}","${o.equipo?.numeroSerie ?? ''}","${o.tipoServicio}","${o.estado}","${o.prioridad}","${o.tecnico?.nombre ?? 'Sin Asignar'}","${DateFormat('yyyy-MM-dd HH:mm').format(o.fechaIngreso)}"',
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Se exportaron ${ordenes.length} registros a formato CSV exitosamente.'),
        backgroundColor: SantiConstants.successGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _metrics == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentUser = ref.watch(authProvider);
    final esTecnico = currentUser?.rol == 'tecnico';
    final ordenesAsync = ref.watch(filteredOrdenesStreamProvider);
    final ordenesList = ordenesAsync.value ?? [];

    final ordenesTecnico = esTecnico
        ? ordenesList.where((o) => o.tecnicoId == currentUser?.id || o.tecnico?.id == currentUser?.id).toList()
        : ordenesList;

    final total = esTecnico ? ordenesTecnico.length : (_metrics!['total'] as int);
    final vencidos = esTecnico
        ? ordenesTecnico.where((o) => o.estaVencidoSla && o.estado != 'ENTREGADO_CERRADO').length
        : (_metrics!['vencidos'] as int);
    final sinAsignar = esTecnico
        ? ordenesTecnico.where((o) => o.estado == 'RECIBIDO' || o.estado == 'EN_DIAGNOSTICO').length
        : (_metrics!['sinAsignar'] as int);
    final preventivos = esTecnico
        ? ordenesTecnico.where((o) => o.tipoServicio == 'PREVENTIVO').length
        : (_metrics!['preventivos'] as int);
    final correctivos = esTecnico
        ? ordenesTecnico.where((o) => o.tipoServicio == 'CORRECTIVO').length
        : (_metrics!['correctivos'] as int);
    final double porcentajeSla = total > 0
        ? (((total - vencidos) / total) * 100).clamp(0, 100)
        : 100.0;
    final tiempoPromedio = (_metrics!['tiempoPromedioHoras'] as num).toDouble();
    final cargaTecnicos = (_metrics!['cargaTecnicos'] as List).cast<Map<String, dynamic>>();

    final double pctPrev = total > 0 ? (preventivos / total) * 100 : 50;

    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de Título y Botones de Reporte
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      esTecnico ? 'Dashboard Técnico' : 'Panel de Control & Supervisión Administrativa',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      esTecnico
                          ? 'Métricas operativas personales, cumplimiento de SLA y gestión de órdenes asignadas.'
                          : 'Métricas operativas, cumplimiento de SLA y asignación de personal técnico.',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              ordenesAsync.maybeWhen(
                data: (list) => Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _exportarCsv(esTecnico ? ordenesTecnico : list),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Exportar CSV / Excel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Generando vista de reporte imprimible...')),
                        );
                      },
                      icon: const Icon(Icons.print, size: 16),
                      label: const Text('Imprimir Reporte'),
                    ),
                  ],
                ),
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 0. Apartado de Anuncios y Configuración Inicial (Onboarding Taller)
          if (!esTecnico) ...[
            _buildApartadoAnunciosConfiguracion(context, ref),
          ],

          // 1. Tarjetas de SLA (Compactas con altura acotada)
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;
              final card1 = _statCard(
                title: 'Cumplimiento SLA',
                value: '${porcentajeSla.toStringAsFixed(1)}%',
                icon: Icons.speed,
                color: porcentajeSla >= 85 ? Colors.green : Colors.red,
                subtitle: 'Objetivo > 85%',
              );
              final card2 = _statCard(
                title: 'Tiempo Prom. Resolución',
                value: '${tiempoPromedio.toStringAsFixed(1)} h',
                icon: Icons.timer_outlined,
                color: Colors.blue,
                subtitle: 'Horas de trabajo',
              );
              final card3 = _statCard(
                title: 'Tickets Vencidos',
                value: '$vencidos',
                icon: Icons.warning_amber_rounded,
                color: vencidos > 0 ? Colors.red : Colors.green,
                subtitle: 'Fuera de plazo',
              );
              final card4 = _statCard(
                title: esTecnico ? 'En Recepción / Diag.' : 'Sin Asignar',
                value: '$sinAsignar',
                icon: esTecnico ? Icons.assignment_outlined : Icons.person_off_outlined,
                color: sinAsignar > 0 ? Colors.orange : Colors.green,
                subtitle: esTecnico ? 'Por iniciar taller' : 'Pendientes de técnico',
              );

              if (isNarrow) {
                return Column(
                  children: [
                    SizedBox(
                      height: 96,
                      child: Row(
                        children: [
                          Expanded(child: card1),
                          const SizedBox(width: 14),
                          Expanded(child: card2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 96,
                      child: Row(
                        children: [
                          Expanded(child: card3),
                          const SizedBox(width: 14),
                          Expanded(child: card4),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return SizedBox(
                height: 96,
                child: Row(
                  children: [
                    Expanded(child: card1),
                    const SizedBox(width: 14),
                    Expanded(child: card2),
                    const SizedBox(width: 14),
                    Expanded(child: card3),
                    const SizedBox(width: 14),
                    Expanded(child: card4),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // 2. Ratio Preventivo vs Correctivo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    const Text('Proporción Operativa: Preventivo vs Correctivo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(
                      'Preventivo: $preventivos (${pctPrev.toStringAsFixed(0)}%) | Correctivo: $correctivos (${(100 - pctPrev).toStringAsFixed(0)}%)',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 14,
                    child: Row(
                      children: [
                        Expanded(
                          flex: pctPrev.round().clamp(1, 99),
                          child: Container(color: SantiConstants.successGreen),
                        ),
                        Expanded(
                          flex: (100 - pctPrev).round().clamp(1, 99),
                          child: Container(color: Colors.amber.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  pctPrev >= 60
                      ? 'Excelente ratio de mantenimiento preventivo. Reduce fallas críticas imprevistas en los clientes.'
                      : 'Alerta: Alta proporción de correctivos. Se recomienda promover planes de mantenimiento preventivo programado.',
                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Carga por Técnico (Solo para Administrador y Operador)
          if (!esTecnico) ...[
            const Text('Carga de Trabajo por Técnico', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy)),
            const SizedBox(height: 10),
            SizedBox(
              height: 96,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cargaTecnicos.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    final isSelected = _filtroTecnicoId == null;
                    return InkWell(
                      onTap: () => setState(() => _filtroTecnicoId = null),
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? SantiConstants.primaryBlue : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isSelected ? SantiConstants.primaryBlue : Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Todos los Técnicos', style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('Ver general', style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ),
                    );
                  }

                  final t = cargaTecnicos[index - 1];
                  final tId = t['id'] as int;
                  final isSelected = _filtroTecnicoId == tId;

                  return InkWell(
                    onTap: () => setState(() => _filtroTecnicoId = isSelected ? null : tId),
                    child: Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? SantiConstants.primaryBlue : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? SantiConstants.primaryBlue : Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            t['nombre'],
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(4)),
                                child: Text('${t['activas']} activas', style: TextStyle(color: Colors.amber.shade900, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
                                child: Text('${t['terminadas']} cerradas', style: TextStyle(color: Colors.green.shade900, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // 4. Tabla Global de Supervisión / Mis Órdenes Asignadas
          Text(
            esTecnico ? 'Mis Órdenes Asignadas' : 'Supervisión Global de Órdenes',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy),
          ),
          const SizedBox(height: 12),

          ordenesAsync.when(
            data: (ordenes) {
              final ordenesBase = esTecnico
                  ? ordenes.where((o) => o.tecnicoId == currentUser?.id || o.tecnico?.id == currentUser?.id).toList()
                  : ordenes;

              final filtradas = _filtroTecnicoId == null
                  ? ordenesBase
                  : ordenesBase.where((o) => o.tecnicoId == _filtroTecnicoId).toList();

              if (filtradas.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Text('No hay órdenes registradas con este filtro.'),
                );
              }

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          columnSpacing: 24,
                          horizontalMargin: 18,
                          columns: const [
                      DataColumn(label: Text('Código')),
                      DataColumn(label: Text('Cliente')),
                      DataColumn(label: Text('Equipo')),
                      DataColumn(label: Text('Tipo')),
                      DataColumn(label: Text('Estado')),
                      DataColumn(label: Text('Prioridad')),
                      DataColumn(label: Text('SLA')),
                      DataColumn(label: Text('Técnico Asignado')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: filtradas.map((o) {
                      return DataRow(
                        cells: [
                          DataCell(
                            InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: o.codigoOrden));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Código ${o.codigoOrden} copiado al portapapeles'),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SelectableText(
                                      o.codigoOrden,
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: SantiConstants.primaryBlue),
                                    ),
                                    const SizedBox(width: 6),
                                    const Tooltip(
                                      message: 'Copiar código',
                                      child: Icon(Icons.copy, size: 14, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(o.cliente?.nombreCompleto ?? 'N/A')),
                          DataCell(Text('${o.equipo?.tipoEquipo ?? ''} ${o.equipo?.marca ?? ''}')),
                          DataCell(Text(o.tipoServicio, style: const TextStyle(fontSize: 12))),
                          DataCell(StatusBadge(status: o.estado)),
                          DataCell(PriorityBadge(priority: o.prioridad)),
                          DataCell(
                            o.estaVencidoSla
                                ? const Row(
                                    children: [
                                      Icon(Icons.warning, color: Colors.red, size: 14),
                                      SizedBox(width: 4),
                                      Text('Vencido', style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                : const Text('En Plazo', style: TextStyle(color: Colors.green, fontSize: 11)),
                          ),
                          DataCell(
                            esTecnico
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      o.tecnico?.nombre ?? currentUser?.nombre ?? 'Asignado a mí',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  )
                                : DropdownButton<int?>(
                                    value: o.tecnicoId,
                                    underline: const SizedBox.shrink(),
                                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                                    hint: const Text('Sin asignar', style: TextStyle(fontSize: 12, color: Colors.orange)),
                                    items: [
                                      const DropdownMenuItem<int?>(value: null, child: Text('Sin Asignar')),
                                      ..._tecnicos.map((t) => DropdownMenuItem<int?>(value: t.id, child: Text(t.nombre))),
                                    ],
                                    onChanged: (newTId) {
                                      if (newTId != null) {
                                        _asignarTecnico(o.id!, newTId);
                                      }
                                    },
                                  ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.handyman, size: 18, color: SantiConstants.primaryBlue),
                                  tooltip: 'Gestionar Taller',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => DetalleTallerScreen(ordenId: o.id!)),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.picture_as_pdf, size: 18, color: Colors.red),
                                  tooltip: 'Documento Oficial',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => DocumentoOficialScreen(ordenId: o.id!)),
                                    );
                                  },
                                ),
                              ],
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
        );
      },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error: $err'),
          ),

          const SizedBox(height: 32),

          // 5. Auditoría de Notificaciones por Correo
          const Text('Auditoría de Notificaciones por Correo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: _auditoria.isEmpty
                ? const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('No hay registros de correo en la bitácora de auditoría.')))
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _auditoria.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final a = _auditoria[index];
                      return ListTile(
                        leading: Icon(
                          a.estado == 'ENVIADO' ? Icons.check_circle : Icons.error,
                          color: a.estado == 'ENVIADO' ? Colors.green : Colors.red,
                        ),
                        title: Text(a.asunto, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text('Destinatario: ${a.destinatario} • Evento: ${a.evento}', style: const TextStyle(fontSize: 12)),
                        trailing: Text(DateFormat('dd/MM HH:mm').format(a.fechaEnvio), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildApartadoAnunciosConfiguracion(BuildContext context, WidgetRef ref) {
    final fallasCountAsync = ref.watch(countTiposFallaProvider);
    final int fallasCount = fallasCountAsync.value ?? 0;
    final int tecnicosCount = _tecnicos.length;

    final pendingCards = <Widget>[];

    // Card 1: Tipos de Falla (desaparece si fallasCount > 0)
    if (fallasCount == 0) {
      pendingCards.add(
        _anuncioCard(
          icon: Icons.build_circle_outlined,
          iconColor: const Color(0xFFEA580C),
          title: 'Tipos de Falla',
          description:
              'Crea los tipos de falla del taller. Se guardan en la base de datos para clasificar las órdenes de servicio.',
          badgeText: '0 tipos registrados',
          btnLabel: 'Crear Tipo de Falla',
          onAction: () {
            if (GoRouter.maybeOf(context) != null) {
              context.go('/configuracion?tab=5');
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ConfiguracionPageScreen(initialTabIndex: 5),
                ),
              ).then((_) => _cargarDatos());
            }
          },
        ),
      );
    }

    // Card 2: Personal Técnico (desaparece si tecnicosCount > 0)
    if (tecnicosCount == 0) {
      pendingCards.add(
        _anuncioCard(
          icon: Icons.group_add_outlined,
          iconColor: const Color(0xFF2563EB),
          title: 'Crear Personal Técnico',
          description:
              'Registra al personal técnico y operadores para asignar y gestionar la mesa de soporte.',
          badgeText: 'Solo admin registrado',
          btnLabel: 'Crear Usuarios',
          onAction: () {
            if (GoRouter.maybeOf(context) != null) {
              context.go('/configuracion?tab=2');
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ConfiguracionPageScreen(initialTabIndex: 2),
                ),
              ).then((_) => _cargarDatos());
            }
          },
        ),
      );
    }

    // Si ya no quedan tareas pendientes, se oculta completamente el apartado
    if (pendingCards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
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
        padding: const EdgeInsets.all(18),
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
                  child: const Icon(Icons.campaign, color: Color(0xFF2563EB), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Puesta en Marcha y Configuración Inicial',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: SantiConstants.primaryNavy,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Pasos recomendados para dejar el taller completamente operativo y parametrizado en la base de datos.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (ctx, constraints) {
                final isNarrow = constraints.maxWidth < 950;
                if (isNarrow || pendingCards.length == 1) {
                  return Column(
                    children: [
                      for (int i = 0; i < pendingCards.length; i++) ...[
                        if (i > 0) const SizedBox(height: 12),
                        pendingCards[i],
                      ],
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < pendingCards.length; i++) ...[
                      if (i > 0) const SizedBox(width: 14),
                      Expanded(child: pendingCards[i]),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _anuncioCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String badgeText,
    required String btnLabel,
    required VoidCallback onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFFDE68A),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.35),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 14,
                      color: Color(0xFFD97706),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      badgeText,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SantiConstants.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                child: Text(btnLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
