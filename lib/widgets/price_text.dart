import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';

/// Narxni "80 000 so'm" ko'rinishida chiqaradi (mingliklarni ajratib).
class PriceText extends StatelessWidget {
  final int amount;
  final TextStyle? style;
  final Color? color;

  const PriceText({super.key, required this.amount, this.style, this.color});

  static String format(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i != 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final base =
        style ??
        AppTextStyles.bodyStrong.copyWith(
          color: color ?? Theme.of(context).textTheme.titleMedium?.color,
          fontWeight: FontWeight.w700,
        );
    return Text('${format(amount)} ${AppStrings.currency}', style: base);
  }
}
