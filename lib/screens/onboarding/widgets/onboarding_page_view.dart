import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/onboarding_item.dart';
import '../../../widgets/remote_image.dart';
import 'page_progress.dart';

/// Bitta onboarding sahifasi: tepada rangli rasm kartasi, pastda oq panel
/// (progress + sarlavha + tavsif).
class OnboardingPageView extends StatelessWidget {
  final OnboardingItem item;
  final int index;
  final int total;

  const OnboardingPageView({
    super.key,
    required this.item,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final sheetColor = Theme.of(context).scaffoldBackgroundColor;
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final bodyColor = Theme.of(context).textTheme.bodySmall?.color;

    return Column(
      children: [
        // Rangli yuqori qism + rasm o'rni
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: item.gradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(child: _ImageCard(item: item)),
          ),
        ),
        // Oq panel
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: sheetColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.xl),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.xl,
              AppSpacing.xxl,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageProgress(current: index, total: total),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  item.title,
                  style: AppTextStyles.h1.copyWith(color: titleColor),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  item.body,
                  style: AppTextStyles.body.copyWith(color: bodyColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageCard extends StatelessWidget {
  final OnboardingItem item;
  const _ImageCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: SizedBox.expand(
              child: RemoteImage(
                url: item.imageUrl,
                fallbackBuilder: (context) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      item.icon,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(item.badgeIcon, color: item.gradient.last, size: 26),
            ),
          ),
        ],
      ),
    );
  }
}
