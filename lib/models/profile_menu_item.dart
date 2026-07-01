import 'package:flutter/material.dart';

/// Profil ekranidagi menyu qatori.
class ProfileMenuItem {
  final String label;
  final IconData icon;
  final Color color;
  final Color tint;

  const ProfileMenuItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.tint,
  });
}
