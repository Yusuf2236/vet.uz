import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../widgets/vet_card.dart';
import 'widgets/map_backdrop.dart';
// Yandex faqat mobil koddan import qilinadi (web stub'ni oladi).
import 'map_view_stub.dart' if (dart.library.io) 'map_view_io.dart';

/// Xarita ekrani — soddalashtirilgan xarita + yaqin xizmatlar ro'yxati.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Android/iOS — haqiqiy Yandex xarita; aks holda fallback.
        Positioned.fill(child: platformYandexMap() ?? const _MapArea()),
        // Pastki panel — yaqin veterinarlar
        DraggableScrollableSheet(
          initialChildSize: 0.42,
          minChildSize: 0.42,
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xl),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenH,
                  AppSpacing.md,
                  AppSpacing.screenH,
                  AppSpacing.xxl,
                ),
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppStrings.mapTitle,
                    style: AppTextStyles.h3.copyWith(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final vet in MockData.vets) ...[
                    VetCard(vet: vet),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MapArea extends StatelessWidget {
  const _MapArea();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: const [
          Positioned.fill(child: MapBackdrop()),
          // Veterinar nuqtalari
          Positioned(top: 90, left: 60, child: _MapPin(label: '80k')),
          Positioned(top: 160, right: 70, child: _MapPin(label: '65k')),
          Positioned(top: 250, left: 110, child: _MapPin(label: '120k')),
          // Joriy joylashuv
          Positioned.fill(child: Center(child: _CurrentLocationDot())),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final String label;
  const _MapPin({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.medical_services, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.label.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _CurrentLocationDot extends StatelessWidget {
  const _CurrentLocationDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: AppColors.info,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.5),
            blurRadius: 12,
            spreadRadius: 4,
          ),
        ],
      ),
    );
  }
}
