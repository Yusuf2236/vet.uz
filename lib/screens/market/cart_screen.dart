import 'package:flutter/material.dart';

import '../../backend/repositories/auth_repository.dart';
import '../../core/router/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/state/cart_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../backend/repositories/order_repository.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/product.dart';
import '../../widgets/price_text.dart';
import '../../widgets/primary_button.dart';

/// Savat ekrani — mahsulotlar, miqdor boshqaruvi va buyurtma berish.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _checkout(BuildContext context, CartController cart) async {
    if (!AuthRepository().isLoggedIn) {
      final ok = await Navigator.of(context).pushNamed(AppRoutes.login);
      if (ok != true || !context.mounted) return;
    }
    final method = await _pickPayment(context);
    if (method == null || !context.mounted) return;

    final items = Map<Product, int>.from(cart.items);
    final total = cart.total;
    final ok = await OrderRepository().createOrder(items, total);
    if (ok) cart.clear();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            ok ? '${AppStrings.orderPlaced} · $method' : 'Xatolik yuz berdi',
          ),
        ),
      );
    if (ok) Navigator.of(context).pop();
  }

  /// To'lov usulini tanlash (O'zbekiston: Naqd / Click / Payme / Uzum).
  Future<String?> _pickPayment(BuildContext context) {
    const methods = [
      (name: 'Naqd (yetkazishda)', icon: Icons.payments_outlined),
      (name: 'Click', icon: Icons.account_balance_wallet_outlined),
      (name: 'Payme', icon: Icons.qr_code_2_outlined),
      (name: 'Uzum', icon: Icons.credit_card_outlined),
    ];
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text("To'lov usuli", style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.sm),
            for (final m in methods)
              ListTile(
                leading: Icon(m.icon, color: AppColors.primary),
                title: Text(m.name, style: AppTextStyles.title),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                ),
                onTap: () => Navigator.pop(ctx, m.name),
              ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final entries = cart.items.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppStrings.cartTitle} (${cart.count})',
          style: AppTextStyles.h3,
        ),
      ),
      body: cart.isEmpty
          ? _EmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.screenH),
                    itemCount: entries.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, i) => _CartRow(
                      product: entries[i].key,
                      qty: entries[i].value,
                      cart: cart,
                    ),
                  ),
                ),
                _CheckoutBar(
                  total: cart.total,
                  onCheckout: () => _checkout(context, cart),
                ),
              ],
            ),
    );
  }
}

class _CartRow extends StatelessWidget {
  final Product product;
  final int qty;
  final CartController cart;

  const _CartRow({
    required this.product,
    required this.qty,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: product.tint,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(product.icon, color: product.color, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: titleColor),
                ),
                const SizedBox(height: 4),
                PriceText(amount: product.priceSom, color: AppColors.primary),
              ],
            ),
          ),
          _QtyStepper(
            qty: qty,
            onMinus: () => cart.decrement(product),
            onPlus: () => cart.add(product),
          ),
        ],
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _QtyStepper({
    required this.qty,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepBtn(icon: Icons.remove, onTap: onMinus),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('$qty', style: AppTextStyles.bodyStrong),
        ),
        _StepBtn(icon: Icons.add, onTap: onPlus),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final int total;
  final VoidCallback onCheckout;

  const _CheckoutBar({required this.total, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.totalLabel,
                  style: AppTextStyles.caption.copyWith(color: secondary),
                ),
                PriceText(
                  amount: total,
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: PrimaryButton(
                label: AppStrings.checkout,
                onPressed: onCheckout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(AppStrings.cartEmpty, style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.cartEmptyBody,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: secondary),
            ),
          ],
        ),
      ),
    );
  }
}
