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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Pressable(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: isDark
                  ? item.color.withValues(alpha: 0.08)
                  : item.tint.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: item.color.withValues(alpha: isDark ? 0.22 : 0.12),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: item.color.withValues(alpha: isDark ? 0.04 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                item.icon,
                color: isDark ? item.color.withValues(alpha: 0.95) : item.color,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

