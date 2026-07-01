import '../supabase_service.dart';
import '../../models/order.dart';
import '../../models/order_item.dart';
import '../../models/product.dart';
import 'mock_realtime.dart';

/// Buyurtmalar manbai (Supabase `orders` + `order_items`).
class OrderRepository {
  /// Savatdan buyurtma yaratadi. Backend yoki sessiya bo'lmasa — demo (true).
  Future<bool> createOrder(Map<Product, int> items, int totalSom) async {
    if (!SupabaseService.isReady) return true;
    final client = SupabaseService.client;
    final uid = client.auth.currentUser?.id;
    if (uid == null) return true; // demo rejim: bazaga yozilmaydi
    try {
      final itemCount = items.values.fold<int>(0, (sum, q) => sum + q);
      final inserted = await client
          .from('orders')
          .insert({
            'user_id': uid,
            'total_som': totalSom,
            'status': 'new',
            'item_count': itemCount,
          })
          .select('id')
          .single();
      final orderId = inserted['id'];
      final rows = items.entries
          .map(
            (e) => {
              'order_id': orderId,
              'product_name': e.key.name,
              'price_som': e.key.priceSom,
              'quantity': e.value,
            },
          )
          .toList();
      if (rows.isNotEmpty) {
        await client.from('order_items').insert(rows);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<OrderModel>> fetchMyOrders() async {
    if (SupabaseService.isReady) {
      final client = SupabaseService.client;
      final uid = client.auth.currentUser?.id;
      if (uid != null) {
        try {
          final rows = await client
              .from('orders')
              .select()
              .eq('user_id', uid)
              .order('created_at', ascending: false);
          return rows.map(OrderModel.fromJson).toList();
        } catch (_) {
          // demoga tushamiz
        }
      }
    }
    return _demoOrders();
  }

  /// Real-time oqim — buyurtma holati o'zgarsa jonli yangilanadi.
  /// Sessiya yo'q yoki backendsiz — demo buyurtmalar oqimi.
  Stream<List<OrderModel>> watchMyOrders() {
    if (SupabaseService.isReady) {
      final client = SupabaseService.client;
      final uid = client.auth.currentUser?.id;
      if (uid != null) {
        return client
            .from('orders')
            .stream(primaryKey: ['id'])
            .eq('user_id', uid)
            .order('created_at')
            .map((rows) => rows.map(OrderModel.fromJson).toList());
      }
    }
    // Backendsiz — localhost'da real-time'ni ko'rsatish uchun 1025-buyurtma
    // holati jonli ilgarilaydi: Yangi → Tayyorlanmoqda → Yetkazilgan.
    return simulatedStream<OrderModel>(_demoOrders(), (current, tick) {
      const stages = ['new', 'processing', 'delivered'];
      final stage = stages[tick % stages.length];
      return [
        for (final o in current)
          if (o.id == 1025) o.copyWith(status: stage) else o,
      ];
    });
  }

  /// Buyurtma tarkibini (mahsulotlar) oladi.
  Future<List<OrderItem>> fetchItems(int orderId) async {
    if (SupabaseService.isReady) {
      final client = SupabaseService.client;
      if (client.auth.currentUser != null) {
        try {
          final rows = await client
              .from('order_items')
              .select()
              .eq('order_id', orderId);
          if (rows.isNotEmpty) return rows.map(OrderItem.fromJson).toList();
        } catch (_) {
          // demoga tushamiz
        }
      }
    }
    return _demoItems();
  }

  List<OrderItem> _demoItems() => const [
    OrderItem(
      productName: 'Royal Canin quruq yem (mushuk), 0.5 kg',
      priceSom: 123000,
      quantity: 1,
    ),
    OrderItem(
      productName: 'Katozal 10% (B12), 100 ml',
      priceSom: 130000,
      quantity: 1,
    ),
  ];

  /// Sessiyasiz/demo holat uchun namunaviy buyurtmalar.
  List<OrderModel> _demoOrders() {
    final now = DateTime.now();
    return [
      OrderModel(
        id: 1024,
        totalSom: 218000,
        status: 'delivered',
        createdAt: now.subtract(const Duration(days: 2)),
        itemCount: 3,
      ),
      OrderModel(
        id: 1025,
        totalSom: 95000,
        status: 'processing',
        createdAt: now.subtract(const Duration(hours: 5)),
        itemCount: 1,
      ),
    ];
  }
}
