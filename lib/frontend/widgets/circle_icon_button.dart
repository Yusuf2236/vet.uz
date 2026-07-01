import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import 'pressable.dart';

/// Dumaloq ikonkali tugma (sarlavhadagi tema almashtirish, bildirishnoma...).
/// [badge] berilsa, o'ng yuqori burchakda kichik nishon chiqadi.
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? badge;
  final double size;

  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.badge,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).cardColor;
    final iconColor = Theme.of(context).textTheme.titleMedium?.color;

    return Pressable(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
                ),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            if (badge != null)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
