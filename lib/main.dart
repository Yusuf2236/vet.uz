import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'frontend/core/services/preferences_service.dart';
import 'backend/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Build paytidagi xatoda oq ekran o'rniga o'qiladigan xabar ko'rsatiladi.
  ErrorWidget.builder = (details) => Material(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          'Xatolik yuz berdi:\n\n${details.exceptionAsString()}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFFB00020), fontSize: 13),
        ),
      ),
    ),
  );
  // Lokal saqlash (tema, sessiya) — runApp dan oldin yuklanadi.
  // (Xatoni yutmaymiz: muvaffaqiyatsiz bo'lsa `instance` tayinlanmay qoladi va
  // keyin LateInitializationError beradi — shuning uchun to'g'ridan-to'g'ri.)
  await PreferencesService.init();
  // Backend — init o'zi xatoga chidamli (xato bo'lsa MockData rejimi).
  await SupabaseService.init();
  runApp(
    // DevicePreview — ilovani iOS/Android qurilma ramkasi ichida ko'rsatadi
    // va model/orientatsiyani jonli almashtirish imkonini beradi.
    // Release build'da o'chiq (kReleaseMode) — faqat ishlab chiqishda.
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const VetUzApp(),
    ),
  );
}
