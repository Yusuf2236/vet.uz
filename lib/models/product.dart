import 'package:flutter/material.dart';

/// Marketplace mahsuloti.
class Product {
  final String name;
  final String category;
  final int priceSom;
  final int? oldPriceSom;
  final double rating;
  final IconData icon;
  final Color color;
  final Color tint;

  const Product({
    required this.name,
    required this.category,
    required this.priceSom,
    required this.rating,
    required this.icon,
    required this.color,
    required this.tint,
    this.oldPriceSom,
  });

  bool get hasDiscount => oldPriceSom != null && oldPriceSom! > priceSom;

  Product copyWith({
    int? priceSom,
    int? oldPriceSom,
    bool clearOldPrice = false,
  }) => Product(
    name: name,
    category: category,
    priceSom: priceSom ?? this.priceSom,
    oldPriceSom: clearOldPrice ? null : (oldPriceSom ?? this.oldPriceSom),
    rating: rating,
    icon: icon,
    color: color,
    tint: tint,
  );

  // Savat (Map<Product,int>) kaliti barqaror bo'lishi uchun qiymat-tengligi:
  // copyWith bilan yangilangan nusxa (chegirma/narx o'zgarsa) ham SHU mahsulot
  // deb tan olinadi — aks holda real-time stream savatda dublikat yaratardi.
  @override
  bool operator ==(Object other) =>
      other is Product && other.name == name && other.category == category;

  @override
  int get hashCode => Object.hash(name, category);
}
