import 'package:flutter/material.dart';

import '../core/constants/app_info.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'app_logo.dart';

/// Sarlavhadagi brend: kichik belgi + "VetUz" yozuvi.
class BrandWordmark extends StatelessWidget {
  final double logoSize;

  const BrandWordmark({super.key, this.logoSize = 32});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo.badge(size: logoSize),
        const SizedBox(width: AppSpacing.sm),
        Text(
          AppInfo.name,
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
