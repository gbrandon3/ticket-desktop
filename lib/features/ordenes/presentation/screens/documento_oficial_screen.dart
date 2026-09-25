import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../../../core/utils/pdf_generator.dart';
import '../../domain/entities/empresa_config.dart';
import '../providers/ordenes_providers.dart';

class DocumentoOficialScreen extends ConsumerWidget {
  final int ordenId;

  const DocumentoOficialScreen({super.key, required this.ordenId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useCase = ref.watch(manageTallerUseCaseProvider);
    final repo = ref.watch(ordenesRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Documento Oficial con Membrete'),
        backgroundColor: SantiConstants.primaryNavy,
      ),
      body: FutureBuilder(
        future: Future.wait([
          useCase.getOrden(ordenId),
          useCase.getFormatoOt(ordenId),
          useCase.getFormatoActividades(ordenId),
          useCase.getRepuestos(ordenId),
          useCase.getActa(ordenId),
          repo.getEmpresaConfig(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data![0] == null) {
            return Center(
              child: Text('Error al generar el documento oficial: ${snapshot.error}'),
            );
          }

          final orden = snapshot.data![0] as dynamic;
          final ot = snapshot.data![1] as dynamic;
          final act = snapshot.data![2] as dynamic;
          final repuestos = (snapshot.data![3] as List).cast<dynamic>();
          final acta = snapshot.data![4] as dynamic;
          final empresa = (snapshot.data![5] as EmpresaConfig?) ?? const EmpresaConfig.defaultConfig();

          final safeEmpresaName = empresa.nombreEmpresa.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');

          return PdfPreview(
            build: (format) => PdfGenerator.generateDocumentoOficial(
              orden: orden,
              formatoOt: ot,
              actividades: act,
              repuestos: repuestos.cast(),
              acta: acta,
              empresa: empresa,
            ),
            canChangeOrientation: false,
            canChangePageFormat: false,
            pdfFileName: 'Acta_${orden.codigoOrden}_$safeEmpresaName.pdf',
          );
        },
      ),
    );
  }
}
