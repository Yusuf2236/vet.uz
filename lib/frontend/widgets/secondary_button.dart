import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Ikkilamchi (chizilgan/outlined) tugma.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final Color? foreground;
  final Color? borderColor;
  final bool expanded;
  final double height;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.foreground,
    this.borderColor,
    this.expanded = true,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveForeground = foreground ?? Theme.of(context).colorScheme.onSurface;
    final effectiveBorderColor = borderColor ?? Theme.of(context).dividerColor;

    final button = SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveForeground,
          side: BorderSide(color: effectiveBorderColor, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
        child: Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 18, color: effectiveForeground),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppTextStyles.button.copyWith(color: effectiveForeground),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
