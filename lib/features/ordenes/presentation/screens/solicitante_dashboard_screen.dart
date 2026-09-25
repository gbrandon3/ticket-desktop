import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../domain/entities/usuario.dart';
import '../providers/ordenes_providers.dart';
import '../widgets/status_badge.dart';
import 'crear_incidencia_screen.dart';
import 'documento_oficial_screen.dart';

class SolicitanteDashboardScreen extends ConsumerWidget {
  final Usuario usuario;

  const SolicitanteDashboardScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordenesAsync = ref.watch(filteredOrdenesStreamProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de Bienvenida y Botón de Radicar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [SantiConstants.primaryNavy, SantiConstants.primaryBlue],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido, ${usuario.nombre}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Mesa de Ayuda & Radicación de Solicitudes de Servicio Técnico',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CrearIncidenciaScreen()),
                    );
                  },
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Radicar Nueva Incidencia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SantiConstants.accentCyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tarjetas de Resumen
          ordenesAsync.when(
            data: (ordenes) {
              final misOrdenes = usuario.rol == 'solicitante'
                  ? ordenes.where((o) => o.solicitanteId == usuario.id || o.cliente?.email == usuario.email).toList()
                  : ordenes;

              final total = misOrdenes.length;
              final abiertas = misOrdenes.where((o) => o.estado != 'ENTREGADO_CERRADO').length;
              final resueltas = misOrdenes.where((o) => o.estado == 'LISTO_ENTREGA' || o.estado == 'ENTREGADO_CERRADO').length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _statCard('Total Radicadas', '$total', Icons.assignment, Colors.blue),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _statCard('En Atención / Taller', '$abiertas', Icons.build_circle, Colors.amber.shade800),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _statCard('Resueltas / Entregadas', '$resueltas', Icons.check_circle, Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Mis Solicitudes de Soporte',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SantiConstants.primaryNavy),
                  ),
                  const SizedBox(height: 12),

                  if (misOrdenes.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text('No ha radicado ninguna solicitud de soporte técnico.'),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const CrearIncidenciaScreen()),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Radicar Primer Ticket'),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: misOrdenes.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final o = misOrdenes[index];
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: SantiConstants.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.computer, color: SantiConstants.primaryBlue),
                            ),
                            title: Row(
                              children: [
                                SelectableText(o.codigoOrden, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 4),
                                Tooltip(
                                  message: 'Copiar código',
                                  child: InkWell(
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
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(Icons.copy, size: 14, color: Color(0xFF64748B)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                StatusBadge(status: o.estado),
                              ],
                            ),
                            subtitle: Text('${o.equipo?.marca ?? ''} ${o.equipo?.modelo ?? ''} • ${o.titulo}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy').format(o.fechaIngreso),
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                                  tooltip: 'Ver Documento Oficial',
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
                    ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error cargando solicitudes: $err'),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 6),
          Text(val, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
