import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/repositories/api_ordenes_repository.dart';

class EvidenciaImage extends StatelessWidget {
  final String rutaOBytes;
  final BoxFit fit;
  final double? width;
  final double? height;

  const EvidenciaImage({
    super.key,
    required this.rutaOBytes,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  static String resolveUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final baseUrl = ApiOrdenesRepository.resolveDefaultBaseUrl();
    final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$cleanBase$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    final trimmed = rutaOBytes.trim();
    if (trimmed.isEmpty) {
      return _buildPlaceholder();
    }

    if (trimmed.startsWith('/uploads/') || trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      final url = resolveUrl(trimmed);
      return Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF1F5F9),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      );
    }

    // Fallback: Base64 data (para fotos legacy en SQLite)
    try {
      final cleanBase64 = trimmed.contains(',') ? trimmed.split(',').last : trimmed;
      final bytes = base64Decode(cleanBase64);
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } catch (_) {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF1F5F9),
      child: const Center(
        child: Icon(Icons.broken_image_outlined, size: 24, color: Color(0xFF94A3B8)),
      ),
    );
  }
}
