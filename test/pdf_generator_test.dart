import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tickets_app/core/utils/pdf_generator.dart';
import 'package:tickets_app/features/ordenes/domain/entities/cliente.dart';
import 'package:tickets_app/features/ordenes/domain/entities/equipo.dart';
import 'package:tickets_app/features/ordenes/domain/entities/orden.dart';
import 'package:tickets_app/features/ordenes/domain/entities/formato_ot.dart';
import 'package:tickets_app/features/ordenes/domain/entities/formato_actividades.dart';
import 'package:tickets_app/features/ordenes/domain/entities/formato_acta_entrega.dart';
import 'package:tickets_app/features/ordenes/domain/entities/repuesto.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final order = Orden(
    id: 1, codigoOrden: 'ORD-2026-0001-AB12CD34EF56AB78CD90EF12AB34CD56', clienteId: 1, equipoId: 1,
    tipoServicio: 'CORRECTIVO', categoriaFalla: 'HARDWARE', prioridad: 'MEDIA',
    titulo: 'Revisión y mantenimiento de equipo portátil',
    descripcion: 'El equipo presenta temperaturas altas y lentitud durante el uso.',
    fechaIngreso: DateTime(2026, 10, 1, 9),
    cliente: const Cliente(id: 1, tipoDocumento: 'CC', numeroDocumento: 'DEMO-001',
        nombreCompleto: 'María Gómez — Datos de demostración', telefono: '3000000000',
        email: 'demo@example.com', direccion: 'Dirección de demostración'),
    equipo: const Equipo(id: 1, clienteId: 1, tipoEquipo: 'PORTATIL', marca: 'Lenovo',
        modelo: 'ThinkPad T14', numeroSerie: 'DEMO-SERIAL', procesador: 'Intel Core i5',
        memoriaRam: '16 GB', almacenamiento: 'SSD 512 GB', sistemaOperativo: 'Windows 11'),
  );

  test('PDF: comprobante de recepción con información del equipo', () async {
    final bytes = await PdfGenerator.generateDocumentoOficial(orden: order,
        formatoOt: const FormatoOt(ordenId: 1, diagnosticoPreliminar: 'Se requiere limpieza y cambio de pasta térmica.',
            accesorioCargador: true, estadoCarcasa: 'Marcas leves de uso'));
    expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
    expect(bytes.length, greaterThan(1000));
    if (Platform.environment['GENERATE_PDF_EVIDENCE'] == '1') {
      final directory = Directory('output/pdf')..createSync(recursive: true);
      File('${directory.path}/comprobante_demo.pdf').writeAsBytesSync(bytes);
    }
  });

  test('PDF: acta con procedimientos largos y tabla de repuestos', () async {
    final bytes = await PdfGenerator.generateDocumentoOficial(
      orden: order.copyWith(estado: 'ENTREGADO_CERRADO'),
      actividades: FormatoActividades(ordenId: 1, pastaTermica: true, alcoholIsopropilico: true,
          qaEstresTermico: true, qaPuertos: true, qaConectividad: true, costoManoObra: 85000,
          procedimientosRealizados: List.filled(6, 'Se realizó limpieza interna, verificación de conectores y pruebas de funcionamiento.').join('\n')),
      repuestos: List.generate(12, (index) => Repuesto(ordenId: 1,
          referencia: 'Repuesto de demostración ${index + 1} — pieza compatible con el equipo',
          cantidad: 1, precioUnitario: 15000, subtotal: 15000)),
      acta: FormatoActaEntrega(ordenId: 1, estadoOperatividad: 'OPERATIVO',
          garantiaDias: '30_DIAS', personaRecibeNombre: 'María Gómez', personaRecibeDocumento: 'DEMO-001',
          checkConformidad: true, fechaEntrega: DateTime(2026, 10, 1, 16),
          observaciones: 'Equipo entregado después de pruebas de funcionamiento.',
          recomendacionesCuidado: 'Mantener ventilación libre, evitar líquidos y respaldar los documentos importantes.'),
    );
    expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
    expect(bytes.length, greaterThan(1000));
    if (Platform.environment['GENERATE_PDF_EVIDENCE'] == '1') {
      File('output/pdf/acta_demo.pdf').writeAsBytesSync(bytes);
    }
  });
}
