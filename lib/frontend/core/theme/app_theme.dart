import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Light va dark `ThemeData` ta'riflari.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.danger,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      dividerColor: AppColors.divider,
      textTheme: GoogleFonts.poppinsTextTheme(
        _textTheme(AppColors.textPrimary, AppColors.textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardColor: AppColors.surface,
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      inputDecorationTheme: _inputTheme(
        fill: AppColors.inputFill,
        hint: AppColors.textMuted,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.accent,
        surface: AppColors.darkSurface,
        error: AppColors.danger,
        onPrimary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
      ),
      dividerColor: AppColors.darkDivider,
      textTheme: GoogleFonts.poppinsTextTheme(
        _textTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      ),
      cardColor: AppColors.darkSurface,
      iconTheme: const IconThemeData(color: AppColors.darkTextSecondary),
      inputDecorationTheme: _inputTheme(
        fill: AppColors.darkInputFill,
        hint: AppColors.darkTextSecondary,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: AppTextStyles.display.copyWith(color: primary),
      headlineMedium: AppTextStyles.h1.copyWith(color: primary),
      titleLarge: AppTextStyles.h2.copyWith(color: primary),
      titleMedium: AppTextStyles.h3.copyWith(color: primary),
      titleSmall: AppTextStyles.title.copyWith(color: primary),
      bodyMedium: AppTextStyles.body.copyWith(color: primary),
      bodySmall: AppTextStyles.caption.copyWith(color: secondary),
      labelLarge: AppTextStyles.button.copyWith(color: primary),
      labelSmall: AppTextStyles.label.copyWith(color: secondary),
    );
  }

  static InputDecorationTheme _inputTheme({
    required Color fill,
    required Color hint,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      hintStyle: AppTextStyles.body.copyWith(color: hint),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      border: border(Colors.transparent),
      enabledBorder: border(Colors.transparent),
      focusedBorder: border(AppColors.primary, 1.4),
      errorBorder: border(AppColors.danger),
      focusedErrorBorder: border(AppColors.danger, 1.4),
    );
  }
}
