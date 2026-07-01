import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_config.dart';

/// Supabase ulanishini boshqaradi. `main()` da [init] chaqiriladi.
/// Backend sozlanmagan bo'lsa (kalitlar bo'sh) yoki ulanish muvaffaqiyatsiz
/// bo'lsa — ilova `MockData` bilan ishlayveradi (oq ekran bo'lmaydi).
class SupabaseService {
  SupabaseService._();

  static bool _ready = false;

  /// Backend haqiqatan tayyor (sozlangan VA ulanish muvaffaqiyatli) bo'lsa true.
  /// Repozitoriylar shu bayroqqa qarab Supabase yoki MockData tanlaydi.
  static bool get isReady => _ready;

  /// Sozlangan bo'lsagina Supabase'ni ishga tushiradi. Hech qachon xato
  /// otmaydi — xato/timeout bo'lsa MockData rejimida davom etadi.
  static Future<void> init() async {
    if (!AppConfig.useBackend) return;
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        // Yangi "publishable" ommaviy kalit (anonKey o'rniga).
        publishableKey: AppConfig.supabaseAnonKey,
      ).timeout(const Duration(seconds: 6));
      _ready = true;
    } catch (e) {
      _ready = false;
      debugPrint('Supabase init muvaffaqiyatsiz — MockData rejimi: $e');
    }
  }

  /// Qulay kirish nuqtasi (faqat init muvaffaqiyatli bo'lsa).
  static SupabaseClient get client => Supabase.instance.client;
}
