import 'package:flutter/material.dart';

/// Onboarding (tanishtiruv) sahifasi modeli.
class OnboardingItem {
  final String title;
  final String body;
  final IconData icon;
  final IconData badgeIcon;
  final List<Color> gradient;
  final String imageUrl;

  const OnboardingItem({
    required this.title,
    required this.body,
    required this.icon,
    required this.badgeIcon,
    required this.gradient,
    required this.imageUrl,
  });
}
