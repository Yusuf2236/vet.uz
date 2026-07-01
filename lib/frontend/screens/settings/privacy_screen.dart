import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Maxfiylik siyosati (matn).
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const List<({String h, String b})> _sections = [
    (
      h: "Qanday ma'lumot yig'amiz",
      b:
          'Ism, telefon raqami, joylashuv (ruxsat bilan), hayvonlaringiz va '
          "buyurtmalaringiz haqidagi ma'lumotlar — xizmat ko'rsatish uchun.",
    ),
    (
      h: 'Maʼlumotdan qanday foydalanamiz',
      b:
          'Veterinar topish, buyurtma va ko\'rikni boshqarish, eslatmalar '
          "yuborish uchun. Maʼlumotingizni uchinchi shaxslarga sotmaymiz.",
    ),
    (
      h: 'Xavfsizlik',
      b:
          'Maʼlumotlar himoyalangan serverda (RLS) saqlanadi va shifrlangan '
          'ulanish orqali uzatiladi. Parolingiz hech qachon ochiq saqlanmaydi.',
    ),
    (
      h: 'Sizning huquqlaringiz',
      b:
          "Istalgan vaqtda maʼlumotingizni ko'rish, tahrirlash yoki hisobni "
          "o'chirishni so'rashingiz mumkin: yordam@vetuz.uz.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Scaffold(
      appBar: AppBar(title: const Text('Maxfiylik', style: AppTextStyles.h3)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        children: [
          for (final s in _sections) ...[
            Text(s.h, style: AppTextStyles.title.copyWith(color: titleColor)),
            const SizedBox(height: AppSpacing.xs),
            Text(s.b, style: AppTextStyles.body.copyWith(color: secondary)),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}
