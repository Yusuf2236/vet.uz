import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../backend/repositories/order_repository.dart';
import '../../models/order.dart';
import '../../widgets/price_text.dart';
import 'order_detail_screen.dart';

/// Foydalanuvchi buyurtmalari (Supabase yoki demo).
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final Stream<List<OrderModel>> _stream = OrderRepository().watchMyOrders();

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.orders, style: AppTextStyles.h3),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: _stream,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snap.data ?? const <OrderModel>[];
          if (orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                child: Text(
                  "Sizda hali buyurtma yo'q",
                  style: AppTextStyles.body.copyWith(color: secondary),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            itemCount: orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => OrderDetailScreen(order: orders[i]),
                ),
              ),
              child: _OrderCard(order: orders[i]),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  Color _statusColor(String status) {
    switch (status) {
      case 'delivered':
        return AppColors.success;
      case 'processing':
        return AppColors.info;
      case 'cancelled':
        return AppColors.danger;
      default:
        return AppColors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final c = _statusColor(order.status);
    final d = order.createdAt;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Buyurtma #${order.id}',
                style: AppTextStyles.title.copyWith(color: titleColor),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  order.statusLabel,
                  style: AppTextStyles.label.copyWith(color: c),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}'
            '${order.itemCount > 0 ? ' · ${order.itemCount} ta mahsulot' : ''}',
            style: AppTextStyles.caption.copyWith(color: secondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          PriceText(amount: order.totalSom, color: AppColors.primary),
        ],
      ),
    );
  }
}
