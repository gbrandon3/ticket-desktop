import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickets_app/main.dart';
import 'package:tickets_app/features/ordenes/presentation/screens/crear_incidencia_screen.dart';
import 'package:tickets_app/features/ordenes/presentation/screens/consulta_publica_screen.dart';
import 'package:tickets_app/features/ordenes/presentation/screens/login_screen.dart';
import 'package:tickets_app/features/ordenes/presentation/screens/configuracion_page_screen.dart';
import 'package:tickets_app/features/ordenes/presentation/widgets/sidebar_widget.dart';
import 'package:tickets_app/features/ordenes/domain/entities/usuario.dart';
import 'package:tickets_app/features/ordenes/domain/repositories/i_ordenes_repository.dart';
import 'package:tickets_app/features/ordenes/presentation/providers/auth_provider.dart';
import 'package:tickets_app/features/ordenes/presentation/providers/ordenes_providers.dart';
import 'package:tickets_app/features/ordenes/presentation/screens/detalle_taller_screen.dart';
import 'package:tickets_app/features/ordenes/presentation/screens/admin_dashboard_screen.dart';
import 'package:tickets_app/features/ordenes/presentation/screens/setup_wizard_screen.dart';
import 'package:tickets_app/core/routes/app_router.dart';

import 'package:tickets_app/features/ordenes/domain/entities/orden.dart';
import 'package:tickets_app/features/ordenes/domain/entities/formato_ot.dart';
import 'package:tickets_app/features/ordenes/domain/entities/formato_actividades.dart';
import 'package:tickets_app/features/ordenes/domain/entities/repuesto.dart';
import 'package:tickets_app/features/ordenes/domain/entities/foto_evidencia.dart';
import 'package:tickets_app/features/ordenes/domain/entities/formato_acta_entrega.dart';
import 'package:tickets_app/features/ordenes/domain/entities/empresa_config.dart';
import 'package:tickets_app/features/ordenes/domain/entities/notificacion_auditoria.dart';

class _FakeAuthNotifier extends AuthNotifier {
  final Usuario? _initialUser;
  _FakeAuthNotifier([this._initialUser]);

  @override
  Usuario? build() => _initialUser;
}

class _MockLoginRepository extends Fake implements IOrdenesRepository {
  @override
  Future<void> seedTestUsers() async {}

  @override
  Future<Usuario?> login(String email, String password) async => null;
}

class _MockTallerRepository extends Fake implements IOrdenesRepository {
  final String estado;
  _MockTallerRepository({this.estado = 'EN_TALLER'});

  @override
  Future<Orden?> getOrdenById(int id) async {
    return Orden(
      id: id,
      codigoOrden: 'ORD-2026-0001',
      clienteId: 1,
      equipoId: 1,
      tipoServicio: 'PREVENTIVO',
      categoriaFalla: 'HARDWARE',
      prioridad: 'MEDIA',
      titulo: 'Mantenimiento General',
      descripcion: 'Limpieza preventiva',
      estado: estado,
      fechaIngreso: DateTime.now(),
    );
  }

  @override
  Future<FormatoOt?> getFormatoOt(int ordenId) async => null;

  @override
  Future<FormatoActividades?> getFormatoActividades(int ordenId) async => null;

  @override
  Future<List<Repuesto>> getRepuestos(int ordenId) async => [];

  @override
  Future<List<FotoEvidencia>> getFotosEvidencia(int ordenId) async => [];

  @override
  Future<FormatoActaEntrega?> getActaEntrega(int ordenId) async => null;
}

class _MockDashboardRepository extends Fake implements IOrdenesRepository {
  @override
  Future<Map<String, dynamic>> getAdminMetrics() async => {
        'total': 0,
        'vencidos': 0,
        'sinAsignar': 0,
        'preventivos': 0,
        'correctivos': 0,
        'tiempoPromedioHoras': 0.0,
        'cargaTecnicos': <Map<String, dynamic>>[],
      };

  @override
  Future<List<Usuario>> getUsuarios({String? rol}) async => [];

  @override
  Future<List<NotificacionAuditoria>> getAuditoriaNotificaciones() async => [];

  @override
  Stream<List<Orden>> watchOrdenes({String? busqueda, String? estado, String? tipo, int? tecnicoId, int? solicitanteId}) => Stream.value([]);

  @override
  Future<int> countTiposFalla() async => 0;

