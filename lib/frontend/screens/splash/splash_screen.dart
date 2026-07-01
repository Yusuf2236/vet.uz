import 'package:flutter/material.dart';

import '../../core/constants/app_info.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/radar_rings.dart';

/// Kirish (welcome) ekrani — animatsion radar foni, brend va "Boshlash".
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  // Logo: pastdan biroz kattalashib paydo bo'ladi.
  late final Animation<double> _logoScale = Tween<double>(begin: 0.82, end: 1.0)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
        ),
      );
  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
  );

  // Matn: bir oz kechikib paydo bo'ladi.
  late final Animation<double> _textFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.3, 0.78, curve: Curves.easeOut),
  );

  // Pastki qism (tugma + footer): oxirida pastdan ko'tariladi.
  late final Animation<double> _bottomFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
  );
  late final Animation<Offset> _bottomSlide =
      Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
        ),
      );

  // Boshlash tugmasi uchun cheksiz yozuv shimmery animatsiyasi
  late final AnimationController _pulseController;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _start() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          const Positioned.fill(child: RadarRings()),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: const AppLogo(size: 96),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FadeTransition(
                      opacity: _textFade,
                      child: Column(
                        children: [
                          Text(
                            AppInfo.name,
                            style: AppTextStyles.display.copyWith(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            AppInfo.tagline,
                            style: AppTextStyles.overline.copyWith(
                              color: Colors.white,
                              fontSize: 12.5,
                              letterSpacing: 2.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            AppStrings.appSubtitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 4),
                    SlideTransition(
                      position: _bottomSlide,
                      child: FadeTransition(
                        opacity: _bottomFade,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isTapped ? 0.92 : 1.0,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                height: 62,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(AppRadius.lg),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: _isTapped ? 0.1 : 0.2,
                                      ),
                                      blurRadius: _isTapped ? 4 : 8,
                                      offset: _isTapped ? const Offset(0, 2) : const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(AppRadius.lg),
                                    onTapDown: (_) => setState(() => _isTapped = true),
                                    onTapCancel: () => setState(() => _isTapped = false),
                                    onTap: () {
                                      setState(() => _isTapped = false);
                                      Future.delayed(const Duration(milliseconds: 120), () {
                                        if (mounted) _start();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (bounds) {
                                          return LinearGradient(
                                            colors: [
                                              AppColors.primary.withValues(alpha: 0.35),
                                              AppColors.primary,
                                              AppColors.primary.withValues(alpha: 0.35),
                                            ],
                                            stops: const [0.35, 0.5, 0.65],
                                            begin: Alignment(-2.0 + 4.0 * _pulseController.value, 0.0),
                                            end: Alignment(0.0 + 4.0 * _pulseController.value, 0.0),
                                          ).createShader(bounds);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppStrings.startApp,
                                              style: AppTextStyles.button.copyWith(
                                                color: Colors.white,
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(width: AppSpacing.sm),
                                            const Icon(
                                              Icons.arrow_forward,
                                              size: 23,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Spacer(flex: 1),
                    FadeTransition(
                      opacity: _bottomFade,
                      child: Text(
                        "Barcha huquqlar himoyalangan © 2026",
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
