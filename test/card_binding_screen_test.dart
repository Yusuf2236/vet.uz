import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetuz/frontend/core/services/preferences_service.dart';
import 'package:vetuz/frontend/screens/profile/card_binding_screen.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  testWidgets('Card number validation - empty form shows errors', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CardBindingScreen()));

    await tester.tap(find.text('Karta ulash'));
    await tester.pump();

    expect(find.text("Raqamni to'liq kiriting"), findsOneWidget);
    expect(find.text("Xato muddat"), findsOneWidget);
    expect(find.text("Ismni kiriting"), findsOneWidget);
  });

  testWidgets('Card number validation - correct card number does not show error', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CardBindingScreen()));

    final fields = find.byType(TextFormField);
    // Enter card number
    await tester.enterText(fields.at(0), '8600 1234 5678 9012');
    // Enter expiry date
    await tester.enterText(fields.at(1), '12/28');
    // Enter holder name
    await tester.enterText(fields.at(2), 'JOHN DOE');
    await tester.pump();

    await tester.tap(find.text('Karta ulash'));
    await tester.pump();

    expect(find.text("Raqamni to'liq kiriting"), findsNothing);
    expect(find.text("Xato muddat"), findsNothing);
    expect(find.text("Ismni kiriting"), findsNothing);

    // Pump timer and bottom sheet transition without pumpAndSettle (due to CircularProgressIndicator infinite animation)
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify SMS Otp screen is displayed
    expect(find.text('SMS tasdiqlash'), findsOneWidget);

    // Enter correct OTP
    await tester.enterText(find.byType(TextFormField).last, '1111');
    await tester.pump();

    // Tap confirm button
    await tester.tap(find.text('Tasdiqlash'));
    await tester.pumpAndSettle();

    // Verify Premium was activated and card screen closed (returns to screen)
    expect(find.text('Karta bog\'lash'), findsNothing);
  });
}
