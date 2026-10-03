import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tickets_app/features/ordenes/data/repositories/api_ordenes_repository.dart';
import 'package:tickets_app/features/ordenes/domain/entities/cliente.dart';
import 'package:tickets_app/features/ordenes/domain/entities/equipo.dart';
import 'package:tickets_app/features/ordenes/domain/entities/orden.dart';

void main() {
  test('El acta con receptor y estado nulos se convierte a campos seguros', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    server.listen((request) async {
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode({'success': true, 'data': {
        'ordenId': 1, 'estadoOperatividad': null,
        'personaRecibeNombre': null, 'personaRecibeDocumento': null,
      }}));
      await request.response.close();
    });
    final repository = ApiOrdenesRepository(baseUrl: 'http://127.0.0.1:${server.port}');
    final acta = await repository.getActaEntrega(1);
    expect(acta, isNotNull);
    expect(acta!.estadoOperatividad, 'OPERATIVO');
    expect(acta.personaRecibeNombre, '');
    expect(acta.personaRecibeDocumento, '');
  });
  test('Una orden rechazada por la API no se presenta como registrada', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    server.listen((request) async {
      await request.drain<void>();
      request.response.statusCode = 200;
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode({'success': false, 'error': 'Equipo ya en taller'}));
      await request.response.close();
    });
    final repository = ApiOrdenesRepository(baseUrl: 'http://127.0.0.1:${server.port}');
    await expectLater(repository.registrarOrdenCompleta(
      cliente: const Cliente(tipoDocumento: 'CC', numeroDocumento: '1', nombreCompleto: 'Cliente', telefono: '1', direccion: 'Calle'),
      equipo: const Equipo(clienteId: 1, tipoEquipo: 'PC', marca: 'Marca', modelo: 'Modelo', numeroSerie: 'Serie'),
      orden: Orden(codigoOrden: 'Temporal', clienteId: 1, equipoId: 1, tipoServicio: 'CORRECTIVO', categoriaFalla: 'HARDWARE', prioridad: 'MEDIA', titulo: 'Prueba', descripcion: 'Prueba', fechaIngreso: DateTime.now()),
    ), throwsStateError);
  });
  test('La configuración con campos nulos se puede mostrar después del login', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    server.listen((request) async {
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode({
        'success': true,
        'data': {
          'nombreEmpresa': 'Taller de prueba',
          'slogan': null,
          'nit': null,
          'telefono': null,
          'email': null,
          'direccion': null,
          'ciudad': null,
          'isSetupCompleted': true,
        },
      }));
      await request.response.close();
    });
    final repository = ApiOrdenesRepository(baseUrl: 'http://127.0.0.1:${server.port}');
    final config = await repository.getEmpresaConfig();
    expect(config.nombreEmpresa, 'Taller de prueba');
    expect(config.slogan.isEmpty, isTrue);
    expect([config.nit, config.telefono, config.email, config.direccion, config.ciudad], everyElement(''));
    expect(config.isSetupCompleted, isTrue);
  });
}
