/// Rasm manbalari (URL yasovchi yordamchilar).
/// Internet bo'lsa real rasm ko'rsatiladi; bo'lmasa `RemoteImage` fallback'ga
/// (ikonka/initial) tushadi — ilova baribir ishlaydi.
class AppImages {
  AppImages._();

  /// Kalit so'z bo'yicha tematik rasm (barqaror — `lock` seed bilan).
  static String keyword(String kw, int seed) =>
      'https://loremflickr.com/600/400/$kw?lock=$seed';

  /// Ism asosida barqaror avatar foto.
  static String avatar(String seed) =>
      'https://i.pravatar.cc/200?u=${Uri.encodeComponent(seed)}';
}
