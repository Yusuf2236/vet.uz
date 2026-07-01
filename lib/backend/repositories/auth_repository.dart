import '../app_config.dart';
import '../../frontend/core/services/preferences_service.dart';
import '../supabase_service.dart';

/// Autentifikatsiya qatlami.
///
/// `useBackendAuth` yoqilgan bo'lsa Supabase Auth (telefon + parol) ishlatiladi,
/// aks holda lokal demo (sessiya `PreferencesService`da saqlanadi).
/// Shu tufayli ilova SMS provayderisiz ham to'liq ishlaydi.
class AuthRepository {
  bool get isLoggedIn {
    if (AppConfig.useBackendAuth && SupabaseService.isReady) {
      return SupabaseService.client.auth.currentSession != null;
    }
    return PreferencesService.instance.isLoggedIn;
  }

  /// Telefon (+998XXXXXXXXX) va parol bilan kirish.
  Future<void> signIn(String phoneE164, String password) async {
    if (AppConfig.useBackendAuth && SupabaseService.isReady) {
      await SupabaseService.client.auth.signInWithPassword(
        phone: phoneE164,
        password: password,
      );
    } else {
      await PreferencesService.instance.setLoggedIn(true);
    }
  }

  /// Ro'yxatdan o'tish.
  Future<void> signUp(String phoneE164, String password) async {
    if (AppConfig.useBackendAuth && SupabaseService.isReady) {
      await SupabaseService.client.auth.signUp(
        phone: phoneE164,
        password: password,
      );
    } else {
      await PreferencesService.instance.setLoggedIn(true);
    }
  }

  Future<void> signOut() async {
    if (AppConfig.useBackendAuth && SupabaseService.isReady) {
      await SupabaseService.client.auth.signOut();
    }
    await PreferencesService.instance.setLoggedIn(false);
  }
}