  @override
  Stream<EmpresaConfig> watchEmpresaConfig() => Stream.value(const EmpresaConfig.defaultConfig());

  @override
  Future<EmpresaConfig> getEmpresaConfig() async => const EmpresaConfig.defaultConfig();

  @override
  Future<Map<String, dynamic>> consultarPublico(String query) async => {'tipo': 'no_encontrado'};
}

void main() {
  testWidgets('Carga inicial y prueba de hitTest con puntero/mouse', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SantiIncApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(SantiIncApp), findsOneWidget);

    // Simular movimiento de puntero (mouse hover / hitTest) en múltiples coordenadas
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: const Offset(100, 100));
    await tester.pump();
    await gesture.moveTo(const Offset(300, 200));
    await tester.pump();
    await gesture.moveTo(const Offset(500, 400));
    await tester.pump();
    await gesture.removePointer();
  });

  testWidgets('CrearIncidenciaScreen se renderiza y responde a eventos sin errores de hitTest', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CrearIncidenciaScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Abrir Nueva Orden de Mantenimiento'), findsWidgets);
    expect(find.text('Paso 1: Buscar y Elegir Cliente Receptor'), findsOneWidget);

    // Hit test mouse hover
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: const Offset(150, 150));
    await tester.pump();
    await gesture.moveTo(const Offset(400, 300));
    await tester.pump();
    await gesture.removePointer();
  });

  testWidgets('ConsultaPublicaScreen se renderiza correctamente con su buscador único', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ConsultaPublicaScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Portal de Consulta y Trazabilidad'), findsOneWidget);
    expect(find.text('Consultar'), findsOneWidget);
  });

  testWidgets('LoginScreen inicia con campos limpios y sin selector de usuarios de prueba', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('Usuarios de Prueba (Clic para autocompletar):'), findsNothing);
    expect(find.text('admin@taller.com'), findsNothing);
  });

  testWidgets('SidebarWidget muestra botón atajo + Nueva Incidencia y rol OPERADOR (TRABAJADOR)', (WidgetTester tester) async {
    const usuarioOperador = Usuario(
      id: 2,
      nombre: 'Laura Gómez',
      email: 'operador@taller.com',
      password: '123',
      documento: '1098765432',
      telefono: '3154567890',
      rol: 'solicitante', // operador worker
      activo: true,
    );

    String? itemSeleccionado;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SidebarWidget(
              usuario: usuarioOperador,
              activeItem: 'taller',
              onSelect: (id) => itemSeleccionado = id,
              onLogout: () {},
              onConsultaPublica: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Validar insignia de trabajador
    expect(find.text('OPERADOR (TRABAJADOR)'), findsOneWidget);

    // Validar botón de atajo
    final shortcutBtn = find.text('+ Nueva Incidencia / OT');
    expect(shortcutBtn, findsOneWidget);

    // Clic en el botón de atajo
    await tester.tap(shortcutBtn);
    expect(itemSeleccionado, equals('crear_incidencia'));
  });

  testWidgets('ConfiguracionPageScreen oculta Identidad Corporativa y Gestión de Usuarios para operador/técnico', (WidgetTester tester) async {
    const usuarioTecnico = Usuario(
      id: 3,
      nombre: 'Carlos Mendoza',
      email: 'tecnico@taller.com',
      password: '123',
      documento: '79854123',
      telefono: '3209876543',
      rol: 'tecnico',
      activo: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => _FakeAuthNotifier(usuarioTecnico)),
        ],
        child: const MaterialApp(
          home: ConfiguracionPageScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Solo debe tener "Mi Perfil"
    expect(find.text('Mi Perfil'), findsOneWidget);
    expect(find.text('Tema Visual'), findsNothing);

    // NO debe aparecer "Identidad Corporativa", "Gestión de Usuarios" ni "Tema Visual"
    expect(find.text('Identidad Corporativa'), findsNothing);
    expect(find.text('Gestión de Usuarios'), findsNothing);
    expect(find.text('Servidor SMTP'), findsNothing);
    expect(find.text('Fallas & Diagnósticos'), findsNothing);
  });

  testWidgets('LoginScreen muestra error explícito ante credenciales incorrectas', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ordenesRepositoryProvider.overrideWithValue(_MockLoginRepository()),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Ingresar credenciales inválidas
    await tester.enterText(find.byType(TextFormField).first, 'usuario_falso@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'clave_incorrecta_999');
    await tester.pump();

    // Presionar Iniciar Sesión
    final loginBtn = find.widgetWithText(ElevatedButton, 'Iniciar Sesión');
    await tester.ensureVisible(loginBtn);
    await tester.tap(loginBtn);

    await tester.pumpAndSettle();

    // Debe mostrar mensaje de error en pantalla
    expect(find.textContaining('Credenciales no válidas'), findsWidgets);
  });

  testWidgets('CrearIncidenciaScreen inicia con campos de especificaciones vacíos y HomeScreen tiene vista de tabla', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CrearIncidenciaScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(CrearIncidenciaScreen), findsOneWidget);
  });

  testWidgets('Técnico no ve opciones para crear incidencias en sidebar ni header', (WidgetTester tester) async {
    const usuarioTecnico = Usuario(
      id: 2,
      nombre: 'Carlos Mendoza',
      email: 'tecnico@taller.com',
      password: '123',
      documento: '79854123',
      telefono: '3209876543',
      rol: 'tecnico',
      activo: true,
    );

    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => _FakeAuthNotifier(usuarioTecnico)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SidebarWidget(
              usuario: usuarioTecnico,
              activeItem: 'taller',
              onSelect: (_) {},
              onLogout: () {},
              onConsultaPublica: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Validar que NO existe el botón de atajo ni la opción de menú de crear incidencia
    expect(find.text('+ Nueva Incidencia / OT'), findsNothing);
    expect(find.text('Ingreso de Equipo'), findsNothing);
    expect(find.text('Crear Incidencia / OT'), findsNothing);

    // Debe ver su taller y su dashboard técnico
    expect(find.text('Dashboard Técnico'), findsOneWidget);
    expect(find.text('Taller Técnico SENA'), findsOneWidget);
  });

  testWidgets('DetalleTallerScreen tiene 3 pestañas, integra evidencias en OT y bloquea edición cuando está cerrada', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // 1. Probar orden abierta en taller
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ordenesRepositoryProvider.overrideWithValue(_MockTallerRepository(estado: 'EN_TALLER')),
        ],
        child: const MaterialApp(
          home: DetalleTallerScreen(ordenId: 1),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Validar las 3 pestañas (la pestaña separada de Evidencias ya no existe)
    expect(find.text('1. Orden de Trabajo & Evidencias'), findsOneWidget);
    expect(find.text('2. Bitácora & Insumos'), findsOneWidget);
    expect(find.text('3. Acta de Entrega'), findsOneWidget);
    expect(find.text('4. Acta de Entrega'), findsNothing);

    // Validar que la sección de evidencias fotográficas está dentro de la orden de trabajo
    expect(find.text('Evidencias Fotográficas de la Orden'), findsOneWidget);
    expect(find.text('Cargar Evidencia'), findsOneWidget);
    expect(find.text('Guardar Formato de Orden de Trabajo'), findsOneWidget);

    // 2. Probar orden cerrada (ENTREGADO_CERRADO)
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ordenesRepositoryProvider.overrideWithValue(_MockTallerRepository(estado: 'ENTREGADO_CERRADO')),
        ],
        child: const MaterialApp(
          home: DetalleTallerScreen(key: ValueKey('cerrada'), ordenId: 2),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Debe mostrar banner de modo solo lectura
    expect(find.textContaining('ORDEN FINALIZADA Y ENTREGADA'), findsOneWidget);
    // Botón de guardar OT debe estar reemplazado por botón de lectura
    expect(find.text('Guardar Formato de Orden de Trabajo'), findsNothing);
    expect(find.text('Cargar Evidencia'), findsNothing);
  });

  testWidgets('DetalleTallerScreen contiene protocolo de pruebas de diagnóstico pre-entrega (CrystalDiskInfo, HWMonitor, MemTest)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ordenesRepositoryProvider.overrideWithValue(_MockTallerRepository()),
        ],
        child: const MaterialApp(
          home: DetalleTallerScreen(ordenId: 1),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Tap en Tab 2 (Bitácora & Insumos)
    await tester.tap(find.text('2. Bitácora & Insumos'));
    await tester.pumpAndSettle();

    // Validar presencia del protocolo y de las herramientas solicitadas por el usuario
    expect(find.text('Protocolo de Pruebas de Diagnóstico y Salud Pre-Entrega'), findsOneWidget);
    expect(find.textContaining('CrystalDiskInfo'), findsWidgets);
    expect(find.textContaining('HWMonitor'), findsWidgets);
    expect(find.textContaining('MemTest86'), findsWidgets);
    expect(find.textContaining('FurMark'), findsWidgets);
    expect(find.textContaining('BatteryBar'), findsWidgets);

    // Tap en Tab 3 (Acta de Entrega)
    await tester.tap(find.text('3. Acta de Entrega'));
    await tester.pumpAndSettle();

    // Validar presencia de la certificación de pruebas pre-entrega
    expect(find.text('Certificación de Pruebas de Diagnóstico y Funcionamiento Pre-Entrega'), findsOneWidget);
  });

  testWidgets('Admin puede ver y gestionar el Catálogo de Tipos de Falla y Diagnósticos en Configuración', (WidgetTester tester) async {
    const usuarioAdmin = Usuario(
      id: 1,
      nombre: 'Administrador Principal',
      email: 'admin@taller.com',
      password: '123',
      documento: '10203040',
      telefono: '3001234567',
      rol: 'admin',
      activo: true,
    );

    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => _FakeAuthNotifier(usuarioAdmin)),
        ],
        child: const MaterialApp(
          home: ConfiguracionPageScreen(initialTabIndex: 5),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Fallas & Diagnósticos'), findsOneWidget);
    expect(find.textContaining('Administración de Tipos de Falla'), findsWidgets);
    expect(find.textContaining('Tipos de Falla - Mantenimiento Correctivo'), findsOneWidget);
    expect(find.textContaining('Mantenimiento Preventivo'), findsWidgets);
    expect(find.textContaining('No hay tipos de falla registrados'), findsWidgets);
    expect(find.textContaining('Protocolo de Pruebas de Diagnóstico'), findsNothing);
  });

  testWidgets('13. SetupWizardScreen no incluye slogan ni selector de color de PDF al inicio', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SetupWizardScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Asistente de Configuración Inicial'), findsOneWidget);
    expect(find.textContaining('Slogan o Lema'), findsNothing);
    expect(find.textContaining('Color de Acento en Actas y Documentos PDF'), findsNothing);
  });

  testWidgets('14. AdminDashboardScreen muestra apartado de anuncios de puesta en marcha', (tester) async {
    const usuarioAdmin = Usuario(
      id: 1,
      nombre: 'Administrador Principal',
      email: 'admin@taller.com',
      password: '123',
      documento: '10203040',
      telefono: '3001234567',
      rol: 'admin',
      activo: true,
    );

    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => _FakeAuthNotifier(usuarioAdmin)),
          ordenesRepositoryProvider.overrideWithValue(_MockDashboardRepository()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: AdminDashboardScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Puesta en Marcha y Configuración Inicial'), findsOneWidget);
    expect(find.textContaining('Tipos de Falla'), findsWidgets);
    expect(find.textContaining('Crear Personal Técnico'), findsOneWidget);
    expect(find.textContaining('Configurar Envío de Emails'), findsNothing);
    expect(find.text('Crear Tipo de Falla'), findsOneWidget);
  });

  testWidgets('15. Enrutamiento por URL navega correctamente con GoRouter', (tester) async {
    const usuarioAdmin = Usuario(
      id: 1,
      nombre: 'Administrador Principal',
      email: 'admin@taller.com',
      password: '123',
      documento: '10203040',
      telefono: '3001234567',
      rol: 'admin',
      activo: true,
    );

    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final container = ProviderContainer(
      overrides: [
        setupCompletedProvider.overrideWith((ref) => Future.value(true)),
        authProvider.overrideWith(() => _FakeAuthNotifier(usuarioAdmin)),
        ordenesRepositoryProvider.overrideWithValue(_MockDashboardRepository()),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Ruta por defecto debe redirigir a /dashboard
    expect(find.textContaining('Panel de Control & Supervisión Administrativa'), findsOneWidget);

    // Navegar por URL a /configuracion?tab=3 (SMTP)
    router.go('/configuracion?tab=3');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Parámetros de Servidor SMTP'), findsOneWidget);

    // Navegar por URL a /consulta pública
    router.go('/consulta');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Portal de Consulta y Trazabilidad'), findsOneWidget);
  });
}

