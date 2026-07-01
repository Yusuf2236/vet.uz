import 'package:flutter/material.dart';

import '../core/constants/app_images.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/veterinarian.dart';
import 'pressable.dart';
import 'price_text.dart';
import 'remote_image.dart';

/// Veterinar kartasi — avatar, ism, mutaxassislik, reyting, masofa, narx.
class VetCard extends StatelessWidget {
  final Veterinarian vet;
  final VoidCallback? onTap;

  const VetCard({super.key, required this.vet, this.onTap});

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).cardColor;
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.7),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Avatar(name: vet.name, initials: vet.initials),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    vet.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title.copyWith(color: titleColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    vet.specialty,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(color: secondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.star, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        vet.rating.toStringAsFixed(1),
                        style: AppTextStyles.caption.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('·', style: TextStyle(color: secondary)),
                      const SizedBox(width: 6),
                      Text(
                        '${vet.distanceKm.toStringAsFixed(1)} km',
                        style: AppTextStyles.caption.copyWith(color: secondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                _AvailabilityChip(available: vet.isAvailable),
                const SizedBox(height: AppSpacing.md),
                PriceText(amount: vet.priceSom),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String initials;
  const _Avatar({required this.name, required this.initials});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: SizedBox(
        width: 52,
        height: 52,
        child: RemoteImage(
          url: AppImages.avatar(name),
          fallbackBuilder: (context) => Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryLight, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _AvailabilityChip extends StatelessWidget {
  final bool available;
  const _AvailabilityChip({required this.available});

  @override
  Widget build(BuildContext context) {
    final color = available ? AppColors.success : AppColors.textMuted;
    final label = available ? AppStrings.free : AppStrings.busy;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(label, style: AppTextStyles.label.copyWith(color: color)),
    );
  }
}
