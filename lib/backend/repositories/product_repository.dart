import 'package:flutter/material.dart';

import '../supabase_service.dart';
import '../../core/theme/app_colors.dart';
import '../../models/product.dart';
import '../../data/mock_data.dart';
import 'mock_realtime.dart';

/// Mahsulotlar manbai (Supabase yoki MockData).
/// Vizual maydonlar (ikonka/rang) DB'da saqlanmaydi — kategoriya bo'yicha
/// shu yerda biriktiriladi.
class ProductRepository {
  Future<List<Product>> fetchProducts() async {
    if (!SupabaseService.isReady) return MockData.products;
    try {
      final rows = await SupabaseService.client.from('products').select();
      if (rows.isEmpty) return MockData.products;
      return rows.map(_fromMap).toList();
    } catch (_) {
      // Jadval hali yaratilmagan yoki tarmoq xatosi — lokalga tushamiz.
      return MockData.products;
    }
  }

  /// Real-time oqim — Supabase Realtime orqali jonli yangilanadi.
  /// (Dashboard → Database → Replication da `products` yoqilishi kerak.)
  /// Backendsiz bitta martalik MockData oqimini qaytaradi.
  Stream<List<Product>> watchProducts() {
    if (!SupabaseService.isReady) {
      // Backendsiz — localhost'da real-time'ni ko'rsatish uchun har 3 soniyada
      // bir mahsulotda chegirma jonli paydo bo'ladi/yo'qoladi.
      return simulatedStream<Product>(MockData.products, (current, tick) {
        final i = tick % current.length;
        return [
          for (var k = 0; k < current.length; k++)
            if (k == i)
              current[k].hasDiscount
                  ? current[k].copyWith(clearOldPrice: true)
                  : current[k].copyWith(
                      oldPriceSom: (current[k].priceSom * 1.2).round(),
                    )
            else
              current[k],
        ];
      });
    }
    return SupabaseService.client
        .from('products')
        .stream(primaryKey: ['id'])
        .map(
          (rows) =>
              rows.isEmpty ? MockData.products : rows.map(_fromMap).toList(),
        );
  }

  Product _fromMap(Map<String, dynamic> m) {
    final category = m['category'] as String? ?? '';
    final v = _visual(category);
    return Product(
      name: m['name'] as String? ?? '',
      category: category,
      priceSom: (m['price_som'] as num?)?.toInt() ?? 0,
      oldPriceSom: (m['old_price_som'] as num?)?.toInt(),
      rating: (m['rating'] as num?)?.toDouble() ?? 0,
      icon: v.icon,
      color: v.color,
      tint: v.tint,
    );
  }

  _Visual _visual(String category) {
    switch (category) {
      case 'Vitaminlar':
        return const _Visual(
          Icons.medication_liquid_outlined,
          AppColors.green,
          AppColors.greenTint,
        );
      case 'Oziq-ovqat':
        return const _Visual(
          Icons.pets_outlined,
          AppColors.amber,
          AppColors.amberTint,
        );
      case 'Jihozlar':
        return const _Visual(
          Icons.inventory_2_outlined,
          AppColors.grey,
          AppColors.greyTint,
        );
      case 'Dorilar':
      default:
        return const _Visual(
          Icons.vaccines_outlined,
          AppColors.teal,
          AppColors.tealTint,
        );
    }
  }
}

class _Visual {
  final IconData icon;
  final Color color;
  final Color tint;
  const _Visual(this.icon, this.color, this.tint);
}
