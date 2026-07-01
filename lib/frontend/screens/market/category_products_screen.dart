import 'package:flutter/material.dart';

import '../../../backend/repositories/product_repository.dart';
import '../../core/state/cart_controller.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/product.dart';
import '../../widgets/async_view.dart';
import '../../widgets/circle_icon_button.dart';
import '../../widgets/product_card.dart';
import 'cart_screen.dart';

/// Kategoriya bo'yicha mahsulotlar (Dorixona / Pet Shop / Market).
/// [allowed] bo'sh bo'lsa — barcha mahsulotlar.
class CategoryProductsScreen extends StatefulWidget {
  final String title;
  final Set<String> allowed;

  const CategoryProductsScreen({
    super.key,
    required this.title,
    this.allowed = const {},
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late Future<List<Product>> _future = ProductRepository().fetchProducts();

  void _reload() =>
      setState(() => _future = ProductRepository().fetchProducts());

  List<Product> _filter(List<Product> all) => widget.allowed.isEmpty
      ? all
      : all.where((p) => widget.allowed.contains(p.category)).toList();

  void _add(Product p) {
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

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: AppTextStyles.h3),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: CircleIconButton(
              icon: Icons.shopping_cart_outlined,
              badge: cart.count > 0 ? '${cart.count}' : null,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const CartScreen()),
              ),
            ),
          ),
        ],
      ),
      body: AsyncView<List<Product>>(
        future: _future,
        onRetry: _reload,
        isEmpty: (all) => _filter(all).isEmpty,
        emptyMessage: 'Bu kategoriyada mahsulot yo\'q',
        builder: (context, all) {
          final products = _filter(all);
          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.66,
            ),
            itemCount: products.length,
            itemBuilder: (context, i) => ProductCard(
              product: products[i],
              onAdd: () => _add(products[i]),
            ),
          );
        },
      ),
    );
  }
}
