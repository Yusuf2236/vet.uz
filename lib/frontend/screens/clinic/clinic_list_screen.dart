import 'package:flutter/material.dart';

import '../../../backend/repositories/clinic_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/clinic.dart';
import '../../widgets/async_view.dart';

/// Veterinariya klinikalari ro'yxati.
class ClinicListScreen extends StatefulWidget {
  const ClinicListScreen({super.key});

  @override
  State<ClinicListScreen> createState() => _ClinicListScreenState();
}

class _ClinicListScreenState extends State<ClinicListScreen> {
  late Future<List<Clinic>> _future = ClinicRepository().fetchClinics();

  void _reload() => setState(() => _future = ClinicRepository().fetchClinics());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Klinikalar', style: AppTextStyles.h3)),
      body: AsyncView<List<Clinic>>(
        future: _future,
        onRetry: _reload,
        isEmpty: (l) => l.isEmpty,
        emptyMessage: 'Klinika topilmadi',
        builder: (context, clinics) => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          itemCount: clinics.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, i) => _ClinicCard(clinic: clinics[i]),
        ),
      ),
    );
  }
}

class _ClinicCard extends StatelessWidget {
  final Clinic clinic;
  const _ClinicCard({required this.clinic});

  ({Color color, Color tint, IconData icon}) _visual(String type) {
    switch (type) {
      case 'dorixona':
        return (
          color: AppColors.pink,
          tint: AppColors.pinkTint,
          icon: Icons.medication_outlined,
        );
      case 'davlat':
        return (
          color: AppColors.blue,
          tint: AppColors.blueTint,
          icon: Icons.account_balance_outlined,
        );
      default:
        return (
          color: AppColors.teal,
          tint: AppColors.tealTint,
          icon: Icons.local_hospital_outlined,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final v = _visual(clinic.type);

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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: v.tint,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(v.icon, color: v.color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  clinic.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: titleColor),
                ),
                const SizedBox(height: 2),
                Text(
                  '${clinic.district} · ${clinic.type}',
                  style: AppTextStyles.caption.copyWith(color: secondary),
                ),
              ],
            ),
          ),
          if (clinic.open247)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                '24/7',
                style: AppTextStyles.label.copyWith(color: AppColors.success),
              ),
            ),
        ],
      ),
    );
  }
}
