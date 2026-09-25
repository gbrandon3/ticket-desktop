import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/santi_constants.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/ordenes/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SantiIncApp(),
    ),
  );
}

class SantiIncApp extends ConsumerStatefulWidget {
  const SantiIncApp({super.key});

  @override
  ConsumerState<SantiIncApp> createState() => _SantiIncAppState();
}

class _SantiIncAppState extends ConsumerState<SantiIncApp> {
  @override
  void initState() {
    super.initState();
    _seedInitialDataIfNeeded();
  }

  Future<void> _seedInitialDataIfNeeded() async {
    // La base de datos inicia limpia sin órdenes de prueba simuladas.
    // El flujo comienza con el Asistente de Configuración Inicial (Setup Wizard).
  }

  @override
  Widget build(BuildContext context) {
    final setupAsync = ref.watch(setupCompletedProvider);
    final themeState = ref.watch(appThemeNotifierProvider);

    return setupAsync.when(
      data: (_) {
        final router = ref.watch(appRouterProvider);
        return MaterialApp.router(
          title: SantiConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.buildTheme(
            primary: themeState.primaryColor,
            header: themeState.headerColor,
          ),
          routerConfig: router,
        );
      },
      loading: () => MaterialApp(
        title: SantiConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.buildTheme(
          primary: themeState.primaryColor,
          header: themeState.headerColor,
        ),
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (err, stack) => MaterialApp(
        title: SantiConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.buildTheme(
          primary: themeState.primaryColor,
          header: themeState.headerColor,
        ),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text('Error cargando inicialización: $err'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(setupCompletedProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
