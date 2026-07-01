import 'package:flutter/material.dart';

import '../services/preferences_service.dart';

/// Yorug'/qorong'i rejimni boshqaruvchi controller.
/// Tanlov `SharedPreferences` ga saqlanadi — qayta ochilganda tiklanadi.
class ThemeController extends ChangeNotifier {
  ThemeController() : _mode = PreferencesService.instance.themeMode;

  ThemeMode _mode;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() => setDark(!isDark);

  void setDark(bool value) {
    final next = value ? ThemeMode.dark : ThemeMode.light;
    if (next == _mode) return;
    _mode = next;
    PreferencesService.instance.setThemeMode(next);
    notifyListeners();
  }
}

/// Ilova daraxti bo'ylab `ThemeController`ga kirish uchun.
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope topilmadi');
    return scope!.notifier!;
  }
}
