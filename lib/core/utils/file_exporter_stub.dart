Future<String?> exportFilePlatform({
  required String fileName,
  required String content,
  String mimeType = 'text/plain',
}) async {
  throw UnsupportedError('Plataforma no soportada para exportación de archivos');
}

Future<String?> exportBytesPlatform({
  required String fileName,
  required List<int> bytes,
  String mimeType = 'application/octet-stream',
}) async {
  throw UnsupportedError('Plataforma no soportada para exportación de archivos');
}
