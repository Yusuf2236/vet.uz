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

    final baseOffset = newValue.selection.baseOffset;
    final textBeforeCursor = baseOffset >= 0 && baseOffset <= newValue.text.length
        ? newValue.text.substring(0, baseOffset)
        : '';
    final digitsBeforeCursor = textBeforeCursor.replaceAll(RegExp(r'\D'), '').length;

    int cursorOffset = 0;
    int digitsWritten = 0;

    final buffer = StringBuffer();
    for (int i = 0; i < capped.length; i++) {
      if (_spaceAfter.contains(i)) {
        buffer.write(' ');
      }
      buffer.write(capped[i]);
      digitsWritten++;
      if (digitsWritten == digitsBeforeCursor) {
        cursorOffset = buffer.length;
      }
    }

    if (digitsBeforeCursor > digitsWritten) {
      cursorOffset = buffer.length;
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  /// Faqat raqamlarni ajratib oladi.
  static String digitsOf(String value) => value.replaceAll(RegExp(r'\D'), '');

  /// Raqam to'liq kiritilganmi (9 ta raqam).
  static bool isComplete(String value) => digitsOf(value).length == maxDigits;
}
