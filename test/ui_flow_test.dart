import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickets_app/core/theme/app_theme.dart';
import 'package:tickets_app/features/ordenes/domain/entities/cliente.dart';
import 'package:tickets_app/features/ordenes/domain/entities/equipo.dart';
import 'package:tickets_app/features/ordenes/domain/entities/orden.dart';
import 'package:tickets_app/features/ordenes/domain/entities/usuario.dart';
import 'package:tickets_app/features/ordenes/domain/entities/empresa_config.dart';
import 'package:tickets_app/features/ordenes/domain/entities/tipo_falla.dart';
import 'package:tickets_app/features/ordenes/domain/repositories/i_ordenes_repository.dart';
import 'package:tickets_app/features/ordenes/presentation/providers/ordenes_providers.dart';
import 'package:tickets_app/features/ordenes/presentation/screens/crear_incidencia_screen.dart';
import 'package:tickets_app/features/ordenes/presentation/screens/detalle_taller_screen.dart';
import 'package:tickets_app/features/ordenes/domain/entities/formato_ot.dart';
import 'package:tickets_app/features/ordenes/domain/entities/formato_actividades.dart';
import 'package:tickets_app/features/ordenes/domain/entities/formato_acta_entrega.dart';
import 'package:tickets_app/features/ordenes/domain/entities/foto_evidencia.dart';
import 'package:tickets_app/features/ordenes/domain/entities/repuesto.dart';

const code = 'ORD-2026-0001-E32EE189EB172A01F00F075C35D72F8EDCA';

class DemoRepository extends Fake implements IOrdenesRepository {
  @override
  Future<List<Cliente>> searchClientes(String query) async => [
    const Cliente(
      id: 1,
      tipoDocumento: 'CC',
      numeroDocumento: '123',
      nombreCompleto: 'Cliente de prueba',
      telefono: '3001234567',
      direccion: 'Calle 1',
    ),
  ];
  @override
  Future<List<Usuario>> getUsuarios({String? rol}) async => [];
  @override
  Future<List<Equipo>> searchEquipos({
    int? clienteId,
    String? tipo,
    String? query,
  }) async => [];
  @override
  Future<List<TipoFalla>> getTiposFalla({String? tipoServicio}) async => [];
  @override
  Future<EmpresaConfig> getEmpresaConfig() async =>
      const EmpresaConfig.defaultConfig();
  @override
  Future<String> registrarOrdenCompleta({
    required Cliente cliente,
    required Equipo equipo,
    required Orden orden,
    String? fotoIngresoBase64,
  }) async => code;
}

