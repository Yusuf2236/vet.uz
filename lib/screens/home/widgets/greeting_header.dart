import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/text_utils.dart';
import '../../../models/user_profile.dart';
import '../../../widgets/pressable.dart';

/// Salomlashish bloki: "Xayrli kun, [ism] 👋" + avatar.
class GreetingHeader extends StatelessWidget {
  final UserProfile user;
  final VoidCallback? onAvatarTap;

  const GreetingHeader({super.key, required this.user, this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.greeting,
                style: AppTextStyles.body.copyWith(color: secondary),
              ),
              const SizedBox(height: 2),
              Text(
                '${user.fullName} 👋',
                style: AppTextStyles.h2.copyWith(color: titleColor),
              ),
            ],
          ),
        ),
        Pressable(
          onTap: onAvatarTap,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primaryLight, AppColors.primary],
              ),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              TextUtils.initials(user.fullName),
              style: AppTextStyles.bodyStrong.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
