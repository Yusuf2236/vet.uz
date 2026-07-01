import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class _Notif {
  final IconData icon;
  final Color color;
  final Color tint;
  final String title;
  final String body;
  final String time;
  final bool unread;
  const _Notif(
    this.icon,
    this.color,
    this.tint,
    this.title,
    this.body,
    this.time,
    this.unread,
  );
}

/// Bildirishnomalar ekrani.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const List<_Notif> _items = [
    _Notif(
      Icons.vaccines_outlined,
      AppColors.teal,
      AppColors.tealTint,
      'Emlash eslatmasi',
      'Itingiz uchun quturish vaksinasi muddati yaqin.',
      '2 soat oldin',
      true,
    ),
    _Notif(
      Icons.shopping_bag_outlined,
      AppColors.amber,
      AppColors.amberTint,
      'Buyurtma yetkazildi',
      'Royal Canin yem buyurtmangiz yetkazib berildi.',
      'Kecha',
      true,
    ),
    _Notif(
      Icons.local_fire_department,
      AppColors.danger,
      AppColors.redTint,
      'Maxsus taklif',
      "Birinchi veterinar ko'rik bepul — shoshiling!",
      '2 kun oldin',
      false,
    ),
    _Notif(
      Icons.eco_outlined,
      AppColors.green,
      AppColors.greenTint,
      'Ferma hisoboti',
      'Bugungi sut hosili: 2,350 litr.',
      '3 kun oldin',
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.notificationsTitle,
          style: AppTextStyles.h3,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, i) {
          final n = _items[i];
          return Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: n.unread
                    ? AppColors.primary.withValues(alpha: 0.35)
                    : Theme.of(context).dividerColor,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: n.tint,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(n.icon, color: n.color, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              style: AppTextStyles.title.copyWith(
                                color: titleColor,
                              ),
                            ),
                          ),
                          Text(
                            n.time,
                            style: AppTextStyles.label.copyWith(
                              color: secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        n.body,
                        style: AppTextStyles.caption.copyWith(color: secondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
