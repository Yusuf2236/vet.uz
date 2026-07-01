import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Hali tayyor bo'lmagan bo'limlar uchun "tez orada" ekrani.
/// Real ekran qo'shilguncha tirik navigatsiya nuqtasi bo'lib turadi.
class ComingSoonScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const ComingSoonScreen({
    super.key,
    required this.title,
    this.icon = Icons.construction_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(title: Text(title, style: AppTextStyles.h3)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                AppStrings.comingSoon,
                style: AppTextStyles.h2.copyWith(color: titleColor),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.comingSoonBody,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(color: secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
