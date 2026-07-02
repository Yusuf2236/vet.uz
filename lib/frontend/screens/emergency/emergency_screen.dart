import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../../backend/repositories/clinic_repository.dart';
import '../../models/clinic.dart';
import '../../widgets/fade_slide_in.dart';

/// Favqulodda yordam — 24/7 klinikalar va davlat ishonch telefonlari.
/// Pulsatsiyalanuvchi banner, kirish animatsiyalari va to'liq interaktiv kartalar.
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final Future<List<Clinic>> _future = ClinicRepository().fetch247();

  void _call(BuildContext context, String number) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('${AppStrings.call}: $number')));
  }

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.emergencyTitle, style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        children: [
          // 1. Pulsatsiyalanuvchi ogohlantirish banneri (GPS haqidagi qism olib tashlandi)
          const FadeSlideIn(
            delay: Duration(milliseconds: 50),
            child: _PulsingEmergencyBanner(),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 2. Izoh matni
          FadeSlideIn(
            delay: const Duration(milliseconds: 100),
            child: Text(
              MockData.emergencyNote,
              style: AppTextStyles.body.copyWith(color: secondary),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // 3. Ishonch telefonlari (kirish animatsiyasi bilan)
          FadeSlideIn(
            delay: const Duration(milliseconds: 150),
            child: _HotlineTile(
              label: MockData.stateHotlineLabel,
              number: MockData.stateHotline,
              onCall: () => _call(context, MockData.stateHotline),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FadeSlideIn(
            delay: const Duration(milliseconds: 200),
            child: _HotlineTile(
              label: MockData.ministryHotlineLabel,
              number: MockData.ministryHotline,
              onCall: () => _call(context, MockData.ministryHotline),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // 4. Klinika sarlavhasi
          FadeSlideIn(
            delay: const Duration(milliseconds: 250),
            child: Text(
              AppStrings.emergencyClinics,
              style: AppTextStyles.h3.copyWith(color: titleColor),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 5. 24/7 ishlaydigan klinikalar ro'yxati
          FadeSlideIn(
            delay: const Duration(milliseconds: 300),
            child: FutureBuilder<List<Clinic>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final clinics = snap.data ?? const <Clinic>[];
                if (clinics.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Text(
                      'Hozircha 24/7 klinika topilmadi',
                      style: AppTextStyles.body.copyWith(color: secondary),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final c in clinics) ...[
                      _ClinicTile(
                        clinic: c,
                        onCall: () => _call(context, '+998 71 200-00-00'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Pulsatsiyalanuvchi premium favqulodda yordam banneri.
class _PulsingEmergencyBanner extends StatefulWidget {
  const _PulsingEmergencyBanner();

  @override
  State<_PulsingEmergencyBanner> createState() => _PulsingEmergencyBannerState();
}

class _PulsingEmergencyBannerState extends State<_PulsingEmergencyBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 4.0, end: 16.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.emergency, AppColors.emergencyDark],
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                color: AppColors.emergency.withValues(alpha: 0.4),
                blurRadius: _glowAnimation.value,
                spreadRadius: _glowAnimation.value / 3,
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  const Icon(
                    Icons.phone_in_talk_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "24/7 Tezkor aloqa",
                      style: AppTextStyles.bodyStrong.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Shoshilinch yordam olish uchun qo'ng'iroq qiling",
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HotlineTile extends StatefulWidget {
  final String label;
  final String number;
  final VoidCallback onCall;

  const _HotlineTile({
    required this.label,
    required this.number,
    required this.onCall,
  });

  @override
  State<_HotlineTile> createState() => _HotlineTileState();
}

class _HotlineTileState extends State<_HotlineTile> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onCall,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.support_agent, color: AppColors.danger),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.number,
                      style: AppTextStyles.title.copyWith(color: titleColor),
                    ),
                    Text(
                      widget.label,
                      style: AppTextStyles.caption.copyWith(color: secondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.call, color: AppColors.success),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClinicTile extends StatefulWidget {
  final Clinic clinic;
  final VoidCallback onCall;

  const _ClinicTile({required this.clinic, required this.onCall});

  @override
  State<_ClinicTile> createState() => _ClinicTileState();
}

class _ClinicTileState extends State<_ClinicTile> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onCall,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.tealTint,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.local_hospital_outlined,
                  color: AppColors.teal,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.clinic.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(color: titleColor),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.clinic.district} · ',
                          style: AppTextStyles.caption.copyWith(color: secondary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            '24/7',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.call, color: AppColors.success),
            ],
          ),
        ),
      ),
    );
  }
}
