import 'package:flutter/material.dart';

import '../../models/product.dart';

/// Savat holati — tashqi paketsiz `ChangeNotifier`.
/// Mahsulot va miqdorni saqlaydi, jami summa/sonni hisoblaydi.
class CartController extends ChangeNotifier {
  final Map<Product, int> _items = {};

  Map<Product, int> get items => Map.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  int get count => _items.values.fold(0, (sum, q) => sum + q);

  int get total =>
      _items.entries.fold(0, (sum, e) => sum + e.key.priceSom * e.value);

  void add(Product product) {
    _items.update(product, (q) => q + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void decrement(Product product) {
    final q = _items[product];
    if (q == null) return;
    if (q <= 1) {
      _items.remove(product);
    } else {
      _items[product] = q - 1;
    }
    notifyListeners();
  }

  void removeAll(Product product) {
    if (_items.remove(product) != null) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}

/// Daraxt bo'ylab `CartController`ga kirish.
class CartScope extends InheritedNotifier<CartController> {
  const CartScope({
    super.key,
    required CartController controller,
    required super.child,
  }) : super(notifier: controller);

  static CartController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope topilmadi');
    return scope!.notifier!;
  }
}
