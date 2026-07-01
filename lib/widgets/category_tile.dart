import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/category_item.dart';
import 'pressable.dart';

/// Asosiy ekrandagi bitta kategoriya katakchasi (ikonka + nom).
class CategoryTile extends StatelessWidget {
  final CategoryItem item;
  final VoidCallback? onTap;

  const CategoryTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Pressable(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
              ),
            ),
            child: Center(
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: item.tint,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
