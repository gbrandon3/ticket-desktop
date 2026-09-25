import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/usuario.dart';
import '../providers/auth_provider.dart';
import '../providers/ordenes_providers.dart';
import '../widgets/banner_alerta_smtp.dart';
import '../widgets/sidebar_widget.dart';
import 'admin_dashboard_screen.dart';
import 'configuracion_page_screen.dart';
import 'consulta_publica_screen.dart';
import 'crear_incidencia_screen.dart';
import 'home_screen.dart';
import 'inventario_equipos_screen.dart';
import 'solicitante_dashboard_screen.dart';
import 'user_search_dashboard_screen.dart';

class AppShell extends ConsumerStatefulWidget {
  final Usuario usuario;
  final Widget? child;

  const AppShell({super.key, required this.usuario, this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  late String _activeItem;
  int _configTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _activeItem = _getDefaultItemForRole(widget.usuario.rol);
  }

  String _getDefaultItemForRole(String rol) {
    switch (rol) {
      case 'admin':
      case 'tecnico':
      case 'operador':
      case 'solicitante':
        return 'admin_dashboard';
      case 'cliente':
        return 'solicitante_dashboard';
      default:
        return 'admin_dashboard';
    }
  }

  String _getActiveItemFromLocation(String location) {
    if (location.startsWith('/dashboard')) return 'admin_dashboard';
    if (location.startsWith('/taller')) return 'taller';
    if (location.startsWith('/crear-incidencia')) return 'crear_incidencia';
    if (location.startsWith('/inventario')) return 'inventario';
    if (location.startsWith('/clientes')) return 'usuarios_clientes';
    if (location.startsWith('/solicitante')) return 'solicitante_dashboard';
    if (location.startsWith('/configuracion')) return 'configuracion';
    return _activeItem;
  }

  void _irAConfiguracionSmtp() {
    if (GoRouter.maybeOf(context) != null) {
      context.go('/configuracion?tab=3');
    } else {
      setState(() {
        _activeItem = 'configuracion';
        _configTabIndex = 3; // Pestaña Servidor SMTP
      });
    }
  }

  Widget _buildBody() {
    if (widget.child != null) {
      return widget.child!;
    }
    switch (_activeItem) {
      case 'admin_dashboard':
        return const AdminDashboardScreen();
      case 'taller':
        return const HomeScreen();
      case 'crear_incidencia':
        if (widget.usuario.rol == 'tecnico' || widget.usuario.rol == 'cliente') {
          return const HomeScreen();
        }
        return CrearIncidenciaScreen(
          onOrdenCreada: () {
            setState(() {
              _activeItem = widget.usuario.rol == 'admin' ? 'admin_dashboard' : 'taller';
            });
          },
        );
      case 'inventario':
        return const InventarioEquiposScreen();
      case 'usuarios_clientes':
        return const UserSearchDashboardScreen();
      case 'solicitante_dashboard':
        return SolicitanteDashboardScreen(usuario: widget.usuario);
      case 'configuracion':
        return ConfiguracionPageScreen(initialTabIndex: _configTabIndex);
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final empresaAsync = ref.watch(empresaConfigStreamProvider);
    final empresa = empresaAsync.asData?.value;
    final faltaSmtp = empresa != null && (empresa.smtpUser == null || empresa.smtpUser!.trim().isEmpty);

    final isWideScreen = MediaQuery.of(context).size.width >= 900;

    final activeItem = GoRouter.maybeOf(context) != null
        ? _getActiveItemFromLocation(GoRouterState.of(context).uri.path)
        : _activeItem;

    final sidebar = SidebarWidget(
      usuario: widget.usuario,
      activeItem: activeItem,
      onSelect: (itemId) {
        if (GoRouter.maybeOf(context) != null) {
          switch (itemId) {
            case 'admin_dashboard':
              context.go('/dashboard');
              break;
            case 'taller':
              context.go('/taller');
              break;
            case 'crear_incidencia':
              context.go('/crear-incidencia');
              break;
            case 'inventario':
              context.go('/inventario');
              break;
            case 'usuarios_clientes':
              context.go('/clientes');
              break;
            case 'solicitante_dashboard':
              context.go('/solicitante');
              break;
            case 'configuracion':
              context.go('/configuracion');
              break;
          }
        } else {
          setState(() {
            _activeItem = itemId;
            _configTabIndex = 0;
          });
        }
        if (!isWideScreen) {
          Navigator.of(context).pop(); // Cerrar drawer si está en móvil
        }
      },
      onLogout: () {
        ref.read(authProvider.notifier).logout();
        if (GoRouter.maybeOf(context) != null) {
          context.go('/login');
        }
      },
      onConsultaPublica: () {
        if (GoRouter.maybeOf(context) != null) {
          context.push('/consulta');
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ConsultaPublicaScreen()),
          );
        }
      },
    );

    return Scaffold(
      drawer: isWideScreen ? null : Drawer(child: sidebar),
      body: Row(
        children: [
          if (isWideScreen) sidebar,
          Expanded(
            child: Column(
              children: [
                // Banner superior de alerta SMTP si no está configurado (visible en todas las pantallas)
                if (faltaSmtp)
                  BannerAlertaSmtp(
                    onConfigurarSmtp: () {
                      if (widget.usuario.rol == 'admin') {
                        _irAConfiguracionSmtp();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Comuníquese con un Administrador para configurar las credenciales del servidor SMTP.'),
                            backgroundColor: Color(0xFFD97706),
                          ),
                        );
                      }
                    },
                  ),

                // Contenido dinámico principal
                Expanded(
                  child: _buildBody(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
