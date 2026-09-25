import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/santi_constants.dart';

class AppThemeState {
  final String id; // 'AZUL', 'VERDE', 'PURPURA', 'CUSTOM'
  final String name;
  final Color primaryColor;
  final Color headerColor;
  final Color accentColor;

  const AppThemeState({
    required this.id,
    required this.name,
    required this.primaryColor,
    required this.headerColor,
    this.accentColor = const Color(0xFF06B6D4),
  });
}

class AppThemeNotifier extends Notifier<AppThemeState> {
  static const presetAzul = AppThemeState(
    id: 'AZUL',
    name: 'Azul Corporativo',
    primaryColor: Color(0xFF2563EB),
    headerColor: Color(0xFF1E3A8A),
    accentColor: Color(0xFF06B6D4),
  );

  static const presetVerde = AppThemeState(
    id: 'VERDE',
    name: 'Verde Esmeralda',
    primaryColor: Color(0xFF059669),
    headerColor: Color(0xFF064E3B),
    accentColor: Color(0xFF10B981),
  );

  static const presetPurpura = AppThemeState(
    id: 'PURPURA',
    name: 'Púrpura Tech',
    primaryColor: Color(0xFF7C3AED),
    headerColor: Color(0xFF4C1D95),
    accentColor: Color(0xFFA855F7),
  );

  @override
  AppThemeState build() {
    return presetAzul;
  }

  void setTheme(String id) {
    switch (id) {
      case 'VERDE':
        state = presetVerde;
        break;
      case 'PURPURA':
        state = presetPurpura;
        break;
      case 'AZUL':
        state = presetAzul;
        break;
      default:
        state = presetAzul;
        break;
    }
  }

  void setCustomTheme({
    required Color primaryColor,
    required Color headerColor,
    String name = 'Personalizado',
  }) {
    state = AppThemeState(
      id: 'CUSTOM',
      name: name,
      primaryColor: primaryColor,
      headerColor: headerColor,
      accentColor: primaryColor,
    );
  }
}

final appThemeNotifierProvider = NotifierProvider<AppThemeNotifier, AppThemeState>(AppThemeNotifier.new);

class AppTheme {
  static ThemeData buildTheme({
    Color primary = SantiConstants.primaryBlue,
    Color header = SantiConstants.primaryNavy,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: SantiConstants.accentCyan,
        surface: SantiConstants.bgSurface,
      ),
      scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      appBarTheme: AppBarTheme(
        backgroundColor: header,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static ThemeData get lightTheme => buildTheme();
}

