import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/santi_constants.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

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
    final router = ref.watch(appRouterProvider);
    final themeState = ref.watch(appThemeNotifierProvider);

    return MaterialApp.router(
      title: SantiConstants.appName,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      theme: AppTheme.buildTheme(
        primary: themeState.primaryColor,
        header: themeState.headerColor,
      ),
      routerConfig: router,
    );
  }
}
