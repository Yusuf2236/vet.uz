import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/farm_stat.dart';
import 'section_header.dart';

/// "Ferma holati" kartasi — 3 ta ko'rsatkichli mini panel.
class FarmStatusCard extends StatelessWidget {
  final List<FarmStat> stats;
  final VoidCallback? onDetails;

  const FarmStatusCard({super.key, required this.stats, this.onDetails});

  static const List<Color> _valueColors = [
    AppColors.primary,
    AppColors.info,
    AppColors.accent,
  ];

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).cardColor;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        children: [
          SectionHeader(
            title: AppStrings.farmStatus,
            actionLabel: '${AppStrings.details} →',
            onAction: onDetails,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (int i = 0; i < stats.length; i++) ...[
                if (i != 0) const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatBox(
                    stat: stats[i],
                    valueColor: _valueColors[i % _valueColors.length],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final FarmStat stat;
  final Color valueColor;

  const _StatBox({required this.stat, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(stat.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(stat.value, style: AppTextStyles.h3.copyWith(color: valueColor)),
          const SizedBox(height: 2),
          Text(
            stat.unit,
            style: AppTextStyles.caption.copyWith(color: secondary),
          ),
        ],
      ),
    );
  }
}
