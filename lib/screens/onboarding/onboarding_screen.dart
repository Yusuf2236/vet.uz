import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/router/app_routes.dart';
import '../../core/services/preferences_service.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/mock_data.dart';
import '../../models/onboarding_item.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import 'widgets/onboarding_page_view.dart';

/// Tanishtiruv (onboarding) — 5 ta sahifa.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final List<OnboardingItem> _pages = MockData.onboarding;
  int _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finish() {
    PreferencesService.instance.setOnboarded(true);
    Navigator.of(context).pushReplacementNamed(AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: _pages.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (context, i) => OnboardingPageView(
          item: MockData.onboarding[i],
          index: i,
          total: _pages.length,
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              0,
              AppSpacing.xxl,
              AppSpacing.lg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: AppStrings.skip,
                    onPressed: _finish,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    label: _isLast ? AppStrings.start : AppStrings.next,
                    trailingIcon: _isLast ? null : Icons.arrow_forward,
                    onPressed: _next,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
