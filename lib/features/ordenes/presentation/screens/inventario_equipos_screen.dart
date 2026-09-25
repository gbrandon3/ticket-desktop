import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../domain/entities/equipo.dart';
import '../../domain/entities/orden.dart';
import '../providers/ordenes_providers.dart';
import 'detalle_taller_screen.dart';

class InventarioEquiposScreen extends ConsumerStatefulWidget {
  const InventarioEquiposScreen({super.key});

  @override
  ConsumerState<InventarioEquiposScreen> createState() => _InventarioEquiposScreenState();
}

class _InventarioEquiposScreenState extends ConsumerState<InventarioEquiposScreen> {
  final _searchController = TextEditingController();
  String _filtroTipo = 'TODOS';
  String _filtroEstado = 'TODOS';

  List<Equipo> _equipos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarEquipos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarEquipos() async {
    setState(() => _cargando = true);
    final repo = ref.read(ordenesRepositoryProvider);
    final data = await repo.getInventarioEquipos(
      busqueda: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
      tipo: _filtroTipo == 'TODOS' ? null : _filtroTipo,
      estado: _filtroEstado == 'TODOS' ? null : _filtroEstado,
    );
    if (mounted) {
      setState(() {
        _equipos = data;
        _cargando = false;
      });
    }
  }

