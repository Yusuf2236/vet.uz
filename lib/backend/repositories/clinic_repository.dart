import '../supabase_service.dart';
import '../../models/clinic.dart';
import '../../data/mock_data.dart';

/// Klinikalar manbai (Supabase yoki MockData).
class ClinicRepository {
  Future<List<Clinic>> fetchClinics() async {
    if (!SupabaseService.isReady) return MockData.clinics;
    try {
      final rows = await SupabaseService.client.from('clinics').select();
      if (rows.isEmpty) return MockData.clinics;
      return rows.map(Clinic.fromJson).toList();
    } catch (_) {
      return MockData.clinics;
    }
  }

  /// Faqat 24/7 ishlaydigan klinikalar.
  Future<List<Clinic>> fetch247() async {
    final all = await fetchClinics();
    return all.where((c) => c.open247).toList();
  }
}
