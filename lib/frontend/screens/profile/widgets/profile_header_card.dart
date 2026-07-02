import 'dart:io';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: user.isPro
                    ? [const Color(0xFFFFD700), const Color(0xFFFFA000), AppColors.amber]
                    : (user.isVerified
                        ? [AppColors.primaryLight, AppColors.primary]
                        : [Theme.of(context).dividerColor, Theme.of(context).dividerColor]),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.darkSurface : AppColors.surface,
              ),
              child: ClipOval(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                      ? (user.avatarUrl!.startsWith('http')
                          ? Image.network(
                              user.avatarUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(user.avatarUrl!),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [AppColors.primaryLight, AppColors.primary],
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  TextUtils.initials(user.fullName),
                                  style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ))
                      : RemoteImage(
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
                              style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.fullName,
                  style: AppTextStyles.h2.copyWith(color: titleColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
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
                        icon: Icons.verified_rounded,
                        color: AppColors.success,
                      ),
                    if (user.isVerified && user.isPro)
                      const SizedBox(width: AppSpacing.sm),
                    if (user.isPro)
                      const _Badge(
                        label: AppStrings.pro,
                        icon: Icons.stars_rounded,
                        color: AppColors.amber,
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

  const _Badge({
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
