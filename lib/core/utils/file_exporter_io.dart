import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String?> exportFilePlatform({
  required String fileName,
  required String content,
  String mimeType = 'text/plain',
}) async {
  final dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsString(content);
  return 'Guardado exitosamente en: ${file.path}';
}

Future<String?> exportBytesPlatform({
  required String fileName,
  required List<int> bytes,
  String mimeType = 'application/octet-stream',
}) async {
  final dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsBytes(bytes);
  return 'Guardado exitosamente en: ${file.path}';
}
