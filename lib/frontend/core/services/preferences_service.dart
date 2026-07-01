import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lokal saqlash (tema, sessiya) uchun yagona xizmat.
/// `main()` da [init] chaqiriladi, so'ng [instance] orqali ishlatiladi.
class PreferencesService {
  PreferencesService._(this._prefs);

  final SharedPreferences _prefs;
  static late PreferencesService instance;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    instance = PreferencesService._(prefs);
  }

  static const String _kThemeMode = 'theme_mode';
  static const String _kLoggedIn = 'is_logged_in';
  static const String _kLanguage = 'language';
  static const String _kPushEnabled = 'push_enabled';
  static const String _kPromoEnabled = 'promo_enabled';
  static const String _kProfileName = 'profile_name';
  static const String _kProfileRole = 'profile_role';
  static const String _kProfileCity = 'profile_city';
  static const String _kProfileAvatar = 'profile_avatar';
  static const String _kIsPro = 'is_pro';

  // ---- Tema ----
  ThemeMode get themeMode {
    switch (_prefs.getString(_kThemeMode)) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(_kThemeMode, mode == ThemeMode.dark ? 'dark' : 'light');

  // ---- Sessiya ----
  bool get isLoggedIn => _prefs.getBool(_kLoggedIn) ?? false;

  Future<void> setLoggedIn(bool value) => _prefs.setBool(_kLoggedIn, value);

  // ---- Til (kod: uz / ru / kaa) ----
  String get language => _prefs.getString(_kLanguage) ?? 'uz';

  Future<void> setLanguage(String code) => _prefs.setString(_kLanguage, code);

  // ---- Bildirishnoma sozlamalari ----
  bool get pushEnabled => _prefs.getBool(_kPushEnabled) ?? true;
  Future<void> setPushEnabled(bool v) => _prefs.setBool(_kPushEnabled, v);

  bool get promoEnabled => _prefs.getBool(_kPromoEnabled) ?? true;
  Future<void> setPromoEnabled(bool v) => _prefs.setBool(_kPromoEnabled, v);

  // ---- Onboarding ----
  bool get isOnboarded => _prefs.getBool('is_onboarded') ?? false;
  Future<void> setOnboarded(bool v) => _prefs.setBool('is_onboarded', v);

  // ---- Obuna ----
  bool get isPro => _prefs.getBool(_kIsPro) ?? false;
  Future<void> setIsPro(bool v) => _prefs.setBool(_kIsPro, v);

  // ---- Profil (lokal demo uchun) ----
  String? get profileName => _prefs.getString(_kProfileName);
  String? get profileRole => _prefs.getString(_kProfileRole);
  String? get profileCity => _prefs.getString(_kProfileCity);
  String? get profileAvatar => _prefs.getString(_kProfileAvatar);

  Future<void> setProfileAvatar(String? path) async {
    if (path == null) {
      await _prefs.remove(_kProfileAvatar);
    } else {
      await _prefs.setString(_kProfileAvatar, path);
    }
  }

  Future<void> setProfile({
    required String name,
    required String role,
    required String city,
    String? avatar,
  }) async {
    await _prefs.setString(_kProfileName, name);
    await _prefs.setString(_kProfileRole, role);
    await _prefs.setString(_kProfileCity, city);
    if (avatar != null) {
      await _prefs.setString(_kProfileAvatar, avatar);
    }
  }
}
