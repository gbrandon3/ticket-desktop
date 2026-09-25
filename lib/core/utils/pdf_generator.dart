import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../features/ordenes/domain/entities/empresa_config.dart';
import '../../features/ordenes/domain/entities/formato_acta_entrega.dart';
import '../../features/ordenes/domain/entities/formato_actividades.dart';
import '../../features/ordenes/domain/entities/formato_ot.dart';
import '../../features/ordenes/domain/entities/orden.dart';
import '../../features/ordenes/domain/entities/repuesto.dart';
import 'currency_formatter.dart';

class PdfGenerator {
  static PdfColor _parsePdfColor(String hex, {PdfColor defaultColor = PdfColors.blue900}) {
    try {
      final clean = hex.replaceAll('#', '').trim();
      if (clean.length == 6) {
        final r = int.parse(clean.substring(0, 2), radix: 16) / 255.0;
        final g = int.parse(clean.substring(2, 4), radix: 16) / 255.0;
        final b = int.parse(clean.substring(4, 6), radix: 16) / 255.0;
        return PdfColor(r, g, b);
      }
    } catch (_) {}
    return defaultColor;
  }

  static PdfColor _lightenColor(PdfColor color, [double factor = 0.88]) {
    return PdfColor(
      color.red + (1.0 - color.red) * factor,
      color.green + (1.0 - color.green) * factor,
      color.blue + (1.0 - color.blue) * factor,
    );
  }

