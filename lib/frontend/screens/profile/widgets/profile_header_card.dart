import 'package:flutter/material.dart';

import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/text_utils.dart';
import '../../../models/user_profile.dart';
import '../../../widgets/remote_image.dart';

/// Profil yuqori kartasi — avatar, ism, rol, nishonlar.
class ProfileHeaderCard extends StatelessWidget {
  final UserProfile user;

  const ProfileHeaderCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox(
              width: 64,
              height: 64,
              child: RemoteImage(
                url: AppImages.avatar(user.fullName),
                fallbackBuilder: (context) => Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primaryLight, AppColors.primary],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    TextUtils.initials(user.fullName),
                    style: AppTextStyles.h1.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.fullName,
                  style: AppTextStyles.h2.copyWith(color: titleColor),
                ),
                const SizedBox(height: 2),
                Text(
                  '${user.role} · ${user.city}',
                  style: AppTextStyles.caption.copyWith(color: secondary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    if (user.isVerified)
                      const _Badge(
                        label: AppStrings.verified,
                        icon: Icons.verified,
                        color: AppColors.success,
                        tint: AppColors.tealTint,
                      ),
                    if (user.isVerified && user.isPro)
                      const SizedBox(width: AppSpacing.sm),
                    if (user.isPro)
                      const _Badge(
                        label: AppStrings.pro,
                        color: AppColors.amber,
                        tint: AppColors.amberTint,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color tint;

  const _Badge({
    required this.label,
    required this.color,
    required this.tint,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(label, style: AppTextStyles.label.copyWith(color: color)),
        ],
      ),
    );
  }
}
