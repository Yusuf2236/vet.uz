import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../../backend/repositories/clinic_repository.dart';
import '../../models/clinic.dart';

/// Favqulodda yordam — 24/7 klinikalar va davlat ishonch telefonlari.
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
          // Ogohlantirish banneri
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.emergency, AppColors.emergencyDark],
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    AppStrings.emergencySub,
                    style: AppTextStyles.bodyStrong.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            MockData.emergencyNote,
            style: AppTextStyles.body.copyWith(color: secondary),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Ishonch telefonlari
          _HotlineTile(
            label: MockData.stateHotlineLabel,
            number: MockData.stateHotline,
            onCall: () => _call(context, MockData.stateHotline),
          ),
          const SizedBox(height: AppSpacing.md),
          _HotlineTile(
            label: MockData.ministryHotlineLabel,
            number: MockData.ministryHotline,
            onCall: () => _call(context, MockData.ministryHotline),
          ),
          const SizedBox(height: AppSpacing.xl),

          Text(
            AppStrings.emergencyClinics,
            style: AppTextStyles.h3.copyWith(color: titleColor),
          ),
          const SizedBox(height: AppSpacing.md),
          FutureBuilder<List<Clinic>>(
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
        ],
      ),
    );
  }
}

class _HotlineTile extends StatelessWidget {
  final String label;
  final String number;
  final VoidCallback onCall;

  const _HotlineTile({
    required this.label,
    required this.number,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    return Container(
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
                  number,
                  style: AppTextStyles.title.copyWith(color: titleColor),
                ),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(color: secondary),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: AppStrings.call,
            onPressed: onCall,
            icon: const Icon(Icons.call, color: AppColors.success),
          ),
        ],
      ),
    );
  }
}

class _ClinicTile extends StatelessWidget {
  final Clinic clinic;
  final VoidCallback onCall;

  const _ClinicTile({required this.clinic, required this.onCall});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    return Container(
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
                  clinic.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: titleColor),
                ),
                Row(
                  children: [
                    Text(
                      '${clinic.district} · ',
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
          IconButton(
            tooltip: AppStrings.call,
            onPressed: onCall,
            icon: const Icon(Icons.call, color: AppColors.success),
          ),
        ],
      ),
    );
  }
}