  static Future<Uint8List> generateDocumentoOficial({
    required Orden orden,
    FormatoOt? formatoOt,
    FormatoActividades? actividades,
    List<Repuesto> repuestos = const [],
    FormatoActaEntrega? acta,
    EmpresaConfig empresa = const EmpresaConfig.defaultConfig(),
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final primaryPdf = _parsePdfColor(empresa.colorPrimario);
    final mediumPdf = _lightenColor(primaryPdf, 0.30);
    final lightPdf = _lightenColor(primaryPdf, 0.90);

    // Cálculos
    double subtotalRepuestos = 0.0;
    for (final r in repuestos) {
      subtotalRepuestos += r.subtotal;
    }
    final manoObra = actividades?.costoManoObra ?? 0.0;
    final totalPagar = subtotalRepuestos + manoObra;

    pw.MemoryImage? logoImage;
    if (empresa.logoBase64 != null && empresa.logoBase64!.isNotEmpty) {
      try {
        logoImage = pw.MemoryImage(base64Decode(empresa.logoBase64!));
      } catch (_) {}
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // 1. Membrete Institucional Dinámico de la Empresa
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 12),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: primaryPdf, width: 2),
              ),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (logoImage != null) ...[
                      pw.Container(
                        width: 48,
                        height: 48,
                        margin: const pw.EdgeInsets.only(right: 12),
                        child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                      ),
                    ],
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          empresa.nombreEmpresa.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryPdf,
                          ),
                        ),
                        pw.Text(
                          'SERVICIO TÉCNICO & MANTENIMIENTO ESPECIALIZADO',
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            fontWeight: pw.FontWeight.bold,
                            color: mediumPdf,
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        if (empresa.slogan.isNotEmpty) ...[
                          pw.Text(
                            '"${empresa.slogan}"',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontStyle: pw.FontStyle.italic,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                        ],
                        pw.Text(
                          'NIT: ${empresa.nit} | Tel: ${empresa.telefono}',
                          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800),
                        ),
                        pw.Text(
                          '${empresa.direccion} - ${empresa.ciudad} | ${empresa.email}',
                          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: primaryPdf, width: 1.5),
                    borderRadius: pw.BorderRadius.circular(6),
                    color: lightPdf,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'ORDEN DE SERVICIO',
                        style: pw.TextStyle(
                          fontSize: 8.5,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryPdf,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        orden.codigoOrden,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.red900,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Fecha: ${dateFormat.format(orden.fechaIngreso)}',
                        style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey800),
                      ),
                      pw.Text(
                        'Estado: ${orden.estado.replaceAll('_', ' ')}',
                        style: pw.TextStyle(
                          fontSize: 7.5,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryPdf,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 12),

          // 2. Fila: Datos de Cliente y Ficha del Equipo
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Cliente
              pw.Expanded(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(4),
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'DATOS DEL CLIENTE',
                        style: pw.TextStyle(
                          fontSize: 8.5,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryPdf,
                        ),
                      ),
                      pw.Divider(color: PdfColors.grey400, height: 6),
                      _textRow('Nombre:', orden.cliente?.nombreCompleto ?? 'N/A'),
                      _textRow('Documento:', '${orden.cliente?.tipoDocumento ?? ''} ${orden.cliente?.numeroDocumento ?? 'N/A'}'),
                      _textRow('Teléfono:', orden.cliente?.telefono ?? 'N/A'),
                      _textRow('Email:', orden.cliente?.email ?? 'N/A'),
                      _textRow('Dirección:', orden.cliente?.direccion ?? 'N/A'),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(width: 10),
              // Equipo
              pw.Expanded(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(4),
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'FICHA TÉCNICA DEL EQUIPO',
                        style: pw.TextStyle(
                          fontSize: 8.5,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryPdf,
                        ),
                      ),
                      pw.Divider(color: PdfColors.grey400, height: 6),
                      _textRow('Dispositivo:', orden.equipo?.tipoEquipo ?? 'N/A'),
                      _textRow('Marca / Modelo:', '${orden.equipo?.marca ?? ''} ${orden.equipo?.modelo ?? ''}'),
                      _textRow('Serie (S/N):', orden.equipo?.numeroSerie ?? 'N/A'),
                      _textRow('CPU / RAM:', '${orden.equipo?.procesador ?? 'N/A'} / ${orden.equipo?.memoriaRam ?? 'N/A'}'),
                      _textRow('Almacenamiento:', orden.equipo?.almacenamiento ?? 'N/A'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),

          // 3. Resumen de Falla y Diagnóstico
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(4),
              border: pw.Border.all(color: PdfColors.grey300),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Text('Tipo Servicio: ', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    pw.Text(orden.tipoServicio, style: const pw.TextStyle(fontSize: 8)),
                    pw.SizedBox(width: 16),
                    pw.Text('Categoría: ', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    pw.Text(orden.categoriaFalla, style: const pw.TextStyle(fontSize: 8)),
                    pw.SizedBox(width: 16),
                    pw.Text('Prioridad: ', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    pw.Text(orden.prioridad, style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Text('Motivo / Falla Reportada:', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: primaryPdf)),
                pw.Text('${orden.titulo}: ${orden.descripcion}', style: const pw.TextStyle(fontSize: 8)),
                pw.SizedBox(height: 4),
                pw.Text('Diagnóstico de Laboratorio:', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: primaryPdf)),
                pw.Text(formatoOt?.diagnosticoPreliminar ?? 'Revisión en mesón de trabajo', style: const pw.TextStyle(fontSize: 8)),
                if (actividades?.procedimientosRealizados != null && actividades!.procedimientosRealizados!.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Text('Bitácora de Labores:', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: primaryPdf)),
                  pw.Text(actividades.procedimientosRealizados!, style: const pw.TextStyle(fontSize: 8)),
                ],
              ],
            ),
          ),
          pw.SizedBox(height: 10),

          // 4. Insumos y Pruebas Aplicadas
          if (actividades != null) ...[
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: lightPdf,
                borderRadius: pw.BorderRadius.circular(4),
                border: pw.Border.all(color: mediumPdf),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'CONTROL TÉCNICO E INSUMOS FÍSICO-QUÍMICOS APLICADOS',
                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: primaryPdf),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _checkItem('Pasta Térmica Alto Rendimiento', actividades.pastaTermica),
                      _checkItem('Alcohol Isopropílico 99.8%', actividades.alcoholIsopropilico),
                      _checkItem('Sopleteado Dieléctrico', actividades.sopleteadoContactos),
                      _checkItem('Brocha Antiestática', actividades.brochaAntiestatica),
                    ],
                  ),
                  pw.SizedBox(height: 3),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _checkItem('Limpieza Lógica / Temporales', actividades.depuracionTemporales),
                      _checkItem('Desinfección Malware', actividades.escaneoMalware),
                      _checkItem('Test de Estrés Térmico QA', actividades.qaEstresTermico),
                      _checkItem('Test de Puertos y Teclado', actividades.qaPuertos),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 6),

            // CERTIFICACIÓN DE PRUEBAS DE DIAGNÓSTICO PRE-ENTREGA (SOFTWARE TÉCNICO)
            pw.Container(
              padding: const pw.EdgeInsets.all(7),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey50,
                borderRadius: pw.BorderRadius.circular(4),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'CERTIFICACIÓN DE PRUEBAS DE DIAGNÓSTICO Y SALUD PRE-ENTREGA (SOFTWARE TÉCNICO)',
                        style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: primaryPdf),
                      ),
                      pw.Text(
                        'CONTROL CALIDAD SANTI INC',
                        style: pw.TextStyle(fontSize: 6.5, fontWeight: pw.FontWeight.bold, color: PdfColors.green900),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _checkItem('CrystalDiskInfo (Salud SMART / Disco SSD-HDD)', actividades.comprobacionDisco, primaryColor: primaryPdf),
                            pw.SizedBox(height: 2),
                            _checkItem('HWMonitor / Core Temp (Disipación Térmica CPU)', actividades.qaEstresTermico, primaryColor: primaryPdf),
                            pw.SizedBox(height: 2),
                            _checkItem('MemTest86 (Integridad de Memoria RAM)', actividades.procedimientosRealizados?.contains('MemTest') == true || actividades.qaEstresTermico, primaryColor: primaryPdf),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _checkItem('FurMark / 3D (Estabilidad Gráfica y GPU)', actividades.procedimientosRealizados?.contains('FurMark') == true, primaryColor: primaryPdf),
                            pw.SizedBox(height: 2),
                            _checkItem('BatteryBar / Carga (Salud y Retención Batería)', actividades.qaBateria, primaryColor: primaryPdf),
                            pw.SizedBox(height: 2),
                            _checkItem('Periféricos (Puertos USB, Teclado, Touchpad, Audio, Red)', actividades.qaTecladoTouchpad || actividades.qaPuertos, primaryColor: primaryPdf),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Certificación: El equipo ha sido sometido a pruebas de rendimiento y estrés con software especializado para garantizar su correcto funcionamiento antes de ser entregado. Capturas de evidencia archivadas en el ticket.',
                    style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey700),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
          ],

          // 5. Liquidación Económica
          pw.Text('LIQUIDACIÓN ECONÓMICA DE SERVICIO', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: primaryPdf)),
          pw.SizedBox(height: 4),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(4),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _tableCell('Concepto / Referencia', isHeader: true, primaryColor: primaryPdf),
                  _tableCell('Cant.', isHeader: true, primaryColor: primaryPdf),
                  _tableCell('Valor Unit.', isHeader: true, primaryColor: primaryPdf),
                  _tableCell('Subtotal', isHeader: true, primaryColor: primaryPdf),
                ],
              ),
              ...repuestos.map((r) => pw.TableRow(
                    children: [
                      _tableCell(r.referencia),
                      _tableCell('${r.cantidad}', align: pw.TextAlign.center),
                      _tableCell(CurrencyFormatter.format(r.precioUnitario), align: pw.TextAlign.right),
                      _tableCell(CurrencyFormatter.format(r.subtotal), align: pw.TextAlign.right),
                    ],
                  )),
              pw.TableRow(
                children: [
                  _tableCell('Mano de Obra Especializada y Servicio de Taller'),
                  _tableCell('1', align: pw.TextAlign.center),
                  _tableCell(CurrencyFormatter.format(manoObra), align: pw.TextAlign.right),
                  _tableCell(CurrencyFormatter.format(manoObra), align: pw.TextAlign.right),
                ],
              ),
              pw.TableRow(
                decoration: pw.BoxDecoration(color: lightPdf),
                children: [
                  _tableCell('TOTAL A LIQUIDAR', isHeader: true, primaryColor: primaryPdf),
                  _tableCell(''),
                  _tableCell(''),
                  _tableCell(
                    CurrencyFormatter.format(totalPagar),
                    isHeader: true,
                    align: pw.TextAlign.right,
                    textColor: primaryPdf,
                    primaryColor: primaryPdf,
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),

          // 6. Dictamen de Entrega y Garantía
          if (acta != null) ...[
            pw.Container(
              padding: const pw.EdgeInsets.all(6),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'DICTAMEN FINAL: ${acta.estadoOperatividad.replaceAll('_', ' ')}',
                        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: primaryPdf),
                      ),
                      pw.Text(
                        'Vigencia de Garantía: ${acta.garantiaDias.replaceAll('_', ' ')}',
                        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.green900),
                      ),
                    ],
                  ),
                  if (acta.recomendacionesCuidado != null && acta.recomendacionesCuidado!.isNotEmpty) ...[
                    pw.SizedBox(height: 2),
                    pw.Text('Recomendaciones al Cliente: ${acta.recomendacionesCuidado}', style: const pw.TextStyle(fontSize: 7.5)),
                  ],
                ],
              ),
            ),
            pw.SizedBox(height: 8),
          ],

          // 7. Términos Legales Personalizados con el nombre de la empresa
          pw.Text(
            'TÉRMINOS DE ENTREGA: El cliente declara recibir el equipo a satisfacción, habiendo presenciado su encendido y comprobado las reparaciones indicadas. ${empresa.nombreEmpresa} responderá por la garantía en los términos descritos y conforme a la Ley 1480 de Colombia (Estatuto del Consumidor). Daños causados por sobrevoltajes, humedad o manipulación de terceros anulan la garantía.',
            style: const pw.TextStyle(fontSize: 6.5, color: PdfColors.grey700),
            textAlign: pw.TextAlign.justify,
          ),
          pw.SizedBox(height: 24),

          // 8. Firmas Gemelas
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                children: [
                  pw.Container(width: 180, decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.black, width: 1)))),
                  pw.SizedBox(height: 4),
                  pw.Text('TÉCNICO RESPONSABLE', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  pw.Text('${empresa.nombreEmpresa} - Taller Técnico', style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey700)),
                ],
              ),
              pw.Column(
                children: [
                  pw.Container(width: 180, decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.black, width: 1)))),
                  pw.SizedBox(height: 4),
                  pw.Text('RECIBIDO A CONFORMIDAD', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Nombre: ${acta?.personaRecibeNombre ?? orden.cliente?.nombreCompleto ?? ''}', style: const pw.TextStyle(fontSize: 7)),
                  pw.Text('Doc: ${acta?.personaRecibeDocumento ?? orden.cliente?.numeroDocumento ?? ''}', style: const pw.TextStyle(fontSize: 7)),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _textRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 75,
            child: pw.Text(label, style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.black)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _checkItem(String label, bool isChecked, {PdfColor? primaryColor}) {
    final color = primaryColor ?? PdfColors.blue900;
    return pw.Row(
      children: [
        pw.Container(
          width: 8,
          height: 8,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: color, width: 0.8),
            color: isChecked ? color : PdfColors.white,
          ),
          child: isChecked
              ? pw.Center(
                  child: pw.Text('x', style: pw.TextStyle(color: PdfColors.white, fontSize: 6, fontWeight: pw.FontWeight.bold)),
                )
              : null,
        ),
        pw.SizedBox(width: 3),
        pw.Text(label, style: const pw.TextStyle(fontSize: 6.5)),
      ],
    );
  }

  static pw.Widget _tableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.left,
    PdfColor? textColor,
    PdfColor? primaryColor,
  }) {
    final headerColor = primaryColor ?? PdfColors.blue900;
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: isHeader ? 7.5 : 7,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: textColor ?? (isHeader ? headerColor : PdfColors.black),
        ),
      ),
    );
  }
}
