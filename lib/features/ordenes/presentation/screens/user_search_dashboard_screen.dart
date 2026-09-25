import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/entities/equipo.dart';
import '../../domain/entities/orden.dart';
import '../providers/ordenes_providers.dart';
import '../widgets/status_badge.dart';
import 'detalle_taller_screen.dart';
import 'documento_oficial_screen.dart';

class UserSearchDashboardScreen extends ConsumerStatefulWidget {
  final String? initialDocumento;

  const UserSearchDashboardScreen({super.key, this.initialDocumento});

  @override
  ConsumerState<UserSearchDashboardScreen> createState() => _UserSearchDashboardScreenState();
}

class _UserSearchDashboardScreenState extends ConsumerState<UserSearchDashboardScreen> with SingleTickerProviderStateMixin {
  final _docCtrl = TextEditingController();
  late TabController _tabController;

  bool _buscando = false;
  Cliente? _clienteEncontrado;
  List<Equipo> _equipos = [];
  List<Orden> _historialOrdenes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.initialDocumento != null && widget.initialDocumento!.isNotEmpty) {
      _docCtrl.text = widget.initialDocumento!;
      _buscarCliente();
    }
  }

  @override
  void dispose() {
    _docCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _buscarCliente() async {
    final doc = _docCtrl.text.trim();
    if (doc.isEmpty) return;

    setState(() => _buscando = true);

    final repo = ref.read(ordenesRepositoryProvider);
    final cliente = await repo.findClienteByDocumento(doc);

    if (cliente != null && cliente.id != null) {
      final equipos = await repo.getEquiposByClienteId(cliente.id!);
      final ordenes = await repo.getOrdenesByClienteId(cliente.id!);

      setState(() {
        _clienteEncontrado = cliente;
        _equipos = equipos;
        _historialOrdenes = ordenes;
        _buscando = false;
      });
    } else {
      setState(() {
        _clienteEncontrado = null;
        _equipos = [];
        _historialOrdenes = [];
        _buscando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró ningún cliente registrado con este documento.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Búsqueda de Historial de Clientes & Equipos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Ingrese el documento de identidad o NIT para consultar la hoja de vida técnica de todos sus equipos y órdenes de servicio.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Buscador
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _docCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Documento de Identidad / NIT del Cliente',
                        prefixIcon: Icon(Icons.search),
                        hintText: 'ej. 901442112 o 1020304050',
                      ),
                      onFieldSubmitted: (_) => _buscarCliente(),
                    ),
                  ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _buscando ? null : _buscarCliente,
                        icon: _buscando
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.person_search),
                        label: const Text('Consultar Cliente'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SantiConstants.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Ficha del Cliente y Pestañas
                if (_clienteEncontrado != null) ...[
                  // Perfil del Cliente
                  Container(
                    padding: const EdgeInsets.all(20),
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
                              radius: 24,
                              backgroundColor: SantiConstants.primaryBlue.withOpacity(0.12),
                              child: const Icon(Icons.person, color: SantiConstants.primaryBlue, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _clienteEncontrado!.nombreCompleto,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy),
                                  ),
                                  Text(
                                    '${_clienteEncontrado!.tipoDocumento}: ${_clienteEncontrado!.numeroDocumento} • Tel: ${_clienteEncontrado!.telefono}',
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
                              child: Text('${_equipos.length} Equipos Registrados', style: const TextStyle(color: SantiConstants.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(_clienteEncontrado!.direccion, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                            const SizedBox(width: 16),
                            Icon(Icons.email_outlined, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(_clienteEncontrado!.email ?? 'Sin correo electrónico', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // TabBar: Equipos Vinculados vs Historial
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          labelColor: SantiConstants.primaryBlue,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: SantiConstants.primaryBlue,
                          tabs: [
                            Tab(icon: const Icon(Icons.devices), text: 'Equipos Vinculados (${_equipos.length})'),
                            Tab(icon: const Icon(Icons.history), text: 'Historial de Mantenimientos (${_historialOrdenes.length})'),
                          ],
                        ),
                        SizedBox(
                          height: 400,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Pestaña 1: Equipos
                              _equipos.isEmpty
                                  ? const Center(child: Text('No hay computadores registrados para este cliente.'))
                                  : ListView.separated(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: _equipos.length,
                                      separatorBuilder: (_, __) => const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final eq = _equipos[index];
                                        return ListTile(
                                          leading: const Icon(Icons.computer, color: SantiConstants.primaryBlue, size: 28),
                                          title: Text('${eq.marca} ${eq.modelo} (${eq.tipoEquipo})', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          subtitle: Text('S/N: ${eq.numeroSerie} • CPU: ${eq.procesador ?? 'N/A'} • RAM: ${eq.memoriaRam ?? 'N/A'}'),
                                          trailing: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: eq.estadoEquipo == 'OPERATIVO'
                                                  ? Colors.green.shade50
                                                  : eq.estadoEquipo == 'EN_TALLER'
                                                      ? Colors.amber.shade50
                                                      : Colors.red.shade50,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              eq.estadoEquipo.replaceAll('_', ' '),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: eq.estadoEquipo == 'OPERATIVO'
                                                    ? Colors.green.shade800
                                                    : eq.estadoEquipo == 'EN_TALLER'
                                                        ? Colors.amber.shade900
                                                        : Colors.red.shade800,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                              // Pestaña 2: Historial
                              _historialOrdenes.isEmpty
                                  ? const Center(child: Text('No hay órdenes registradas para los equipos de este cliente.'))
                                  : ListView.separated(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: _historialOrdenes.length,
                                      separatorBuilder: (_, __) => const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final o = _historialOrdenes[index];
                                        return ListTile(
                                          leading: StatusBadge(status: o.estado),
                                          title: Text(
                                            '${o.codigoOrden}: ${o.titulo}',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            '${o.tipoServicio} • Equipo: ${o.equipo?.marca ?? ''} ${o.equipo?.modelo ?? ''} • Fecha: ${DateFormat('dd/MM/yyyy').format(o.fechaIngreso)}',
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.handyman, size: 20, color: SantiConstants.primaryBlue),
                                                tooltip: 'Gestionar Taller',
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(builder: (_) => DetalleTallerScreen(ordenId: o.id!)),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.picture_as_pdf, size: 20, color: Colors.red),
                                                tooltip: 'Documento Oficial',
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(builder: (_) => DocumentoOficialScreen(ordenId: o.id!)),
                                                  );
                                                },
                                              ),
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
                  ),
                ],
              ],
            ),
          ),
        );
  }
}
