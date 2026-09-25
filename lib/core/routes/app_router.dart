import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/ordenes/domain/entities/usuario.dart';
import '../../features/ordenes/presentation/providers/auth_provider.dart';
import '../../features/ordenes/presentation/screens/admin_dashboard_screen.dart';
import '../../features/ordenes/presentation/screens/app_shell.dart';
import '../../features/ordenes/presentation/screens/configuracion_page_screen.dart';
import '../../features/ordenes/presentation/screens/consulta_publica_screen.dart';
import '../../features/ordenes/presentation/screens/crear_incidencia_screen.dart';
import '../../features/ordenes/presentation/screens/detalle_taller_screen.dart';
import '../../features/ordenes/presentation/screens/home_screen.dart';
import '../../features/ordenes/presentation/screens/inventario_equipos_screen.dart';
import '../../features/ordenes/presentation/screens/login_screen.dart';
import '../../features/ordenes/presentation/screens/setup_wizard_screen.dart';
import '../../features/ordenes/presentation/screens/solicitante_dashboard_screen.dart';
import '../../features/ordenes/presentation/screens/user_search_dashboard_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  AppRouterNotifier(this._ref) {
    _ref.listen<Usuario?>(authProvider, (_, __) {
      notifyListeners();
    });
    _ref.listen<AsyncValue<bool>>(setupCompletedProvider, (_, __) {
      notifyListeners();
    });
  }
}

final appRouterNotifierProvider = Provider<AppRouterNotifier>((ref) {
  return AppRouterNotifier(ref);
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(appRouterNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (BuildContext context, GoRouterState state) {
      final setupAsync = ref.read(setupCompletedProvider);
      final isSetup = setupAsync.asData?.value ?? true;
      final user = ref.read(authProvider);
      final loc = state.matchedLocation;

      // 1. Si no se ha completado el setup inicial, redirigir a /setup
      if (!isSetup) {
        if (loc != '/setup') {
          return '/setup';
        }
        return null;
      }

      // Si el setup ya está listo y el usuario intenta entrar a /setup
      if (isSetup && loc == '/setup') {
        return user == null ? '/login' : ((user.rol == 'solicitante' || user.rol == 'cliente') ? '/solicitante' : '/dashboard');
      }

      // 2. Ruta pública de consulta ciudadana / seguimiento de ticket
      if (loc == '/consulta') {
        return null;
      }

      // 3. Usuario no autenticado: restringir a /login
      if (user == null) {
        if (loc != '/login') {
          return '/login';
        }
        return null;
      }

      // 4. Usuario autenticado intentando ir a /login o raíz /
      if (loc == '/login' || loc == '/') {
        return (user.rol == 'solicitante' || user.rol == 'cliente') ? '/solicitante' : '/dashboard';
      }

      // 5. Restricción por rol de solicitante
      if ((user.rol == 'solicitante' || user.rol == 'cliente') &&
          (loc == '/dashboard' ||
              loc == '/crear-incidencia' ||
              loc == '/taller' ||
              loc == '/inventario' ||
              loc == '/clientes')) {
        return '/solicitante';
      }

      return null;
    },
    routes: [
      // Rutas superiores fuera del Shell
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/setup',
        builder: (context, state) => const SetupWizardScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/consulta',
        builder: (context, state) => const ConsultaPublicaScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/ordenes/:id',
        builder: (context, state) {
          final idStr = state.pathParameters['id'];
          final id = int.tryParse(idStr ?? '') ?? 0;
          return DetalleTallerScreen(ordenId: id);
        },
      ),

      // Rutas anidadas dentro de AppShell
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          final user = ref.watch(authProvider);
          if (user == null) {
            return child;
          }
          return AppShell(
            usuario: user,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/taller',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/crear-incidencia',
            builder: (context, state) {
              final user = ref.watch(authProvider);
              if (user != null && (user.rol == 'tecnico' || user.rol == 'cliente')) {
                return const HomeScreen();
              }
              return CrearIncidenciaScreen(
                onOrdenCreada: () {
                  final current = ref.read(authProvider);
                  if (current?.rol == 'admin') {
                    context.go('/dashboard');
                  } else {
                    context.go('/taller');
                  }
                },
              );
            },
          ),
          GoRoute(
            path: '/inventario',
            builder: (context, state) => const InventarioEquiposScreen(),
          ),
          GoRoute(
            path: '/clientes',
            builder: (context, state) => const UserSearchDashboardScreen(),
          ),
          GoRoute(
            path: '/solicitante',
            builder: (context, state) {
              final user = ref.watch(authProvider);
              if (user == null) return const SizedBox.shrink();
              return SolicitanteDashboardScreen(usuario: user);
            },
          ),
          GoRoute(
            path: '/configuracion',
            builder: (context, state) {
              final tabStr = state.uri.queryParameters['tab'];
              final tabIndex = int.tryParse(tabStr ?? '0') ?? 0;
              return ConfiguracionPageScreen(initialTabIndex: tabIndex);
            },
          ),
        ],
      ),
    ],
  );
});
