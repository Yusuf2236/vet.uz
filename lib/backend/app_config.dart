import 'dart:io';

/// Backend (Supabase) sozlamalari.
///
/// Supabase loyihangizni yaratgach (https://supabase.com → New project),
/// Settings → API bo'limidan quyidagilarni shu yerga qo'ying:
///   - Project URL  -> [supabaseUrl]
///   - anon public  -> [supabaseAnonKey]   (bu OMMAVIY kalit — ilovaga xavfsiz)
///
/// Bo'sh qolsa — ilova lokal `MockData` bilan ishlayveradi (backendsiz).
/// `service_role` kalitini HECH QACHON bu yerga qo'ymang!
///
/// Tavsiya: maxfiy saqlash uchun `--dart-define` ishlating:
///   flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
class AppConfig {
  AppConfig._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://rjwbmrdcdiklpjxkpoll.supabase.co',
  );

  // "Publishable" (ommaviy) kalit — ilovaga qo'yish xavfsiz (RLS himoyalaydi).
  // Maxfiy `sb_secret_...` kalitni BU YERGA HECH QACHON qo'ymang.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_wUsGBMgbWXx5uKwyX83rTQ_jIpGeskS',
  );

  /// Backend ishlatilsinmi? STANDART — YOQIQ (Supabase'ga ulanadi).
  static const bool _backendFlag = bool.fromEnvironment(
    'USE_BACKEND',
    defaultValue: true,
  );

  static bool get isTest {
    try {
      return Platform.environment.containsKey('FLUTTER_TEST');
    } catch (_) {
      return false;
    }
  }

  static bool get useBackend =>
      !isTest && _backendFlag && supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Haqiqiy Supabase Auth (telefon+parol) ishlatilsinmi.
  /// Avval Supabase'da Phone (yoki Email) provayderini yoqing.
  static const bool _backendAuthFlag = bool.fromEnvironment(
    'USE_BACKEND_AUTH',
    defaultValue: true,
  );

  static bool get useBackendAuth => useBackend && _backendAuthFlag;
}
