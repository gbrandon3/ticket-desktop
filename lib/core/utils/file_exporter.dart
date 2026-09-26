import 'file_exporter_stub.dart'
    if (dart.library.html) 'file_exporter_web.dart'
    if (dart.library.io) 'file_exporter_io.dart';

class FileExporter {
  static Future<String?> exportFile({
    required String fileName,
    required String content,
    String mimeType = 'text/plain;charset=utf-8',
  }) {
    return exportFilePlatform(fileName: fileName, content: content, mimeType: mimeType);
  }

  static Future<String?> exportBytes({
    required String fileName,
    required List<int> bytes,
    String mimeType = 'application/octet-stream',
  }) {
    return exportBytesPlatform(fileName: fileName, bytes: bytes, mimeType: mimeType);
  }
}
