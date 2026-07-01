import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Soddalashtirilgan "xarita" foni (ko'cha chiziqlari taqlidi).
/// Haqiqiy xarita uchun keyinchalik google_maps_flutter ulanadi.
class MapBackdrop extends StatelessWidget {
  const MapBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF12201B) : const Color(0xFFE9EFEA),
      child: CustomPaint(
        painter: _MapPainter(isDark: isDark),
        size: Size.infinite,
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final bool isDark;
  _MapPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = (isDark ? Colors.white : Colors.white).withValues(alpha: 0.55)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final thin = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.12)
      ..strokeWidth = 2;

    // Yirik ko'chalar
    canvas.drawLine(
      Offset(0, size.height * 0.32),
      Offset(size.width, size.height * 0.26),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.28, 0),
      Offset(size.width * 0.36, size.height),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.75, 0),
      Offset(size.width * 0.68, size.height),
      road,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.76),
      road,
    );

    // Mayda to'r
    for (double y = 0; y < size.height; y += 46) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), thin);
    }
    for (double x = 0; x < size.width; x += 46) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), thin);
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
