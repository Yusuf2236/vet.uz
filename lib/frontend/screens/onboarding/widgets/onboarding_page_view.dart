import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/onboarding_item.dart';
import '../../../widgets/remote_image.dart';
import 'page_progress.dart';

/// Bitta onboarding sahifasi: tepada rangli rasm kartasi, pastda oq panel
/// (progress + sarlavha + tavsif).
class OnboardingPageView extends StatefulWidget {
  final OnboardingItem item;
  final int index;
  final int total;

  const OnboardingPageView({
    super.key,
    required this.item,
    required this.index,
    required this.total,
  });

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _bodyOpacity;
  late final Animation<Offset> _bodySlide;
  late final Animation<double> _imageOpacity;
  late final Animation<double> _imageScale;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _imageOpacity = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _imageScale = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
    ));

    _titleOpacity = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    ));

    _bodyOpacity = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
    );
    _bodySlide = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant OnboardingPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      _animController.reset();
      _animController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sheetColor = Theme.of(context).scaffoldBackgroundColor;
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final bodyColor = Theme.of(context).textTheme.bodySmall?.color;

    return Column(
      children: [
        // Rangli yuqori qism + rasm o'rni
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.item.gradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: ScaleTransition(
                scale: _imageScale,
                child: FadeTransition(
                  opacity: _imageOpacity,
                  child: _ImageCard(item: widget.item),
                ),
              ),
            ),
          ),
        ),
        // Oq/Qorong'u panel
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: sheetColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.xl),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.xl,
              AppSpacing.xxl,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageProgress(current: widget.index, total: widget.total),
                const SizedBox(height: AppSpacing.xxl),
                SlideTransition(
                  position: _titleSlide,
                  child: FadeTransition(
                    opacity: _titleOpacity,
                    child: Text(
                      widget.item.title,
                      style: AppTextStyles.h1.copyWith(color: titleColor),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SlideTransition(
                  position: _bodySlide,
                  child: FadeTransition(
                    opacity: _bodyOpacity,
                    child: Text(
                      widget.item.body,
                      style: AppTextStyles.body.copyWith(color: bodyColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageCard extends StatelessWidget {
  final OnboardingItem item;
  const _ImageCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: SizedBox.expand(
              child: RemoteImage(
                url: item.imageUrl,
                fallbackBuilder: (context) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      item.icon,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(item.badgeIcon, color: item.gradient.last, size: 26),
            ),
          ),
        ],
      ),
    );
  }
}
