import 'package:flutter/material.dart';

/// Foydalanuvchi hayvoni (Mening hayvonlarim ekrani uchun).
class Animal {
  final String name;
  final String type; // Qoramol, It, Mushuk, Parranda...
  final String breed;
  final String age;
  final String health; // holat matni
  final bool healthy;
  final IconData icon;

  const Animal({
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.health,
    required this.icon,
    this.healthy = true,
  });
}
