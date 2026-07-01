import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'core/constants/app_info.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/state/cart_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

/// Ilova ildizi — tema (light/dark) va marshrutlashni sozlaydi.
class VetUzApp extends StatefulWidget {
  final String? initialRoute;
  const VetUzApp({super.key, this.initialRoute});

  @override
  State<VetUzApp> createState() => _VetUzAppState();
}

class _VetUzAppState extends State<VetUzApp> {
  final ThemeController _theme = ThemeController();
  final CartController _cart = CartController();

  @override
  void dispose() {
    _theme.dispose();
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _theme,
      child: CartScope(
        controller: _cart,
        child: ListenableBuilder(
          listenable: _theme,
          builder: (context, _) {
            return MaterialApp(
              title: AppInfo.name,
              debugShowCheckedModeBanner: false,
              // DevicePreview integratsiyasi (qurilma ramkasi/locale).
              locale: DevicePreview.locale(context),
              // Matn kattalashtirilganda overflow bo'lmasligi uchun clamp +
              // DevicePreview ramkasi.
              builder: (context, child) => DevicePreview.appBuilder(
                context,
                MediaQuery.withClampedTextScaling(
                  maxScaleFactor: 1.3,
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: _theme.mode,
              initialRoute: widget.initialRoute ?? AppRoutes.splash,
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}
