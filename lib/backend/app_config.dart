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

  /// Backend ishlatilsinmi? STANDART — O'CHIQ (localhost'da `MockData` +
  /// real-time simulyatsiya bilan ishlaydi, internet/Supabase shart emas).
  /// Supabase'ga ulanmoqchi bo'lsangiz:
  ///   flutter run --dart-define=USE_BACKEND=true
  static const bool _backendFlag = bool.fromEnvironment(
    'USE_BACKEND',
    defaultValue: false,
  );

  static bool get useBackend =>
      _backendFlag && supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Haqiqiy Supabase Auth (telefon+parol) ishlatilsinmi.
  /// Avval Supabase'da Phone (yoki Email) provayderini yoqing, so'ng:
  ///   flutter run --dart-define=USE_BACKEND_AUTH=true
  /// Aks holda login lokal demo rejimida ishlaydi (sessiya saqlanadi).
  static const bool _backendAuthFlag = bool.fromEnvironment(
    'USE_BACKEND_AUTH',
    defaultValue: false,
  );

  static bool get useBackendAuth => useBackend && _backendAuthFlag;
}
