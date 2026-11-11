import 'package:flutter/material.dart';

abstract final class AppColors {
  // Navy sebagai warna utama, biru baja untuk ujung gradien, tosca sebagai
  // aksen.
  static const primary = Color(0xFF17375E);
  static const primaryDark = Color(0xFF0B1E3A);
  static const primaryLight = Color(0xFF24507F);
  static const primaryBright = Color(0xFF2E6BA6);
  static const accent = Color(0xFF2BB5A3);
  static const accentOnDark = Color(0xFF6FE3D2);

  /// Gradien kartu utama dan tombol utama.
  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary, primaryBright],
    stops: [0, 0.55, 1],
  );

  static const background = Color(0xFFF4F6FA);
  static const surface = Colors.white;
  static const surfaceTint = Color(0xFFE3ECF7);

  /// Ujung gradien kotak ikon berlatar [surfaceTint].
  static const surfaceTintStrong = Color(0xFFD3E2F3);
  static const border = Color(0xFFE3E8F0);
  static const track = Color(0xFFE8EDF3);

  /// Bayangan lembut kebiruan untuk kartu putih.
  static const shadow = Color(0x1A0B1E3A);

  static const textPrimary = Color(0xFF0F172A);
  // Kontras minimal 4,5:1 (WCAG AA) di atas putih, background, dan surfaceTint.
  static const textSecondary = Color(0xFF5B6476);

  static const success = Color(0xFF10B981);

  // Merah hanya untuk error dan peringatan, tidak untuk nominal pengeluaran.
  static const error = Color(0xFFE5484D);
}
