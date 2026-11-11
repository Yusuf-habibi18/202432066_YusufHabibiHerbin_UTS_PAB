import 'package:flutter/material.dart';

import 'package:uts_pab/core/theme/app_colors.dart';
import 'package:uts_pab/core/theme/app_text_styles.dart';

/// Warna, huruf, dan bentuk bawaan semua widget di aplikasi.
abstract final class AppTheme {
  static const _inputRadius = BorderRadius.all(Radius.circular(14));
  static const _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(14)),
  );

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      error: AppColors.error,
      surface: AppColors.surface,
    );

    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: AppTextStyles.fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarThemeData(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.title,
      ),
      inputDecorationTheme: const InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.surface,
        isDense: true,
        contentPadding: EdgeInsets.all(14),
        hintStyle: AppTextStyles.bodySecondary,
        prefixIconColor: AppColors.textSecondary,
        border: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 4,
        shadowColor: AppColors.shadow,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        horizontalTitleGap: 16,
        titleTextStyle: AppTextStyles.bodyStrong,
        subtitleTextStyle: AppTextStyles.caption,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        side: const BorderSide(color: AppColors.border),
        shape: const StadiumBorder(),
        showCheckmark: false,
        labelStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        secondaryLabelStyle: AppTextStyles.body.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        extendedTextStyle: AppTextStyles.bodyBold,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: _buttonShape,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.bodyBold,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: _buttonShape,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.border),
          textStyle: AppTextStyles.bodyStrong,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: AppTextStyles.bodyStrong),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
