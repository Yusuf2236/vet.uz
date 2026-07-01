import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Drifting, glassmorphic blurred gradient orbs for a premium live background.
class AnimatedBackgroundOrbs extends StatefulWidget {
  const AnimatedBackgroundOrbs({super.key});

  @override
  State<AnimatedBackgroundOrbs> createState() => _AnimatedBackgroundOrbsState();
}

class _AnimatedBackgroundOrbsState extends State<AnimatedBackgroundOrbs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Dynamic background colors
    final baseBg = isDark ? const Color(0xFF0F1713) : const Color(0xFFF6F8F7);
    final orb1Color = AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.08);
    final orb2Color = AppColors.primaryLight.withValues(alpha: isDark ? 0.10 : 0.06);

    return Stack(
      children: [
        // Base background color
        Container(color: baseBg),

        // Animated Orbs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value * 2 * pi;
            
            // Orb 1 offsets
            final dx1 = 45 * sin(t);
            final dy1 = 30 * cos(t);

            // Orb 2 offsets
            final dx2 = 35 * cos(t + 1.2);
            final dy2 = 50 * sin(t + 1.2);

            return Stack(
              children: [
                // Orb 1 (Top Right area)
                Positioned(
                  top: 40 + dy1,
                  right: -50 + dx1,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: orb1Color,
                    ),
                  ),
                ),

                // Orb 2 (Bottom Left area)
                Positioned(
                  bottom: 80 + dy2,
                  left: -90 + dx2,
                  child: Container(
                    width: 340,
                    height: 340,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: orb2Color,
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Blur Filter to turn orbs into soft gradients
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 95.0, sigmaY: 95.0),
            child: const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
