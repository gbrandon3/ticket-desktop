import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/usuario.dart';
import '../providers/ordenes_providers.dart';

class SidebarItem {
  final String id;
  final String label;
  final IconData icon;

  const SidebarItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class SidebarWidget extends ConsumerWidget {
  final Usuario usuario;
  final String activeItem;
  final ValueChanged<String> onSelect;
  final VoidCallback onLogout;
  final VoidCallback onConsultaPublica;

  const SidebarWidget({
    super.key,
    required this.usuario,
    required this.activeItem,
    required this.onSelect,
    required this.onLogout,
    required this.onConsultaPublica,
  });

  List<SidebarItem> _getItemsForRole(String rol) {
    switch (rol) {
      case 'admin':
        return const [
          SidebarItem(id: 'admin_dashboard', label: 'Dashboard Ejecutivo', icon: Icons.dashboard_outlined),
          SidebarItem(id: 'taller', label: 'Taller Técnico / Órdenes', icon: Icons.build_outlined),
          SidebarItem(id: 'crear_incidencia', label: 'Crear Incidencia / OT', icon: Icons.add_circle_outline),
          SidebarItem(id: 'inventario', label: 'Inventario de Equipos', icon: Icons.devices_outlined),
          SidebarItem(id: 'usuarios_clientes', label: 'Historial de Clientes', icon: Icons.person_search_outlined),
          SidebarItem(id: 'configuracion', label: 'Configuración Global', icon: Icons.settings_outlined),
        ];
      case 'tecnico':
        return const [
          SidebarItem(id: 'admin_dashboard', label: 'Dashboard Técnico', icon: Icons.dashboard_outlined),
          SidebarItem(id: 'taller', label: 'Taller Técnico SENA', icon: Icons.build_outlined),
          SidebarItem(id: 'inventario', label: 'Inventario de Equipos', icon: Icons.devices_outlined),
          SidebarItem(id: 'usuarios_clientes', label: 'Historial de Clientes', icon: Icons.person_search_outlined),
          SidebarItem(id: 'configuracion', label: 'Mi Perfil', icon: Icons.person_outline),
        ];
      case 'operador':
      case 'solicitante':
        return const [
          SidebarItem(id: 'admin_dashboard', label: 'Dashboard Taller', icon: Icons.dashboard_outlined),
          SidebarItem(id: 'taller', label: 'Taller & Órdenes', icon: Icons.build_outlined),
          SidebarItem(id: 'crear_incidencia', label: 'Crear Incidencia / OT', icon: Icons.add_circle_outline),
          SidebarItem(id: 'inventario', label: 'Inventario de Equipos', icon: Icons.devices_outlined),
          SidebarItem(id: 'usuarios_clientes', label: 'Historial de Clientes', icon: Icons.person_search_outlined),
          SidebarItem(id: 'configuracion', label: 'Mi Perfil', icon: Icons.person_outline),
        ];
      case 'cliente':
        return const [
          SidebarItem(id: 'solicitante_dashboard', label: 'Mis Equipos y Órdenes', icon: Icons.assignment_outlined),
          SidebarItem(id: 'configuracion', label: 'Mi Perfil', icon: Icons.person_outline),
        ];
      default:
        return const [
          SidebarItem(id: 'taller', label: 'Órdenes', icon: Icons.build_outlined),
        ];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final empresaAsync = ref.watch(empresaConfigStreamProvider);
    final empresa = empresaAsync.asData?.value;
    final themeState = ref.watch(appThemeNotifierProvider);
    final items = _getItemsForRole(usuario.rol);

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Slate 900
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // ==================== BRAND HEADER ====================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF1E293B)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: empresa?.logoBase64 != null
                      ? Image.memory(
                          base64Decode(empresa!.logoBase64!),
                          fit: BoxFit.contain,
                        )
                      : const Icon(Icons.build_circle, color: SantiConstants.accentCyan, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        empresa?.nombreEmpresa.isNotEmpty == true ? empresa!.nombreEmpresa : SantiConstants.appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        empresa?.slogan.isNotEmpty == true ? empresa!.slogan : SantiConstants.slogan,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==================== USUARIO PERFIL ====================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF131D31),
              border: Border(
                bottom: BorderSide(color: Color(0xFF1E293B)),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: themeState.primaryColor,
                  child: Text(
                    usuario.nombre.isNotEmpty ? usuario.nombre[0].toUpperCase() : 'U',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario.nombre,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      _buildRolBadge(usuario.rol),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==================== BOTÓN DE ATAJO: CREAR INCIDENCIA (Oculto para Técnico y Cliente) ====================
          if (usuario.rol != 'tecnico' && usuario.rol != 'cliente')
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
              child: SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: () => onSelect('crear_incidencia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeState.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: themeState.primaryColor.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  icon: const Icon(Icons.add_circle, size: 18, color: Colors.white),
                  label: const Text(
                    '+ Nueva Incidencia / OT',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

          // ==================== LISTA DE RUTAS ====================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              children: items.map((item) {
                final isSelected = activeItem == item.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: isSelected ? themeState.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      leading: Icon(
                        item.icon,
                        color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                      title: Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      onTap: () => onSelect(item.id),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // ==================== FOOTER ACTIONS ====================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF1E293B)),
              ),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: onConsultaPublica,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, color: SantiConstants.accentCyan, size: 16),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Consulta Pública',
                            style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: onLogout,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0x33B91C1C),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0x4DB91C1C)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout, color: Colors.redAccent, size: 16),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Cerrar Sesión',
                            style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
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
    );
  }

  Widget _buildRolBadge(String rol) {
    Color bg;
    Color fg;
    String label;

    switch (rol) {
      case 'admin':
        bg = const Color(0xFF581C87);
        fg = const Color(0xFFD8B4FE);
        label = 'ADMIN';
        break;
      case 'tecnico':
        bg = const Color(0xFF1E3A8A);
        fg = const Color(0xFF93C5FD);
        label = 'TÉCNICO';
        break;
      case 'operador':
      case 'solicitante':
        bg = const Color(0xFF0F766E);
        fg = const Color(0xFF99F6E4);
        label = 'OPERADOR (TRABAJADOR)';
        break;
      case 'cliente':
        bg = const Color(0xFF064E3B);
        fg = const Color(0xFFA7F3D0);
        label = 'CLIENTE';
        break;
      default:
        bg = const Color(0xFF334155);
        fg = const Color(0xFFE2E8F0);
        label = rol.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}
