import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/remote_image.dart';
import '../vet/vet_list_screen.dart';

/// Maxsus taklif tafsiloti.
class PromoScreen extends StatelessWidget {
  const PromoScreen({super.key});

  static const List<String> _terms = [
    'Taklif birinchi marta ro\'yxatdan o\'tgan foydalanuvchilar uchun.',
    'Faqat birinchi veterinar ko\'rigiga amal qiladi.',
    'Boshqa chegirmalar bilan birga ishlamaydi.',
    'Muddat: 2025-yil oxirigacha.',
  ];

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.promoTag, style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(AppRadius.xl),
            ),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  RemoteImage(
                    url: MockData.products.isNotEmpty
                        ? 'https://loremflickr.com/600/400/veterinary,medical?lock=21'
                        : '',
                    fallbackBuilder: (_) => Container(color: AppColors.primary),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xE60E3D2C), Color(0x66134E3A)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            AppStrings.promoTag,
                            style: AppTextStyles.label.copyWith(
                              color: const Color(0xFF5A3A00),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          AppStrings.promoTitle,
                          style: AppTextStyles.h1.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yangi foydalanuvchilar uchun birinchi veterinar ko\'rigi '
                  'mutlaqo bepul! Hayvoningiz sog\'lig\'ini malakali '
                  'mutaxassisga tekshirtiring.',
                  style: AppTextStyles.body.copyWith(color: secondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Shartlar',
                  style: AppTextStyles.h3.copyWith(color: titleColor),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final t in _terms)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            t,
                            style: AppTextStyles.body.copyWith(
                              color: secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Veterinar tanlash',
                  trailingIcon: Icons.arrow_forward,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          const VetListScreen(title: 'Veterinarlar'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
