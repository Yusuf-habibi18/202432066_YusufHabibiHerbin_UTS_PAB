import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_colors.dart';

/// Outfit (geometris, ramping) untuk judul dan angka; Manrope untuk teks isi.
/// Lima ukuran: 32 (angka utama), 24 (sapaan), 20 (judul), 14 (isi),
/// 12 (keterangan).
///
/// Setiap gaya menyebut font sendiri agar tetap benar di tempat yang tidak
/// mewarisi tema, misalnya judul AppBar dan tooltip grafik.
abstract final class AppTextStyles {
  static const fontFamily = 'Manrope';
  static const headingFamily = 'Outfit';

  /// Angka berlebar sama agar kolom nominal rata dan angka berjalan tidak
  /// bergoyang.
  static const tabularFigures = [FontFeature.tabularFigures()];

  static const display = TextStyle(
    fontFamily: headingFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.15,
    fontFeatures: tabularFigures,
  );

  static const headline = TextStyle(
    fontFamily: headingFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const title = TextStyle(
    fontFamily: headingFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const bodySecondary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const bodyBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const amount = TextStyle(
    fontFamily: headingFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFeatures: tabularFigures,
  );

  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.1,
    color: AppColors.textSecondary,
  );
}
