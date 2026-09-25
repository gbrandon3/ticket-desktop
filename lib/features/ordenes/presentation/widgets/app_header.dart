import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/santi_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/empresa_config.dart';
import '../providers/ordenes_providers.dart';
import '../screens/configuracion_screen.dart';

class AppHeader extends ConsumerWidget {
  final VoidCallback? onNuevaOrden;

  const AppHeader({super.key, this.onNuevaOrden});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final empresaAsync = ref.watch(empresaConfigStreamProvider);
    final empresa = empresaAsync.asData?.value ?? const EmpresaConfig.defaultConfig();
    final themeState = ref.watch(appThemeNotifierProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: themeState.headerColor,
        border: const Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 850;

          final titleContent = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (empresa.logoBase64 != null && empresa.logoBase64!.isNotEmpty)
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.memory(
                    base64Decode(empresa.logoBase64!),
                    fit: BoxFit.contain,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeState.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.settings_suggest, color: Colors.white, size: 26),
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            empresa.nombreEmpresa,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: SantiConstants.accentCyan.withAlpha(50),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: SantiConstants.accentCyan, width: 0.8),
                          ),
                          child: const Text(
                            'TALLER V2.0',
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${empresa.slogan} • NIT: ${empresa.nit}',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          );

          final actionButtons = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ConfiguracionScreen()),
                  );
                },
                icon: const Icon(Icons.settings, color: Colors.white70),
                tooltip: 'Configuración del Taller / Empresa',
              ),
              const SizedBox(width: 6),
              if (onNuevaOrden != null)
                ElevatedButton.icon(
                  onPressed: onNuevaOrden,
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('Nueva Orden de Ingreso'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SantiConstants.accentCyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
            ],
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                titleContent,
                const SizedBox(height: 12),
                actionButtons,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: titleContent),
              const SizedBox(width: 16),
              actionButtons,
            ],
          );
        },
      ),
    );
  }
}
