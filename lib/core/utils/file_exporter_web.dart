import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

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
  final blob = web.Blob([Uint8List.fromList(bytes).toJS].toJS,
      web.BlobPropertyBag(type: mimeType));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName
    ..style.display = 'none';

  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  await Future<void>.delayed(const Duration(milliseconds: 100));
  web.URL.revokeObjectURL(url);

  return 'Archivo descargado en el navegador: $fileName';
}
