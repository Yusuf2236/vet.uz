import 'package:flutter/material.dart';

/// Asosiy ekrandagi kategoriya (Veterinar, Klinika, ...).
class CategoryItem {
  final String label;
  final IconData icon;
  final Color color;
  final Color tint;

  const CategoryItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.tint,
  });
}
