import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vetuz/frontend/core/constants/app_strings.dart';
import 'package:vetuz/frontend/screens/auth/login_screen.dart';

void main() {
  testWidgets("Bo'sh forma — validatsiya xatolari chiqadi, navigatsiya yo'q",
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.tap(find.text(AppStrings.login));
    await tester.pump();

    expect(find.text(AppStrings.phoneRequired), findsOneWidget);
    expect(find.text(AppStrings.passwordRequired), findsOneWidget);
  });

  testWidgets('Valid kiritma — loading indikatori, so\'ng xato banneri',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '901234567');
    await tester.enterText(fields.at(1), '000000'); // demo: xato paroli
    await tester.pump();

    await tester.tap(find.text(AppStrings.login));
    await tester.pump(); // async boshlandi -> loading

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900)); // mock auth tugadi

    expect(find.text(AppStrings.loginError), findsOneWidget);
  });
}
