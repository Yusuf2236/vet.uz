import 'package:flutter/services.dart';

/// O'zbek telefon raqamini yozilayotganda avtomatik formatlaydi:
/// raqamlar kiritilgan sari "90 123 45 67" ko'rinishida bo'sh joylar
/// o'zi qo'shiladi (+998 prefiks alohida ko'rsatiladi).
class UzPhoneInputFormatter extends TextInputFormatter {
  /// +998 dan keyingi raqamlar soni (9 ta).
  static const int maxDigits = 9;

  /// Bo'sh joy qo'yiladigan pozitsiyalar: 90·123·45·67 → [2, 5, 7].
  static const List<int> _spaceAfter = [2, 5, 7];

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = digitsOf(newValue.text);
    final capped = digits.length > maxDigits
        ? digits.substring(0, maxDigits)
        : digits;

    final buffer = StringBuffer();
    for (int i = 0; i < capped.length; i++) {
      if (_spaceAfter.contains(i)) buffer.write(' ');
      buffer.write(capped[i]);
    }
    final text = buffer.toString();

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// Faqat raqamlarni ajratib oladi.
  static String digitsOf(String value) => value.replaceAll(RegExp(r'\D'), '');

  /// Raqam to'liq kiritilganmi (9 ta raqam).
  static bool isComplete(String value) => digitsOf(value).length == maxDigits;
}
