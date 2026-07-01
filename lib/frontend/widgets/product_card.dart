import 'package:flutter/material.dart';

import '../core/constants/app_images.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/product.dart';
import 'pressable.dart';
import 'price_text.dart';
import 'remote_image.dart';

/// Marketplace mahsulot kartasi (grid uchun).
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAdd;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onAdd, this.onTap});

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).cardColor;
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Pressable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.7),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rasm (internet bo'lsa real, aks holda ikonkali fallback)
            AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    RemoteImage(
                      url: AppImages.keyword(
                        _imageKeyword(product.category),
                        product.name.hashCode.abs() % 1000,
                      ),
                      fallbackBuilder: (context) => Container(
                        color: product.tint,
                        child: Center(
                          child: Icon(
                            product.icon,
                            size: 44,
                            color: product.color,
                          ),
                        ),
                      ),
                    ),
                    if (product.hasDiscount)
                      Positioned(
                        left: AppSpacing.sm,
                        top: AppSpacing.sm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            '-${_discountPercent(product)}%',
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: AppColors.star),
                      const SizedBox(width: 3),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: AppTextStyles.caption.copyWith(color: secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title.copyWith(color: titleColor),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.hasDiscount)
                              Text(
                                PriceText.format(product.oldPriceSom!),
                                style: AppTextStyles.label.copyWith(
                                  color: secondary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            PriceText(
                              amount: product.priceSom,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                      _AddButton(onTap: onAdd),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _discountPercent(Product p) {
    if (!p.hasDiscount) return 0;
    return (100 * (p.oldPriceSom! - p.priceSom) / p.oldPriceSom!).round();
  }

  String _imageKeyword(String category) {
    switch (category) {
      case 'Oziq-ovqat':
        return 'pet-food';
      case 'Vitaminlar':
        return 'vitamins';
      case 'Vaksinalar':
        return 'vaccine';
      case 'Antibiotiklar':
      case 'Dorilar':
      case 'Antiparazitar':
        return 'medicine';
      case 'Jihozlar':
      case 'Anjomlar':
        return 'veterinary,equipment';
      default:
        return 'pet';
    }
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _AddButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 20),
      ),
    );
  }
}
