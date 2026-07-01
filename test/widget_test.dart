import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vetuz/app.dart';
import 'package:vetuz/frontend/core/constants/app_info.dart';
import 'package:vetuz/frontend/core/services/preferences_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Test uchun lokal saqlashni mock qilamiz (chiqmagan foydalanuvchi).
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  testWidgets('Splash ekran brend bilan ochiladi', (WidgetTester tester) async {
    await tester.pumpWidget(const VetUzApp(initialRoute: '/'));

    expect(find.text(AppInfo.name), findsWidgets);
    expect(find.text('Ilovani boshlash'), findsOneWidget);
  });

  testWidgets('Boshlash bosilganda onboardingga o\'tadi',
      (WidgetTester tester) async {
    await tester.pumpWidget(const VetUzApp(initialRoute: '/'));

    await tester.tap(find.text('Ilovani boshlash'));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    expect(find.text('Veterinariya xizmatlari'), findsOneWidget);
  });
}
