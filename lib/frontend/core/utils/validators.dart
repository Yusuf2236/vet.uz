import '../constants/app_strings.dart';
import 'phone_input_formatter.dart';

/// Forma maydonlari uchun qayta ishlatiladigan validatorlar.
/// `TextFormField.validator` imzosiga mos — `String?` qaytaradi.
class Validators {
  Validators._();

  /// O'zbek telefon raqami: 9 ta raqam to'liq kiritilgan bo'lishi kerak.
  static String? phone(String? value) {
    final v = value ?? '';
    if (UzPhoneInputFormatter.digitsOf(v).isEmpty) {
      return AppStrings.phoneRequired;
    }
    if (!UzPhoneInputFormatter.isComplete(v)) {
      return AppStrings.phoneIncomplete;
    }
    return null;
  }

  /// Parol: bo'sh emas va kamida 6 belgi.
  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return AppStrings.passwordRequired;
    if (v.length < 6) return AppStrings.passwordTooShort;
    return null;
  }
}
