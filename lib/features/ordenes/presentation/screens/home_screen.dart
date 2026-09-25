import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../domain/entities/orden.dart';
import '../../domain/entities/usuario.dart';
import '../providers/auth_provider.dart';
import '../providers/ordenes_providers.dart';
import '../widgets/app_header.dart';
import '../widgets/metric_card.dart';
import '../widgets/orden_card.dart';
import '../widgets/status_badge.dart';
import 'detalle_taller_screen.dart';
import 'documento_oficial_screen.dart';
import 'crear_incidencia_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _vistaTabla = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Orden> _filtrarParaTecnico(List<Orden> list, Usuario? user) {
    if (user?.rol != 'tecnico') return list;
    return list.where((o) => o.tecnicoId == user?.id || o.tecnico?.id == user?.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider);
    final esTecnico = currentUser?.rol == 'tecnico';
    final metricsAsync = ref.watch(dashboardMetricsProvider);
    final ordenesAsync = ref.watch(filteredOrdenesStreamProvider);
    final selectedEstado = ref.watch(estadoFilterProvider);
    final selectedTipo = ref.watch(tipoFilterProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado institucional Santi INC (sin botón de nueva orden si es técnico)
            AppHeader(
              onNuevaOrden: esTecnico
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CrearIncidenciaScreen()),
                      );
                    },
            ),

            // Contenido Scrolleable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Tarjetas de Métricas (Filtradas para el técnico si es rol técnico)
                    metricsAsync.when(
                      data: (metrics) => LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 900;
                          final ordenesRaw = ordenesAsync.value ?? [];
                          final ordenesTecnico = _filtrarParaTecnico(ordenesRaw, currentUser);

                          final totalCount = esTecnico ? ordenesTecnico.length : metrics.totalOrdenes;
                          final enTallerCount = esTecnico
                              ? ordenesTecnico.where((o) => o.estado == 'EN_TALLER' || o.estado == 'EN_DIAGNOSTICO' || o.estado == 'RECIBIDO').length
                              : metrics.enTaller;
                          final resueltosCount = esTecnico
                              ? ordenesTecnico.where((o) => o.estado == 'LISTO_ENTREGA').length
                              : metrics.resueltos;
                          final entregadosCount = esTecnico
                              ? ordenesTecnico.where((o) => o.estado == 'ENTREGADO_CERRADO').length
                              : metrics.entregadosCerrados;

                          final card1 = MetricCard(
                            title: esTecnico ? 'Mis Órdenes' : 'Total Órdenes',
                            count: totalCount,
                            icon: Icons.folder_open,
                            color: const Color(0xFF2563EB),
                          );
                          final card2 = MetricCard(
                            title: 'En Taller / Proceso',
                            count: enTallerCount,
                            icon: Icons.handyman,
                            color: const Color(0xFFD97706),
                          );
                          final card3 = MetricCard(
                            title: 'Resueltos / Listos',
                            count: resueltosCount,
                            icon: Icons.check_circle_outline,
                            color: const Color(0xFF16A34A),
                          );
                          final card4 = MetricCard(
                            title: 'Entregados / Cerrados',
                            count: entregadosCount,
                            icon: Icons.archive_outlined,
                            color: const Color(0xFF64748B),
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
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Text('Error al cargar métricas: $err'),
                    ),

                    const SizedBox(height: 24),

                    // 2. Buscador y Filtros
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
                          // Buscador en tiempo real
                          TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              ref.read(searchQueryProvider.notifier).setQuery(val);
                            },
                            decoration: InputDecoration(
                              hintText: 'Buscar por código (ej. ORD-2024), cliente, documento o serie...',
                              prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        ref.read(searchQueryProvider.notifier).setQuery('');
                                      },
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Filtros de Estado y Tipo
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                'Estado:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              _filterChip(
                                label: 'Todos',
                                isSelected: selectedEstado == 'TODOS',
                                onSelected: () => ref.read(estadoFilterProvider.notifier).setEstado('TODOS'),
                              ),
                              _filterChip(
                                label: 'Recibido',
                                isSelected: selectedEstado == 'RECIBIDO',
                                onSelected: () => ref.read(estadoFilterProvider.notifier).setEstado('RECIBIDO'),
                              ),
                              _filterChip(
                                label: 'En Diagnóstico',
                                isSelected: selectedEstado == 'EN_DIAGNOSTICO',
                                onSelected: () => ref.read(estadoFilterProvider.notifier).setEstado('EN_DIAGNOSTICO'),
                              ),
                              _filterChip(
                                label: 'En Taller',
                                isSelected: selectedEstado == 'EN_TALLER',
                                onSelected: () => ref.read(estadoFilterProvider.notifier).setEstado('EN_TALLER'),
                              ),
                              _filterChip(
                                label: 'Listo para Entrega',
                                isSelected: selectedEstado == 'LISTO_ENTREGA',
                                onSelected: () => ref.read(estadoFilterProvider.notifier).setEstado('LISTO_ENTREGA'),
                              ),
                              _filterChip(
                                label: 'Entregado / Cerrado',
                                isSelected: selectedEstado == 'ENTREGADO_CERRADO',
                                onSelected: () => ref.read(estadoFilterProvider.notifier).setEstado('ENTREGADO_CERRADO'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                'Tipo:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              _filterChip(
                                label: 'Todos',
                                isSelected: selectedTipo == 'TODOS',
                                onSelected: () => ref.read(tipoFilterProvider.notifier).setTipo('TODOS'),
                              ),
                              _filterChip(
                                label: 'Preventivo',
                                isSelected: selectedTipo == 'PREVENTIVO',
                                onSelected: () => ref.read(tipoFilterProvider.notifier).setTipo('PREVENTIVO'),
                              ),
                              _filterChip(
                                label: 'Correctivo',
                                isSelected: selectedTipo == 'CORRECTIVO',
                                onSelected: () => ref.read(tipoFilterProvider.notifier).setTipo('CORRECTIVO'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 3. Lista de Tarjetas de Órdenes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          esTecnico ? 'Mis Órdenes Asignadas' : 'Órdenes en Taller',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Row(
                          children: [
                            ordenesAsync.maybeWhen(
                              data: (list) {
                                final count = _filtrarParaTecnico(list, currentUser).length;
                                return Text(
                                  '$count órdenes ${esTecnico ? "asignadas" : "encontradas"}',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                );
                              },
                              orElse: () => const SizedBox.shrink(),
                            ),
                            const SizedBox(width: 14),
                            SegmentedButton<bool>(
                              segments: const [
                                ButtonSegment(
                                  value: true,
                                  icon: Icon(Icons.table_chart_outlined, size: 16),
                                  label: Text('Tabla', style: TextStyle(fontSize: 12)),
                                ),
                                ButtonSegment(
                                  value: false,
                                  icon: Icon(Icons.view_agenda_outlined, size: 16),
                                  label: Text('Tarjetas', style: TextStyle(fontSize: 12)),
                                ),
                              ],
                              selected: {_vistaTabla},
                              onSelectionChanged: (val) => setState(() => _vistaTabla = val.first),
                              style: ButtonStyle(
                                visualDensity: VisualDensity.compact,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 8)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    ordenesAsync.when(
                      data: (todasOrdenes) {
                        final ordenes = _filtrarParaTecnico(todasOrdenes, currentUser);
                        if (ordenes.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.inbox_outlined, size: 56, color: Colors.grey.shade400),
                                const SizedBox(height: 12),
                                Text(
                                  esTecnico
                                      ? 'No tienes órdenes de trabajo asignadas en este momento.'
                                      : 'No hay órdenes registradas con los filtros seleccionados',
                                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                                ),
                                if (!esTecnico) ...[
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => const CrearIncidenciaScreen()),
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Registrar Primera Orden'),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }

                        if (_vistaTabla) {
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
                                      columnSpacing: 28,
                                      horizontalMargin: 20,
                                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                                columns: const [
                                  DataColumn(label: Text('Código', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Fecha Ingreso', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Equipo', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Falla / Síntoma', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Prioridad', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Técnico', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold))),
                                ],
                                rows: ordenes.map((orden) {
                                  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
                                  return DataRow(
                                    cells: [
                                      // Código copiable
                                      DataCell(
                                        InkWell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(text: orden.codigoOrden));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Código ${orden.codigoOrden} copiado al portapapeles'),
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
                                                  orden.codigoOrden,
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
                                      // Fecha
                                      DataCell(Text(dateFormat.format(orden.fechaIngreso), style: const TextStyle(fontSize: 12))),
                                      // Cliente
                                      DataCell(
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(orden.cliente?.nombreCompleto ?? 'Cliente Desconocido', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                            Text('${orden.cliente?.tipoDocumento ?? ''} ${orden.cliente?.numeroDocumento ?? ''}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                          ],
                                        ),
                                      ),
                                      // Equipo
                                      DataCell(
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('${orden.equipo?.tipoEquipo ?? ''} ${orden.equipo?.marca ?? ''} ${orden.equipo?.modelo ?? ''}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                                            Text('SN: ${orden.equipo?.numeroSerie ?? 'S/N'}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                          ],
                                        ),
                                      ),
                                      // Falla / Síntoma
                                      DataCell(
                                        SizedBox(
                                          width: 180,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(orden.titulo, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                                              Text(orden.descripcion, style: TextStyle(fontSize: 11, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Tipo
                                      DataCell(Text(orden.tipoServicio, style: const TextStyle(fontSize: 12))),
                                      // Estado
                                      DataCell(StatusBadge(status: orden.estado)),
                                      // Prioridad
                                      DataCell(PriorityBadge(priority: orden.prioridad)),
                                      // Técnico
                                      DataCell(
                                        Text(
                                          orden.tecnicoId != null ? 'Técnico #${orden.tecnicoId}' : 'Sin Asignar',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: orden.tecnicoId != null ? FontWeight.normal : FontWeight.bold,
                                            color: orden.tecnicoId != null ? Colors.black87 : Colors.orange.shade800,
                                          ),
                                        ),
                                      ),
                                      // Acciones
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.handyman, size: 18, color: SantiConstants.primaryBlue),
                                              tooltip: 'Gestionar Taller',
                                              onPressed: () {
                                                if (GoRouter.maybeOf(context) != null) {
                                                  context.push('/ordenes/${orden.id}');
                                                } else {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) => DetalleTallerScreen(ordenId: orden.id!),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.picture_as_pdf, size: 18, color: Colors.red),
                                              tooltip: 'Documento Oficial',
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) => DocumentoOficialScreen(ordenId: orden.id!),
                                                  ),
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
                  }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ordenes.length,
                          itemBuilder: (context, index) {
                            final orden = ordenes[index];
                            return OrdenCard(
                              orden: orden,
                              onGestionar: () {
                                if (GoRouter.maybeOf(context) != null) {
                                  context.push('/ordenes/${orden.id}');
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => DetalleTallerScreen(ordenId: orden.id!),
                                    ),
                                  );
                                }
                              },
                              onVerDocumento: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => DocumentoOficialScreen(ordenId: orden.id!),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (err, _) => Center(
                        child: Text('Error cargando órdenes: $err', style: const TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: SantiConstants.primaryBlue.withOpacity(0.15),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? SantiConstants.primaryBlue : Colors.grey.shade700,
      ),
    );
  }
}