void main() {
  testWidgets(
    'Taller: encabezado largo y secciones en escritorio y ventana estrecha',
    (tester) async {
      final repository = DemoWorkshopRepository();
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final capture = GlobalKey();
      if (Platform.environment['GENERATE_UI_EVIDENCE'] == '1') {
        await tester.runAsync(() async {
          final text = FontLoader('Roboto')
            ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'))
            ..addFont(rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
          await text.load();
          final icons = FontLoader('MaterialIcons')
            ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
          await icons.load();
        });
      }
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ordenesRepositoryProvider.overrideWithValue(
                repository,
            ),
          ],
          child: RepaintBoundary(
            key: capture,
            child: MaterialApp(
              theme: AppTheme.lightTheme.copyWith(
                textTheme: AppTheme.lightTheme.textTheme.apply(
                  fontFamily: 'Roboto',
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: AppTheme.lightTheme.elevatedButtonTheme.style!
                      .copyWith(
                        textStyle: const WidgetStatePropertyAll(
                          TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                ),
              ),
              home: const DetalleTallerScreen(ordenId: 1),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Recepción y diagnóstico'), findsOneWidget);
      if (Platform.environment['GENERATE_UI_EVIDENCE'] == '1') {
        await tester.runAsync(() async {
          final boundary =
              capture.currentContext!.findRenderObject()
                  as RenderRepaintBoundary;
          final image = await boundary.toImage();
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          final file = File('output/ui/taller.png');
          await file.parent.create(recursive: true);
          await file.writeAsBytes(data!.buffer.asUint8List());
          image.dispose();
        });
      }
      tester.view.physicalSize = const Size(600, 1000);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Registro completo: formularios adaptables y código largo sin desbordamiento',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final capture = GlobalKey();
      if (Platform.environment['GENERATE_UI_EVIDENCE'] == '1') {
        await tester.runAsync(() async {
          final font = FontLoader('Roboto')
            ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'))
            ..addFont(rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
          await font.load();
          final loader = FontLoader('MaterialIcons')
            ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
          await loader.load();
        });
      }
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ordenesRepositoryProvider.overrideWithValue(DemoRepository()),
          ],
          child: RepaintBoundary(
            key: capture,
            child: MaterialApp(
              theme: AppTheme.lightTheme.copyWith(
                textTheme: AppTheme.lightTheme.textTheme.apply(
                  fontFamily: 'Roboto',
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: AppTheme.lightTheme.elevatedButtonTheme.style!
                      .copyWith(
                        textStyle: const WidgetStatePropertyAll(
                          TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                ),
              ),
              home: const CrearIncidenciaScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<void> screenshot(String name) async {
        if (Platform.environment['GENERATE_UI_EVIDENCE'] != '1') return;
        await tester.pumpAndSettle();
        await tester.runAsync(() async {
          final boundary =
              capture.currentContext!.findRenderObject()
                  as RenderRepaintBoundary;
          final image = await boundary.toImage();
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          final file = File('output/ui/$name.png');
          await file.parent.create(recursive: true);
          await file.writeAsBytes(data!.buffer.asUint8List());
          image.dispose();
        });
      }

      Future<void> tap(String label) async {
        final finder = find.text(label);
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }

      await tap('+ Nuevo Cliente');
      await screenshot('cliente');
      await tap('Cancelar');
      await tap('Elegir Cliente');
      await tap('Siguiente: Tipo de Incidencia');
      await screenshot('incidencia');
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(1), 'No enciende');
      await tester.enterText(
        fields.at(2),
        'El equipo no responde al botón de encendido.',
      );
      await tap('Siguiente: Datos del Equipo');
      await screenshot('equipo');
      tester.view.physicalSize = const Size(600, 1000);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await screenshot('equipo_estrecho');
      tester.view.physicalSize = const Size(1280, 1000);
      await tester.pumpAndSettle();
      final inputs = find.byType(TextFormField);
      await tester.enterText(inputs.at(0), 'Lenovo');
      await tester.enterText(inputs.at(1), 'ThinkPad');
      await tester.enterText(inputs.at(2), 'SERIE-123');
      await tap('Siguiente: Asignar Técnico');
      await tap('Radicar Incidencia / Crear Orden de Servicio');
      expect(find.text(code), findsOneWidget);
      await screenshot('orden_creada');
      tester.view.physicalSize = const Size(480, 1000);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(code), findsOneWidget);
      await screenshot('orden_creada_estrecho');
    },
  );
}

class DemoWorkshopRepository extends DemoRepository {
  @override
  Future<Orden?> getOrdenById(int id) async => Orden(
    id: id,
    codigoOrden: code,
    clienteId: 1,
    equipoId: 1,
    tipoServicio: 'CORRECTIVO',
    categoriaFalla: 'Hardware',
    prioridad: 'MEDIA',
    titulo: 'No enciende',
    descripcion: 'No responde al botón de encendido',
    estado: 'EN_DIAGNOSTICO',
    fechaIngreso: DateTime(2026, 10, 1),
  );
  @override
  Future<FormatoOt?> getFormatoOt(int ordenId) async => FormatoOt(
    ordenId: ordenId,
    diagnosticoPreliminar: 'El equipo no inicia. Se revisará el cargador y la alimentación de la placa.',
    herramientasChips: ['Multímetro', 'Pulsera ESD'],
    accesorioCargador: true,
    estadoCarcasa: 'Carcasa conservada, sin golpes visibles.',
  );
  @override
  Future<FormatoActividades?> getFormatoActividades(int ordenId) async => null;
  @override
  Future<FormatoActaEntrega?> getActaEntrega(int ordenId) async => null;
  @override
  Future<List<FotoEvidencia>> getFotosEvidencia(int ordenId) async => [];
  @override
  Future<List<Repuesto>> getRepuestos(int ordenId) async => [];
}
