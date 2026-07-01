import '../../frontend/core/services/preferences_service.dart';
import '../../frontend/data/mock_data.dart';
import '../../frontend/models/user_profile.dart';
import '../supabase_service.dart';

/// Joriy foydalanuvchi profili.
/// Backend + sessiya bo'lsa Supabase `profiles`; aks holda MockData ustiga
/// lokal tahrirlar (PreferencesService) qo'llanadi.
class ProfileRepository {
  Future<UserProfile> fetchCurrentProfile() async {
    if (SupabaseService.isReady) {
      try {
        final uid = SupabaseService.client.auth.currentUser?.id;
        if (uid != null) {
          final row = await SupabaseService.client
              .from('profiles')
              .select()
              .eq('id', uid)
              .maybeSingle();
          if (row != null) return UserProfile.fromJson(row);
        }
      } catch (_) {
        // lokalga tushamiz
      }
    }
    return _localProfile();
  }

  /// MockData + lokal tahrirlar (demo rejim).
  UserProfile _localProfile() {
    final p = PreferencesService.instance;
    return MockData.user.copyWith(
      fullName: p.profileName,
      role: p.profileRole,
      city: p.profileCity,
      avatarUrl: p.profileAvatar,
      isPro: p.isPro,
    );
  }

  /// Profilni saqlaydi (backend → upsert, demo → lokal).
  Future<void> updateProfile(UserProfile profile) async {
    if (SupabaseService.isReady) {
      final uid = SupabaseService.client.auth.currentUser?.id;
      if (uid != null) {
        try {
          await SupabaseService.client.from('profiles').upsert({
            'id': uid,
            ...profile.toJson(),
            'is_pro': profile.isPro,
          });
          return;
        } catch (_) {
          // lokalga tushamiz
        }
      }
    }
    await PreferencesService.instance.setProfile(
      name: profile.fullName,
      role: profile.role,
      city: profile.city,
      avatar: profile.avatarUrl,
    );
    await PreferencesService.instance.setIsPro(profile.isPro);
  }
}
