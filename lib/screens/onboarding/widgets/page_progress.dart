import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Onboarding progress indikatori — joriy sahifa uzun yashil chiziq,
/// qolganlari kichik kulrang nuqtalar.
class PageProgress extends StatelessWidget {
  final int current;
  final int total;

  const PageProgress({super.key, required this.current, required this.total});

  Widget _bar(Color color) {
    return Container(
      height: 5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inactive = Theme.of(context).dividerColor;
    return SizedBox(
      height: 5,
      child: Row(
        children: [
          for (int i = 0; i < total; i++) ...[
            if (i != 0) const SizedBox(width: 6),
            if (i == current)
              Expanded(child: _bar(AppColors.primary))
            else
              SizedBox(
                width: 22,
                child: _bar(i < current ? AppColors.primary : inactive),
              ),
          ],
        ],
      ),
    );
  }
}