  void _abrirHojaDeVida(Equipo equipo) {
    showDialog(
      context: context,
      builder: (ctx) => _HojaVidaDialog(
        equipo: equipo,
        onEstadoCambiado: () {
          _cargarEquipos();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _equipos.length;
    final operativos = _equipos.where((e) => e.estadoEquipo == 'OPERATIVO').length;
    final enTaller = _equipos.where((e) => e.estadoEquipo == 'EN_TALLER').length;
    final deBaja = _equipos.where((e) => e.estadoEquipo == 'DE_BAJA').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Equipos y Hoja de Vida'),
        backgroundColor: SantiConstants.primaryNavy,
      ),
      body: RefreshIndicator(
        onRefresh: _cargarEquipos,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================== TARJETAS DE CONTEO ====================
              Row(
                children: [
                  _buildCounterCard('Total Equipos', '$total', Icons.devices, Colors.blue.shade700, Colors.blue.shade50),
                  const SizedBox(width: 12),
                  _buildCounterCard('Operativos', '$operativos', Icons.check_circle_outline, Colors.green.shade700, Colors.green.shade50),
                  const SizedBox(width: 12),
                  _buildCounterCard('En Taller', '$enTaller', Icons.build_circle_outlined, Colors.amber.shade800, Colors.amber.shade50),
                  const SizedBox(width: 12),
                  _buildCounterCard('Dados de Baja', '$deBaja', Icons.archive_outlined, Colors.red.shade700, Colors.red.shade50),
                ],
              ),
              const SizedBox(height: 20),

              // ==================== FILTROS Y BÚSQUEDA ====================
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Buscar por marca, modelo, serial o procesador...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _searchController.clear();
                                          _cargarEquipos();
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                              ),
                              onSubmitted: (_) => _cargarEquipos(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: _filtroTipo,
                              decoration: InputDecoration(
                                labelText: 'Tipo de Equipo',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                              ),
                              items: const [
                                DropdownMenuItem(value: 'TODOS', child: Text('Todos los Tipos')),
                                DropdownMenuItem(value: 'Portátil / Laptop', child: Text('Portátil / Laptop')),
                                DropdownMenuItem(value: 'Torre / PC Mesa', child: Text('Torre / PC Mesa')),
                                DropdownMenuItem(value: 'Todo en Uno (AIO)', child: Text('Todo en Uno (AIO)')),
                                DropdownMenuItem(value: 'Servidor', child: Text('Servidor')),
                                DropdownMenuItem(value: 'Impresora / Periférico', child: Text('Impresora / Periférico')),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _filtroTipo = v);
                                  _cargarEquipos();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: _filtroEstado,
                              decoration: InputDecoration(
                                labelText: 'Estado Operativo',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                isDense: true,
                              ),
                              items: const [
                                DropdownMenuItem(value: 'TODOS', child: Text('Todos los Estados')),
                                DropdownMenuItem(value: 'OPERATIVO', child: Text('Operativo')),
                                DropdownMenuItem(value: 'EN_TALLER', child: Text('En Taller')),
                                DropdownMenuItem(value: 'DE_BAJA', child: Text('Dado de Baja')),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _filtroEstado = v);
                                  _cargarEquipos();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _cargarEquipos,
                            icon: const Icon(Icons.filter_list, size: 18),
                            label: const Text('Filtrar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SantiConstants.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ==================== LISTADO / TABLA DE EQUIPOS ====================
              if (_cargando)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_equipos.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.devices_other, size: 56, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'No se encontraron equipos en el inventario con los criterios especificados.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          color: const Color(0xFFF1F5F9),
                          child: const Row(
                            children: [
                              Expanded(flex: 2, child: Text('Serial / Identificador', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155)))),
                              Expanded(flex: 2, child: Text('Tipo & Marca', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155)))),
                              Expanded(flex: 3, child: Text('Modelo & Especificaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155)))),
                              Expanded(flex: 2, child: Text('Estado Operativo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155)))),
                              Expanded(flex: 2, child: Text('Acciones', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155)))),
                            ],
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _equipos.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final eq = _equipos[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        _getDeviceIcon(eq.tipoEquipo),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Text(
                                            eq.numeroSerie,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: SantiConstants.primaryNavy),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(eq.tipoEquipo, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                        Text(eq.marca, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(eq.modelo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                        Text(
                                          '${eq.procesador ?? "Sin CPU"} | ${eq.memoriaRam ?? "Sin RAM"} | ${eq.almacenamiento ?? "Sin Disco"}',
                                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: _buildEstadoBadge(eq.estadoEquipo),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton.icon(
                                        onPressed: () => _abrirHojaDeVida(eq),
                                        icon: const Icon(Icons.history_edu, size: 16),
                                        label: const Text('Hoja de Vida', style: TextStyle(fontSize: 12)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue.shade50,
                                          foregroundColor: SantiConstants.primaryBlue,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        ),
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
        ),
      ),
    );
  }

  Widget _buildCounterCard(String title, String count, IconData icon, Color color, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDeviceIcon(String tipo) {
    IconData icon = Icons.laptop;
    if (tipo.contains('Torre') || tipo.contains('Mesa')) icon = Icons.desktop_windows;
    if (tipo.contains('Todo en Uno') || tipo.contains('AIO')) icon = Icons.tv;
    if (tipo.contains('Servidor')) icon = Icons.dns;
    if (tipo.contains('Impresora')) icon = Icons.print;
    return Icon(icon, color: SantiConstants.primaryBlue, size: 22);
  }

  Widget _buildEstadoBadge(String estado) {
    Color bg;
    Color fg;
    String label;

    switch (estado) {
      case 'OPERATIVO':
        bg = Colors.green.shade50;
        fg = Colors.green.shade800;
        label = 'OPERATIVO';
        break;
      case 'EN_TALLER':
        bg = Colors.amber.shade50;
        fg = Colors.amber.shade900;
        label = 'EN TALLER';
        break;
      case 'DE_BAJA':
        bg = Colors.red.shade50;
        fg = Colors.red.shade800;
        label = 'DADO DE BAJA';
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade800;
        label = estado;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}

// ==================== MODAL HOJA DE VIDA CLÍNICA ====================
class _HojaVidaDialog extends ConsumerStatefulWidget {
  final Equipo equipo;
  final VoidCallback onEstadoCambiado;

  const _HojaVidaDialog({
    required this.equipo,
    required this.onEstadoCambiado,
  });

  @override
  ConsumerState<_HojaVidaDialog> createState() => _HojaVidaDialogState();
}

class _HojaVidaDialogState extends ConsumerState<_HojaVidaDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Orden> _historial = [];
  bool _cargandoHistorial = true;
  late String _estadoActual;
  bool _actualizandoEstado = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _estadoActual = widget.equipo.estadoEquipo;
    _cargarHistorial();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cargarHistorial() async {
    final repo = ref.read(ordenesRepositoryProvider);
    if (widget.equipo.id != null) {
      final h = await repo.getHistorialEquipo(widget.equipo.id!);
      if (mounted) {
        setState(() {
          _historial = h;
          _cargandoHistorial = false;
        });
      }
    }
  }

  Future<void> _cambiarEstado(String nuevoEstado) async {
    if (widget.equipo.id == null) return;
    setState(() => _actualizandoEstado = true);
    final repo = ref.read(ordenesRepositoryProvider);
    await repo.updateEstadoEquipo(widget.equipo.id!, nuevoEstado);
    if (mounted) {
      setState(() {
        _estadoActual = nuevoEstado;
        _actualizandoEstado = false;
      });
      widget.onEstadoCambiado();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estado del equipo actualizado a $nuevoEstado'),
          backgroundColor: SantiConstants.successGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final eq = widget.equipo;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 750,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.history_edu, color: SantiConstants.primaryBlue, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hoja de Vida Clínica: ${eq.marca} ${eq.modelo}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy),
                      ),
                      Text('Serial: ${eq.numeroSerie} | Tipo: ${eq.tipoEquipo}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                // Selector de estado rápido
                if (_actualizandoEstado)
                  const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  DropdownButton<String>(
                    value: _estadoActual,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'OPERATIVO', child: Text('🟢 Operativo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                      DropdownMenuItem(value: 'EN_TALLER', child: Text('🟡 En Taller', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                      DropdownMenuItem(value: 'DE_BAJA', child: Text('🔴 Dado de Baja', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                    ],
                    onChanged: (v) {
                      if (v != null && v != _estadoActual) {
                        _cambiarEstado(v);
                      }
                    },
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tab bar
            TabBar(
              controller: _tabController,
              labelColor: SantiConstants.primaryBlue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: SantiConstants.primaryBlue,
              tabs: const [
                Tab(icon: Icon(Icons.receipt_long, size: 18), text: 'Historial de Mantenimientos / Tickets'),
                Tab(icon: Icon(Icons.memory, size: 18), text: 'Ficha Técnica de Hardware'),
              ],
            ),
            const SizedBox(height: 16),

            // Tab View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Historial
                  _cargandoHistorial
                      ? const Center(child: CircularProgressIndicator())
                      : _historial.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline, size: 48, color: Colors.grey.shade400),
                                  const SizedBox(height: 10),
                                  const Text('Este equipo no registra intervenciones o fallas previas.', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: _historial.length,
                              separatorBuilder: (_, _) => const Divider(height: 1),
                              itemBuilder: (context, i) {
                                final ord = _historial[i];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  leading: CircleAvatar(
                                    backgroundColor: ord.tipoServicio == 'PREVENTIVO' ? Colors.green.shade50 : Colors.blue.shade50,
                                    child: Icon(
                                      ord.tipoServicio == 'PREVENTIVO' ? Icons.cleaning_services : Icons.build,
                                      color: ord.tipoServicio == 'PREVENTIVO' ? Colors.green : Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(ord.codigoOrden, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(ord.estado, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(ord.titulo, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                      Text(
                                        'Fecha: ${ord.fechaIngreso.day}/${ord.fechaIngreso.month}/${ord.fechaIngreso.year} | Tipo: ${ord.tipoServicio} | Falla: ${ord.categoriaFalla}',
                                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios, size: 14),
                                    onPressed: () {
                                      if (ord.id != null) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => DetalleTallerScreen(ordenId: ord.id!),
                                          ),
                                        );
                                      }
                                    },
                                    tooltip: 'Ver detalle de la orden',
                                  ),
                                );
                              },
                            ),

                  // Tab 2: Ficha Técnica
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildSpecRow('Sistema Operativo', eq.sistemaOperativo ?? 'No especificado', Icons.laptop_windows),
                          _buildSpecRow('Procesador (CPU)', eq.procesador ?? 'No especificado', Icons.developer_board),
                          _buildSpecRow('Memoria RAM', eq.memoriaRam ?? 'No especificado', Icons.memory),
                          _buildSpecRow('Disco / Almacenamiento', eq.almacenamiento ?? 'No especificado', Icons.storage),
                          _buildSpecRow('Tarjeta Gráfica (GPU)', eq.tarjetaGrafica ?? 'Integrada / Estándar', Icons.videogame_asset),
                          _buildSpecRow('Tipo de Chasis', eq.tipoEquipo, Icons.computer),
                          _buildSpecRow('Marca y Modelo', '${eq.marca} ${eq.modelo}', Icons.branding_watermark),
                          _buildSpecRow('Número de Serie', eq.numeroSerie, Icons.qr_code),
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
    );
  }

  Widget _buildSpecRow(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: SantiConstants.primaryBlue, size: 20),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF475569))),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
          ),
        ],
      ),
    );
  }
}
