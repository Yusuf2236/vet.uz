import 'dart:async';

/// Localhost (backend ulanmagan) rejimida real-time'ni KO'RSATISH uchun.
///
/// Boshlang'ich ro'yxatni darhol, so'ng har [period] da [mutate] orqali
/// yangilangan nusxani chiqaradi — UI jonli o'zgarayotgandek ko'rinadi.
/// Supabase ulangach bu ishlatilmaydi (haqiqiy `.stream()` ishlaydi).
Stream<List<T>> simulatedStream<T>(
  List<T> initial,
  List<T> Function(List<T> current, int tick) mutate, {
  Duration period = const Duration(seconds: 3),
}) async* {
  var current = initial;
  yield current;
  var tick = 0;
  await for (final _ in Stream<void>.periodic(period)) {
    tick++;
    current = mutate(current, tick);
    yield current;
  }
}
