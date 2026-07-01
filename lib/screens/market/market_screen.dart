import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/state/cart_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../backend/repositories/product_repository.dart';
import '../../models/product.dart';
import '../../widgets/circle_icon_button.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_field.dart';
import 'cart_screen.dart';
import 'widgets/filter_chips.dart';

/// Marketplace ekrani — mahsulotlarni repository orqali yuklaydi
/// (Supabase yoki MockData), kategoriya bo'yicha filtrlaydi.
class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final ProductRepository _repo = ProductRepository();
  late Stream<List<Product>> _stream = _repo.watchProducts();
  int _filter = 0;

  void _reload() => setState(() => _stream = _repo.watchProducts());

  List<Product> _visible(List<Product> all) {
    final category = MockData.marketCategories[_filter];
    if (category == 'Hammasi') return all;
    return all.where((p) => p.category == category).toList();
  }

  void _addToCart(Product p) {
    CartScope.of(context).add(p);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${p.name} ${AppStrings.addedToCart}'),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  void _openCart() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);

    return SafeArea(
      bottom: false,
      child: StreamBuilder<List<Product>>(
        stream: _stream,
        builder: (context, snap) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _header(context, cart)),
              if (snap.connectionState == ConnectionState.waiting)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (snap.hasError)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ErrorState(onRetry: _reload),
                )
              else
                ..._grid(_visible(snap.data ?? const [])),
            ],
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context, CartController cart) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.md,
        AppSpacing.screenH,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.marketTitle,
                      style: AppTextStyles.h1.copyWith(color: titleColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.marketSub,
                      style: AppTextStyles.caption.copyWith(color: secondary),
                    ),
                  ],
                ),
              ),
              CircleIconButton(
                icon: Icons.shopping_cart_outlined,
                badge: cart.count > 0 ? '${cart.count}' : null,
                onTap: _openCart,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const SearchField(hint: AppStrings.searchHint),
          const SizedBox(height: AppSpacing.lg),
          FilterChips(
            items: MockData.marketCategories,
            selected: _filter,
            onSelected: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  List<Widget> _grid(List<Product> products) {
    if (products.isEmpty) {
      return [
        const SliverFillRemaining(hasScrollBody: false, child: _EmptyState()),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          0,
          AppSpacing.screenH,
          AppSpacing.xxl,
        ),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.66,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, i) => ProductCard(
              product: products[i],
              onAdd: () => _addToCart(products[i]),
            ),
            childCount: products.length,
          ),
        ),
      ),
    ];
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 56,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Bu kategoriyada mahsulot yo\'q',
              style: AppTextStyles.body.copyWith(color: secondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 56, color: AppColors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Ma\'lumotni yuklab bo\'lmadi',
              style: AppTextStyles.body.copyWith(color: secondary),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Qayta urinish'),
            ),
          ],
        ),
      ),
    );
  }
}
