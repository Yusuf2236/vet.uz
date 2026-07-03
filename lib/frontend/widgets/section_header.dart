import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'pressable.dart';

/// Bo'lim sarlavhasi: chapda nom, o'ngda ixtiyoriy "Barchasi" kabi havola.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? actionColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
        ),
        if (actionLabel != null)
          Pressable(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: AppTextStyles.bodyStrong.copyWith(
                color: actionColor ?? AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
