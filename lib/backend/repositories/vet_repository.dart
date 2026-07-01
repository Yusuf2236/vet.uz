import '../supabase_service.dart';
import '../../models/veterinarian.dart';
import '../../data/mock_data.dart';
import 'mock_realtime.dart';

/// Veterinarlar manbai. Backend sozlangan bo'lsa Supabase'dan, aks holda
/// (yoki xato/internetsizlikda) `MockData`dan o'qiydi.
class VetRepository {
  Future<List<Veterinarian>> fetchVets() async {
    if (!SupabaseService.isReady) return MockData.vets;
    try {
      final rows = await SupabaseService.client
          .from('vets')
          .select()
          .order('rating', ascending: false);
      if (rows.isEmpty) return MockData.vets;
      return rows.map(Veterinarian.fromJson).toList();
    } catch (_) {
      return MockData.vets;
    }
  }

  /// Real-time oqim (Supabase Realtime). Backendsiz — localhost'da real-time'ni
  /// ko'rsatish uchun har 3 soniyada bir veterinarning band/bo'sh holati
  /// jonli o'zgaradi (simulyatsiya).
  Stream<List<Veterinarian>> watchVets() {
    if (!SupabaseService.isReady) {
      return simulatedStream<Veterinarian>(MockData.vets, (current, tick) {
        final i = tick % current.length;
        return [
          for (var k = 0; k < current.length; k++)
            if (k == i)
              current[k].copyWith(isAvailable: !current[k].isAvailable)
            else
              current[k],
        ];
      });
    }
    return SupabaseService.client
        .from('vets')
        .stream(primaryKey: ['id'])
        .map(
          (rows) => rows.isEmpty
              ? MockData.vets
              : rows.map(Veterinarian.fromJson).toList(),
        );
  }
}
