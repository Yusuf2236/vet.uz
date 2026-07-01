import 'package:flutter/material.dart';

import '../../core/constants/app_info.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/preferences_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_controller.dart';
import 'notification_settings_screen.dart';
import 'privacy_screen.dart';

/// Sozlamalar — tema, til (saqlanadi), bildirishnoma, maxfiylik, ilova haqida.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Map<String, String> _languages = {
    'uz': "O'zbekcha",
    'ru': 'Русский',
    'kaa': 'Qaraqalpaqsha',
  };

  String _lang = PreferencesService.instance.language;

  Future<void> _pickLanguage() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text('Tilni tanlang', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.sm),
            for (final e in _languages.entries)
              ListTile(
                title: Text(e.value, style: AppTextStyles.title),
                trailing: e.key == _lang
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(ctx, e.key),
              ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
    if (picked != null && picked != _lang) {
      await PreferencesService.instance.setLanguage(picked);
      if (mounted) setState(() => _lang = picked);
    }
  }

  void _push(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final pushOn = PreferencesService.instance.pushEnabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings, style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        children: [
          _Card(
            child: SwitchListTile.adaptive(
              value: theme.isDark,
              onChanged: theme.setDark,
              activeTrackColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
              secondary: Icon(
                theme.isDark ? Icons.dark_mode : Icons.light_mode_outlined,
                color: AppColors.primary,
              ),
              title: const Text("Qorong'i rejim", style: AppTextStyles.title),
              subtitle: Text(
                theme.isDark ? 'Yoqilgan' : "O'chirilgan",
                style: AppTextStyles.caption.copyWith(color: secondary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _Card(
            child: Column(
              children: [
                _Tile(
                  icon: Icons.language_outlined,
                  title: 'Til',
                  trailing: _languages[_lang],
                  onTap: _pickLanguage,
                ),
                _Divider(),
                _Tile(
                  icon: Icons.notifications_none_rounded,
                  title: AppStrings.notificationsTitle,
                  trailing: pushOn ? 'Yoqilgan' : "O'chirilgan",
                  onTap: () => _push(const NotificationSettingsScreen()),
                ),
                _Divider(),
                _Tile(
                  icon: Icons.lock_outline,
                  title: 'Maxfiylik',
                  onTap: () => _push(const PrivacyScreen()),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _Card(
            child: _Tile(
              icon: Icons.info_outline,
              title: 'Ilova haqida',
              trailing: AppInfo.version,
              onTap: () => showAboutDialog(
                context: context,
                applicationName: AppInfo.name,
                applicationVersion: AppInfo.version,
                applicationLegalese: '© ${AppInfo.year} ${AppInfo.name}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
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
      child: child,
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(title, style: AppTextStyles.title)),
            if (trailing != null)
              Text(
                trailing!,
                style: AppTextStyles.caption.copyWith(color: secondary),
              ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: Theme.of(context).dividerColor);
}
