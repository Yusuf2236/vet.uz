import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../widgets/section_header.dart';

/// Ferma boshqaruvi — ko'rsatkichlar va emlash eslatmalari.
class FarmManagementScreen extends StatelessWidget {
  const FarmManagementScreen({super.key});

  static const List<({String animal, String vaccine, String due, bool soon})>
  _reminders = [
    (
      animal: 'Qoramol podasi',
      vaccine: 'Yashur (oqsil) vaksinasi',
      due: '3 kun ichida',
      soon: true,
    ),
    (
      animal: 'Boychibor',
      vaccine: 'Kuydirgi vaksinasi',
      due: '12 kun ichida',
      soon: false,
    ),
    (
      animal: 'Olapar (it)',
      vaccine: 'Quturishga qarshi',
      due: '1 hafta ichida',
      soon: true,
    ),
    (
      animal: 'Tovuqlar',
      vaccine: 'Nyukasl (La-Sota)',
      due: '20 kun ichida',
      soon: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.farmManagement, style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        children: [
          Text(
            AppStrings.farmStatus,
            style: AppTextStyles.h3.copyWith(color: titleColor),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (int i = 0; i < MockData.farmStats.length; i++) ...[
                if (i != 0) const SizedBox(width: AppSpacing.md),
                Expanded(child: _StatBox(index: i)),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: 'Emlash eslatmalari'),
          const SizedBox(height: AppSpacing.md),
          for (final r in _reminders) ...[
            _ReminderTile(
              animal: r.animal,
              vaccine: r.vaccine,
              due: r.due,
              soon: r.soon,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final int index;
  const _StatBox({required this.index});

  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.info,
    AppColors.accent,
  ];

  @override
  Widget build(BuildContext context) {
    final stat = MockData.farmStats[index];
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    // 1-ko'rsatkich temaga mos (dark'da primaryLight) — kontrast uchun.
    final valueColor = index == 0
        ? Theme.of(context).colorScheme.primary
        : _colors[index % _colors.length];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Text(stat.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stat.value,
              style: AppTextStyles.h3.copyWith(color: valueColor),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stat.unit,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final String animal;
  final String vaccine;
  final String due;
  final bool soon;

  const _ReminderTile({
    required this.animal,
    required this.vaccine,
    required this.due,
    required this.soon,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final c = soon ? AppColors.danger : AppColors.warning;

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
              color: c.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.vaccines_outlined, color: c, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  vaccine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: titleColor),
                ),
                Text(
                  '$animal · $due',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
