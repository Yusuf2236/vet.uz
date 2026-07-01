import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Asosiy to'ldirilgan tugma (yashil, pill shaklida).
/// [loading] true bo'lsa spinner ko'rsatadi va bosishni bloklaydi.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;
  final Color background;
  final Color foreground;
  final bool expanded;
  final bool loading;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    this.background = AppColors.primary,
    this.foreground = Colors.white,
    this.expanded = true,
    this.loading = false,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    // Yuklanayotganda bosishni bloklaymiz (double-tap oldini olish).
    final effectiveOnPressed = loading ? null : onPressed;

    final button = SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: background.withValues(
            alpha: loading ? 0.85 : 0.5,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
        child: loading
            ? Semantics(
                label: AppStrings.loading,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(foreground),
                  ),
                ),
              )
            : Row(
                mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        style: AppTextStyles.button.copyWith(color: foreground),
                      ),
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Icon(trailingIcon, size: 18, color: foreground),
                  ],
                ],
              ),
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
