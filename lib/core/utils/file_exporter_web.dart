import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

Future<String?> exportFilePlatform({
  required String fileName,
  required String content,
  String mimeType = 'text/plain;charset=utf-8',
}) async {
  final bytes = utf8.encode(content);
  return exportBytesPlatform(fileName: fileName, bytes: bytes, mimeType: mimeType);
}

Future<String?> exportBytesPlatform({
  required String fileName,
  required List<int> bytes,
  String mimeType = 'application/octet-stream',
}) async {
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..style.display = 'none';

  html.document.body?.children.add(anchor);
  anchor.click();
  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);

  return 'Archivo descargado en el navegador: $fileName';
}
