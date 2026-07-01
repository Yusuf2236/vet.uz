import 'package:flutter/material.dart';

/// Markaviy rang palitrasi — butun ilova bo'ylab faqat shu yerdagi
/// ranglardan foydalaniladi. Hech qayerda "magic" hex yozilmaydi.
class AppColors {
  AppColors._();

  // ---- Brend ranglari ----
  static const Color primary = Color(0xFF15795C); // asosiy yashil
  static const Color primaryDark = Color(0xFF0F5C44);
  static const Color primaryLight = Color(0xFF2E9B73);
  static const Color accent = Color(0xFFF5A623); // logotipdagi to'q sariq

  // ---- Onboarding fon ranglari ----
  static const Color obGreen = Color(0xFF15795C);
  static const Color obGreen2 = Color(0xFF2E7D32);
  static const Color obOrange = Color(0xFFE8550E);
  static const Color obPurple = Color(0xFF4527A0);
  static const Color obRed = Color(0xFFC0392B);

  // ---- Favqulodda yordam (gradient) ----
  static const Color emergency = Color(0xFFC0392B);
  static const Color emergencyDark = Color(0xFF8E1B33);

  // ---- Sirtlar (light) ----
  static const Color background = Color(0xFFF1F5F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color inputFill = Color(0xFFEAEFED);
  static const Color divider = Color(0xFFE3EAE7);

  // ---- Matn (light) ----
  static const Color textPrimary = Color(0xFF15211D);
  static const Color textSecondary = Color(0xFF6B7B74);
  static const Color textMuted = Color(0xFF9AA8A2);

  // ---- Sirtlar (dark) ----
  static const Color darkBackground = Color(0xFF0E1513);
  static const Color darkSurface = Color(0xFF18211E);
  static const Color darkInputFill = Color(0xFF222D29);
  static const Color darkDivider = Color(0xFF2A352F);

  // ---- Matn (dark) ----
  static const Color darkTextPrimary = Color(0xFFF1F5F3);
  static const Color darkTextSecondary = Color(0xFFA7B5AE);

  // ---- Holat ranglari ----
  static const Color success = Color(0xFF16795C);
  static const Color warning = Color(0xFFF5A623);
  static const Color danger = Color(0xFFC0392B);
  static const Color info = Color(0xFF2D7FF9);
  static const Color star = Color(0xFFF5A623);

  // ---- Kategoriya tagrang (tint) juftliklari ----
  static const Color tealTint = Color(0xFFDDF0E9);
  static const Color teal = Color(0xFF15795C);
  static const Color blueTint = Color(0xFFDCE9FB);
  static const Color blue = Color(0xFF2D7FF9);
  static const Color purpleTint = Color(0xFFEADFF6);
  static const Color purple = Color(0xFF7B3FE4);
  static const Color amberTint = Color(0xFFFCEFCF);
  static const Color amber = Color(0xFFE0930B);
  static const Color greenTint = Color(0xFFDFF1DD);
  static const Color green = Color(0xFF2E9B36);
  static const Color redTint = Color(0xFFFBE0DC);
  static const Color red = Color(0xFFE0533F);
  static const Color cyanTint = Color(0xFFD6F0F2);
  static const Color cyan = Color(0xFF1B9AA8);
  static const Color greyTint = Color(0xFFE7ECEA);
  static const Color grey = Color(0xFF7A8A83);
  static const Color pinkTint = Color(0xFFFBE0EC);
  static const Color pink = Color(0xFFE0418A);
}
