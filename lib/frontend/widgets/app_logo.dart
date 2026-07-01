import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// VetUz brend belgisi — uchta rangli vertikal ustun (mini diagramma).
/// [boxed] true bo'lsa, oq/rangli yumaloq kvadrat ichida chiqadi.
class AppLogo extends StatelessWidget {
  final double size;
  final bool boxed;
  final Color boxColor;

  /// Ustunlar rangi (null bo'lsa brend ranglari ishlatiladi).
  final List<Color>? barColors;

  const AppLogo({
    super.key,
    this.size = 72,
    this.boxed = true,
    this.boxColor = Colors.white,
    this.barColors,
  });

  /// Yashil kvadrat ichidagi kichik belgi (sarlavha/login uchun).
  const AppLogo.badge({super.key, this.size = 44})
    : boxed = true,
      boxColor = AppColors.primary,
      barColors = const [Colors.white, Color(0xFF8FE3C6), AppColors.accent];

  @override
  Widget build(BuildContext context) {
    final mark = _LogoMark(size: size * 0.5, colors: barColors);
    if (!boxed) return mark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(child: mark),
    );
  }
}

class _LogoMark extends StatelessWidget {
  final double size;
  final List<Color>? colors;
  const _LogoMark({required this.size, this.colors});

  @override
  Widget build(BuildContext context) {
    final palette =
        colors ??
        const [AppColors.primary, AppColors.primaryLight, AppColors.accent];
    final barW = size * 0.22;
    Widget bar(double heightFactor, Color color) {
      return Container(
        width: barW,
        height: size * heightFactor,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(barW),
        ),
      );
    }

    return SizedBox(
      height: size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          bar(0.78, palette[0]),
          SizedBox(width: barW * 0.55),
          bar(1.0, palette[1]),
          SizedBox(width: barW * 0.55),
          bar(0.6, palette[2]),
        ],
      ),
    );
  }
}
