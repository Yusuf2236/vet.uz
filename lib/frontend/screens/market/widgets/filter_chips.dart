import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Gorizontal tanlanadigan filtr "chip"lari.
class FilterChips extends StatelessWidget {
  final List<String> items;
  final int selected;
  final ValueChanged<int> onSelected;

  const FilterChips({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final active = i == selected;
          final inactiveText = Theme.of(context).textTheme.bodyMedium?.color;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: active
                      ? AppColors.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Text(
                items[i],
                style: AppTextStyles.bodyStrong.copyWith(
                  color: active ? Colors.white : inactiveText,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
