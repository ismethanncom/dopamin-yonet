import 'package:flutter/material.dart';

/// Uygulama renk paleti - Modern koyu tema
class AppColors {
  AppColors._();

  // Ana Arka Plan Renkleri
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF12121A);
  static const Color surfaceLight = Color(0xFF1A1A24);
  static const Color cardBackground = Color(0xFF16161F);
  static const Color cardBorder = Color(0xFF2A2A3A);

  // Birincil Renkler
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF8B7CF7);
  static const Color primaryDark = Color(0xFF5A4BD1);

  // İkincil Renkler
  static const Color secondary = Color(0xFF00D9FF);
  static const Color accent = Color(0xFF00F5A0);

  // Durum Renkleri
  static const Color success = Color(0xFF00F5A0);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF4757);
  static const Color info = Color(0xFF00D9FF);

  // Metin Renkleri
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C3);
  static const Color textTertiary = Color(0xFF6B6B80);
  static const Color textDisabled = Color(0xFF4A4A5A);

  // Stability Score Renkleri
  static const Color stabilityExcellent = Color(0xFF00F5A0);
  static const Color stabilityGood = Color(0xFF7CB342);
  static const Color stabilityMedium = Color(0xFFFFB800);
  static const Color stabilityLow = Color(0xFFFF8C00);
  static const Color stabilityCritical = Color(0xFFFF4757);

  // Hayat Ağacı Renkleri
  static const Color treeSprout = Color(0xFF90CAF9);
  static const Color treeGrowing = Color(0xFF7CB342);
  static const Color treeMature = Color(0xFF4CAF50);
  static const Color treeFlourishing = Color(0xFF2E7D32);
  static const Color treeWilting = Color(0xFF8D6E63);

  // Gradyanlar
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF8B7CF7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00F5A0), Color(0xFF00D9FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFB800), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFFF4757), Color(0xFFFF6B7A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF16161F), Color(0xFF1A1A24)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Stability Score'a göre renk döndürür
  static Color getStabilityColor(int score) {
    if (score >= 80) return stabilityExcellent;
    if (score >= 60) return stabilityGood;
    if (score >= 40) return stabilityMedium;
    if (score >= 20) return stabilityLow;
    return stabilityCritical;
  }
}
