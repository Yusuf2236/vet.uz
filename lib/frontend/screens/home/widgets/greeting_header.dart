import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../backend/repositories/auth_repository.dart';
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
    final isLoggedIn = AuthRepository().isLoggedIn;
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Pressable(
            onTap: onAvatarTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoggedIn ? AppStrings.greeting : "Xush kelibsiz,",
                  style: AppTextStyles.body.copyWith(color: secondary),
                ),
                const SizedBox(height: 2),
                Text(
                  isLoggedIn ? '${user.fullName} 👋' : 'Tizimga kiring 👋',
                  style: AppTextStyles.h2.copyWith(color: titleColor),
                ),
              ],
            ),
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
            child: isLoggedIn
                ? (user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                    ? ClipOval(
                        child: user.avatarUrl!.startsWith('http')
                            ? Image.network(
                                user.avatarUrl!,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(user.avatarUrl!),
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Text(
                                  TextUtils.initials(user.fullName),
                                  style: AppTextStyles.bodyStrong.copyWith(color: Colors.white),
                                ),
                              ),
                      )
                    : Text(
                        TextUtils.initials(user.fullName),
                        style: AppTextStyles.bodyStrong.copyWith(color: Colors.white),
                      ))
                : const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 24,
                  ),
          ),
        ),
      ],
    );
  }
}
