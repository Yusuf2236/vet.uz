/// Matn yordamchilari.
class TextUtils {
  TextUtils._();

  /// To'liq ismdan bosh harflar: "Akbar Normatov" -> "AN", "Dr. Jahongir" -> "J".
  /// Bo'sh/yaroqsiz qiymatda "?" qaytaradi (crashdan himoya).
  static String initials(String? fullName) {
    final clean = (fullName ?? '').replaceAll('Dr.', '').trim();
    final parts = clean.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}
