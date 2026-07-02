import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../animals/my_animals_screen.dart';
import '../clinic/clinic_list_screen.dart';
import '../market/market_screen.dart';
import '../vet/vet_list_screen.dart';
import '../../widgets/pressable.dart';

/// "Ko'proq" — VetUz qo'shimcha xizmatlari ro'yxati (ma'lumotli).
class MoreServicesScreen extends StatelessWidget {
  const MoreServicesScreen({super.key});

  static const List<
    ({IconData icon, Color color, Color tint, String title, String desc})
  >
  _services = [
    (
      icon: Icons.biotech_outlined,
      color: AppColors.purple,
      tint: AppColors.purpleTint,
      title: "Sun'iy urug'lantirish",
      desc: 'Chorva mollarini naslchilik bo\'yicha sun\'iy qochirish xizmati.',
    ),
    (
      icon: Icons.qr_code_2_outlined,
      color: AppColors.blue,
      tint: AppColors.blueTint,
      title: 'Chorva birkalash',
      desc:
          'Mollarni identifikatsiya qilish va davlat ro\'yxatiga olish (birka).',
    ),
    (
      icon: Icons.local_hotel_outlined,
      color: AppColors.teal,
      tint: AppColors.tealTint,
      title: 'Statsionar',
      desc: 'Og\'ir kasal hayvonlarni klinikada kuzatuv ostida davolash.',
    ),
    (
      icon: Icons.science_outlined,
      color: AppColors.cyan,
      tint: AppColors.cyanTint,
      title: 'Laboratoriya',
      desc: 'Qon, najas va sut tahlillari — kasallikni aniq diagnostika.',
    ),
    (
      icon: Icons.content_cut_outlined,
      color: AppColors.pink,
      tint: AppColors.pinkTint,
      title: 'Grooming',
      desc: 'Uy hayvonlarini cho\'miltirish, junini olish va parvarishlash.',
    ),
    (
      icon: Icons.home_outlined,
      color: AppColors.amber,
      tint: AppColors.amberTint,
      title: 'Uy chaqiruvi',
      desc: 'Veterinar uyingizga keladi — stress va safarsiz xizmat.',
    ),
    (
      icon: Icons.event_available_outlined,
      color: AppColors.green,
      tint: AppColors.greenTint,
      title: 'Emlash kalendari',
      desc: 'Hayvon turiga mos emlash jadvali va eslatmalar.',
    ),
    (
      icon: Icons.local_shipping_outlined,
      color: AppColors.red,
      tint: AppColors.redTint,
      title: 'Yetkazib berish',
      desc: 'Dori va ozuqalarni eshigingizgacha tez yetkazib berish.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(title: const Text('Xizmatlar', style: AppTextStyles.h3)),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        itemCount: _services.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, i) {
          final s = _services[i];
          return Pressable(
            onTap: () {
              switch (s.title) {
                case "Sun'iy urug'lantirish":
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => VetListScreen(
                        title: "Sun'iy urug'lantirish",
                        filter: (v) =>
                            v.specialty.contains('Yirik chorva') ||
                            v.animalType.toLowerCase().contains('qoramol'),
                      ),
                    ),
                  );
                case 'Chorva birkalash':
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => VetListScreen(
                        title: "Chorva birkalash",
                        filter: (v) =>
                            v.animalType.toLowerCase().contains('qoramol') ||
                            v.specialty.contains('Yirik chorva'),
                      ),
                    ),
                  );
                case 'Statsionar':
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const ClinicListScreen()),
                  );
                case 'Laboratoriya':
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => VetListScreen(
                        title: "Laboratoriya",
                        filter: (v) =>
                            v.specialty.contains('Diagnostika') ||
                            v.name.contains('Natalya'),
                      ),
                    ),
                  );
                case 'Grooming':
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => VetListScreen(
                        title: "Grooming",
                        filter: (v) => v.animalType.toLowerCase().contains('it'),
                      ),
                    ),
                  );
                case 'Uy chaqiruvi':
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const VetListScreen(title: "Uy chaqiruvi"),
                    ),
                  );
                case 'Emlash kalendari':
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const MyAnimalsScreen()),
                  );
                case 'Yetkazib berish':
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const Scaffold(body: MarketScreen()),
                    ),
                  );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: s.tint,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(s.icon, color: s.color, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          s.title,
                          style: AppTextStyles.title.copyWith(color: titleColor),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.desc,
                          style: AppTextStyles.caption.copyWith(color: secondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
