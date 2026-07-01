import 'package:flutter/material.dart';

/// Splash foni — tashqariga kengayib yo'qoladigan radar/sonar to'lqinlari
/// (uzluksiz pulsatsiya).
class RadarRings extends StatefulWidget {
  final Color color;
  final int waves;
  final Alignment center;

  const RadarRings({
    super.key,
    this.color = Colors.white,
    this.waves = 4,
    this.center = const Alignment(0, -0.15),
  });

  @override
  State<RadarRings> createState() => _RadarRingsState();
}

class _RadarRingsState extends State<RadarRings>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4500),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(
          painter: _RadarPainter(
            progress: _controller.value,
            color: widget.color,
            waves: widget.waves,
            center: widget.center,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int waves;
  final Alignment center;

  _RadarPainter({
    required this.progress,
    required this.color,
    required this.waves,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(
      size.width * (0.5 + center.x * 0.5),
      size.height * (0.5 + center.y * 0.5),
    );
    final maxR = size.longestSide * 0.7;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    for (int i = 0; i < waves; i++) {
      // Har bir to'lqin o'z fazasida — birin-ketin kengayadi.
      final t = (progress + i / waves) % 1.0;
      final radius = maxR * t;
      // Kengaygan sari xira tortadi.
      final alpha = (1.0 - t) * 0.18;
      paint.color = color.withValues(alpha: alpha);
      canvas.drawCircle(origin, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
