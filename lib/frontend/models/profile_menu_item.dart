import 'package:flutter/material.dart';

/// Profil ekranidagi menyu qatori.
class ProfileMenuItem {
  final String label;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final Color tint;
  final String? badgeText;

  const ProfileMenuItem({
    required this.label,
    this.subtitle,
    required this.icon,
    required this.color,
    required this.tint,
    this.badgeText,
  });
}
