/// Buyurtma tarkibidagi bitta mahsulot (Supabase `order_items`).
class OrderItem {
  final String productName;
  final int priceSom;
  final int quantity;

  const OrderItem({
    required this.productName,
    required this.priceSom,
    required this.quantity,
  });

  int get lineTotal => priceSom * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    productName: json['product_name'] as String? ?? '',
    priceSom: (json['price_som'] as num?)?.toInt() ?? 0,
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  );
}
