import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../widgets/vet_card.dart';
import '../../models/veterinarian.dart';

/// Integratsiyalashgan xarita ekrani — barcha platformalarda (Android, iOS, Linux) ishlaydi.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng _tashkentCenter = const LatLng(41.311081, 69.240562);
  Veterinarian? _selectedVet;

  void _onVetTap(Veterinarian vet) {
    setState(() {
      _selectedVet = vet;
    });
    if (vet.latitude != null && vet.longitude != null) {
      _mapController.move(LatLng(vet.latitude!, vet.longitude!), 14.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light/Dark mavzulariga mos chiroyli xarita stillari (CartoDB)
    final tileUrl = isDark
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';

    // Shifokorlar markerlarini yasash
    final markers = MockData.vets
        .where((v) => v.latitude != null && v.longitude != null)
        .map((vet) {
      final isSelected = _selectedVet?.name == vet.name;
      return Marker(
        point: LatLng(vet.latitude!, vet.longitude!),
        width: 120,
        height: 60,
        child: GestureDetector(
          onTap: () => _onVetTap(vet),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pin belgisi va narx/nom
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isSelected ? Colors.white : AppColors.primary,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.medical_services_rounded,
                      color: isSelected ? Colors.white : AppColors.primary,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      vet.name.split(' ').last,
                      style: AppTextStyles.label.copyWith(
                        color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              // Kichik pastki uchburchak pointer
              Icon(
                Icons.arrow_drop_down_rounded,
                color: isSelected ? AppColors.primary : AppColors.primary,
                size: 16,
              ),
            ],
          ),
        ),
      );
    }).toList();

    // Joriy joylashuv (foydalanuvchi) markeri
    markers.add(
      Marker(
        point: _tashkentCenter,
        width: 30,
        height: 30,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.info,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.info.withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Interaktiv Xarita
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _tashkentCenter,
                initialZoom: 11.5,
                maxZoom: 18.0,
                minZoom: 9.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: tileUrl,
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'uz.vetuz.vetuz',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),

          // Joylashuvni qayta markazlash tugmasi
          Positioned(
            top: 24,
            right: 16,
            child: SafeArea(
              child: FloatingActionButton.small(
                onPressed: () {
                  _mapController.move(_tashkentCenter, 11.5);
                  setState(() {
                    _selectedVet = null;
                  });
                },
                backgroundColor: Theme.of(context).cardColor,
                foregroundColor: AppColors.primary,
                child: const Icon(Icons.my_location_rounded),
              ),
            ),
          ),

          // Pastki panel — yaqin shifokorlar
          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.15,
            maxChildSize: 0.82,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xl),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, -3),
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
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      AppStrings.mapTitle,
                      style: AppTextStyles.h3.copyWith(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      "Shifokorni tanlang va uning xaritadagi joylashuvini ko'ring",
                      style: AppTextStyles.body.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    for (final vet in MockData.vets) ...[
                      GestureDetector(
                        onTap: () => _onVetTap(vet),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedVet?.name == vet.name
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: VetCard(vet: vet),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
