import 'package:flutter/material.dart';

import '../../../core/theme/theme_controller.dart';
import '../../../widgets/brand_wordmark.dart';
import '../../../widgets/circle_icon_button.dart';

/// Asosiy ekran sarlavhasi: brend + tema almashtirish + bildirishnoma.
class HomeAppHeader extends StatelessWidget {
  final String? notificationBadge;
  final VoidCallback? onNotifications;

  const HomeAppHeader({
    super.key,
    this.notificationBadge,
    this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const BrandWordmark(),
        Row(
          children: [
            CircleIconButton(
              icon: theme.isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              onTap: theme.toggle,
            ),
            const SizedBox(width: 10),
            CircleIconButton(
              icon: Icons.notifications_none_rounded,
              badge: notificationBadge,
              onTap: onNotifications,
            ),
          ],
        ),
      ],
    );
  }
}
