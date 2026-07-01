import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../models/category_item.dart';
import '../../../widgets/category_tile.dart';

/// Kategoriyalar to'ri (4 ustun).
class CategoryGrid extends StatelessWidget {
  final List<CategoryItem> items;
  final void Function(CategoryItem item)? onTap;

  const CategoryGrid({super.key, required this.items, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, i) => CategoryTile(
        item: items[i],
        onTap: onTap == null ? null : () => onTap!(items[i]),
      ),
    );
  }
}
