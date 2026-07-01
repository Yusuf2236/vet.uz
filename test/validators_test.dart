import 'package:flutter_test/flutter_test.dart';
import 'package:vetuz/frontend/core/constants/app_strings.dart';
import 'package:vetuz/frontend/core/utils/validators.dart';

void main() {
  group('Validators.phone', () {
    test("bo'sh raqam -> phoneRequired", () {
      expect(Validators.phone(''), AppStrings.phoneRequired);
      expect(Validators.phone(null), AppStrings.phoneRequired);
    });
    test("to'liqsiz raqam -> phoneIncomplete", () {
      expect(Validators.phone('90 123'), AppStrings.phoneIncomplete);
    });
    test("to'liq raqam -> null (xato yo'q)", () {
      expect(Validators.phone('90 123 45 67'), isNull);
      expect(Validators.phone('901234567'), isNull);
    });
  });

  group('Validators.password', () {
    test("bo'sh parol -> passwordRequired", () {
      expect(Validators.password(''), AppStrings.passwordRequired);
    });
    test('qisqa parol -> passwordTooShort', () {
      expect(Validators.password('123'), AppStrings.passwordTooShort);
    });
    test("yetarli parol -> null (xato yo'q)", () {
      expect(Validators.password('123456'), isNull);
    });
  });
}
