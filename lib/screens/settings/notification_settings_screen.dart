import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/services/preferences_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Bildirishnoma sozlamalari — push va reklama bildirishnomalari (saqlanadi).
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final _prefs = PreferencesService.instance;
  late bool _push = _prefs.pushEnabled;
  late bool _promo = _prefs.promoEnabled;

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.notificationsTitle,
          style: AppTextStyles.h3,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        children: [
          _Tile(
            title: 'Push bildirishnomalar',
            subtitle: 'Buyurtma, emlash va shoshilinch eslatmalar',
            value: _push,
            onChanged: (v) {
              setState(() => _push = v);
              _prefs.setPushEnabled(v);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _Tile(
            title: 'Reklama va takliflar',
            subtitle: 'Maxsus aksiya va chegirmalar haqida',
            value: _promo,
            onChanged: (v) {
              setState(() => _promo = v);
              _prefs.setPromoEnabled(v);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Push bildirishnomalar haqiqiy yetkazib berish uchun server (FCM) '
            'ulanishini talab qiladi. Hozir tanlovingiz saqlanadi.',
            style: AppTextStyles.caption.copyWith(color: secondary),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _Tile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: AppTextStyles.title),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(color: secondary),
        ),
      ),
    );
  }
}
