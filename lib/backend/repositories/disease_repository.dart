import '../supabase_service.dart';
import '../../frontend/models/disease.dart';
import '../../frontend/data/mock_data.dart';

/// VetAI uchun kasalliklar manbai (Supabase yoki MockData).
class DiseaseRepository {
  Future<List<Disease>> fetchDiseases() async {
    if (!SupabaseService.isReady) return MockData.diseases;
    try {
      final rows = await SupabaseService.client.from('diseases').select();
      if (rows.isEmpty) return MockData.diseases;
      return rows.map(Disease.fromJson).toList();
    } catch (_) {
      return MockData.diseases;
    }
  }
}
