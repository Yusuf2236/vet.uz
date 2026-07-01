/// Buyurtma modeli (Supabase `orders` jadvali).
class OrderModel {
  final int id;
  final int totalSom;
  final String status;
  final DateTime createdAt;
  final int itemCount;

  const OrderModel({
    required this.id,
    required this.totalSom,
    required this.status,
    required this.createdAt,
    this.itemCount = 0,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final created = json['created_at'];
    return OrderModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      totalSom: (json['total_som'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'new',
      createdAt: created is String
          ? (DateTime.tryParse(created) ??
                DateTime.fromMillisecondsSinceEpoch(0))
          : DateTime.fromMillisecondsSinceEpoch(0),
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
    );
  }

  OrderModel copyWith({String? status}) => OrderModel(
    id: id,
    totalSom: totalSom,
    status: status ?? this.status,
    createdAt: createdAt,
    itemCount: itemCount,
  );

  /// Holatning o'zbekcha ko'rinishi.
  String get statusLabel {
    switch (status) {
      case 'new':
        return 'Yangi';
      case 'processing':
        return 'Tayyorlanmoqda';
      case 'delivered':
        return 'Yetkazilgan';
      case 'cancelled':
        return 'Bekor qilingan';
      default:
        return status;
    }
  }
}
