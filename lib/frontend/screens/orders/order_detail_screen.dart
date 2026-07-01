import 'package:flutter/material.dart';

import '../../../backend/repositories/order_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/order.dart';
import '../../models/order_item.dart';
import '../../widgets/price_text.dart';

/// Buyurtma tafsiloti — mahsulotlar va jami.
class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  // Future bir marta yaratiladi (build() ichida emas) — aks holda tema almashsa
  // qayta-qayta yuklab, spinner miltillaydi.
  late final Future<List<OrderItem>> _future = OrderRepository().fetchItems(
    widget.order.id,
  );

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final d = order.createdAt;

    return Scaffold(
      appBar: AppBar(
        title: Text('Buyurtma #${order.id}', style: AppTextStyles.h3),
      ),
      body: FutureBuilder<List<OrderItem>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data ?? const <OrderItem>[];
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}',
                    style: AppTextStyles.body.copyWith(color: secondary),
                  ),
                  Text(
                    order.statusLabel,
                    style: AppTextStyles.bodyStrong.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Mahsulotlar',
                style: AppTextStyles.h3.copyWith(color: titleColor),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final it in items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${it.productName}  ×${it.quantity}',
                          style: AppTextStyles.body.copyWith(color: titleColor),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      PriceText(amount: it.lineTotal),
                    ],
                  ),
                ),
              Divider(color: Theme.of(context).dividerColor),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jami',
                    style: AppTextStyles.h3.copyWith(color: titleColor),
                  ),
                  PriceText(
                    amount: order.totalSom,
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
