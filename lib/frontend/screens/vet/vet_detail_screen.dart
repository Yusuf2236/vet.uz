import 'package:flutter/material.dart';

import '../../../backend/repositories/auth_repository.dart';
import '../../core/router/app_routes.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/veterinarian.dart';
import '../../widgets/price_text.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/remote_image.dart';

/// Veterinar tafsilotlari + xizmat band qilish.
class VetDetailScreen extends StatelessWidget {
  final Veterinarian vet;
  const VetDetailScreen({super.key, required this.vet});

  static const List<String> _services = [
    'Birlamchi ko\'rik',
    'Emlash (vaksinatsiya)',
    'Uy chaqiruvi',
    'Tahlil va diagnostika',
  ];

  Future<void> _book(BuildContext context) async {
    if (!AuthRepository().isLoggedIn) {
      final ok = await Navigator.of(context).pushNamed(AppRoutes.login);
      if (ok != true || !context.mounted) return;
    }
    if (!context.mounted) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => _BookingSheet(vet: vet),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(title: Text(vet.name, style: AppTextStyles.h3)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: SizedBox(
                  width: 84,
                  height: 84,
                  child: RemoteImage(
                    url: AppImages.avatar(vet.name),
                    fallbackBuilder: (context) => Container(
                      color: AppColors.primary,
                      alignment: Alignment.center,
                      child: Text(
                        vet.initials,
                        style: AppTextStyles.h1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      vet.name,
                      style: AppTextStyles.h2.copyWith(color: titleColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vet.specialty,
                      style: AppTextStyles.body.copyWith(color: secondary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 15, color: AppColors.star),
                        const SizedBox(width: 3),
                        Text(
                          vet.rating.toStringAsFixed(1),
                          style: AppTextStyles.caption.copyWith(
                            color: titleColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: secondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${vet.district} · ${vet.distanceKm} km',
                          style: AppTextStyles.caption.copyWith(
                            color: secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _InfoChip(
                icon: Icons.pets_outlined,
                label: vet.animalType.isEmpty ? '—' : vet.animalType,
              ),
              const SizedBox(width: AppSpacing.sm),
              _InfoChip(
                icon: vet.isAvailable
                    ? Icons.check_circle_outline
                    : Icons.do_not_disturb_on_outlined,
                label: vet.isAvailable ? AppStrings.free : AppStrings.busy,
                color: vet.isAvailable
                    ? AppColors.success
                    : AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            AppStrings.vetServices,
            style: AppTextStyles.h3.copyWith(color: titleColor),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final s in _services)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 18, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    s,
                    style: AppTextStyles.body.copyWith(color: titleColor),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ko\'rik narxi',
                    style: AppTextStyles.caption.copyWith(color: secondary),
                  ),
                  PriceText(
                    amount: vet.priceSom,
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: PrimaryButton(
                  label: AppStrings.book,
                  onPressed: vet.isAvailable ? () => _book(context) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).textTheme.bodyMedium?.color;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: c),
          const SizedBox(width: 5),
          Text(label, style: AppTextStyles.caption.copyWith(color: c)),
        ],
      ),
    );
  }
}

/// Ko'rikka yozilish — sana va vaqt slotini tanlash.
class _BookingSheet extends StatefulWidget {
  final Veterinarian vet;
  const _BookingSheet({required this.vet});

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  static const List<String> _weekdays = [
    'Dush',
    'Sesh',
    'Chor',
    'Pay',
    'Jum',
    'Shan',
    'Yak',
  ];
  static const List<String> _slots = [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  late final List<DateTime> _days = List.generate(
    5,
    (i) => DateTime.now().add(Duration(days: i)),
  );
  int _dayIndex = 0;
  int? _slotIndex;

  void _confirm() {
    final d = _days[_dayIndex];
    final label = '${d.day}.${d.month} ${_slots[_slotIndex!]}';
    // Messenger'ni pop'dan OLDIN olamiz (pop'dan keyin bu route topilmaydi).
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Ko\'rik band qilindi: $label')));
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ko'rikka yozilish",
              style: AppTextStyles.h2.copyWith(color: titleColor),
            ),
            Text(
              widget.vet.name,
              style: AppTextStyles.caption.copyWith(color: secondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Sana',
              style: AppTextStyles.bodyStrong.copyWith(color: secondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final active = i == _dayIndex;
                  final d = _days[i];
                  return GestureDetector(
                    onTap: () => setState(() => _dayIndex = i),
                    child: Container(
                      width: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary
                            : Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: active
                              ? AppColors.primary
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weekdays[d.weekday - 1],
                            style: AppTextStyles.label.copyWith(
                              color: active ? Colors.white : secondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${d.day}',
                            style: AppTextStyles.h3.copyWith(
                              color: active ? Colors.white : titleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Vaqt',
              style: AppTextStyles.bodyStrong.copyWith(color: secondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (int i = 0; i < _slots.length; i++)
                  GestureDetector(
                    onTap: () => setState(() => _slotIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: _slotIndex == i
                            ? AppColors.primary
                            : Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: _slotIndex == i
                              ? AppColors.primary
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Text(
                        _slots[i],
                        style: AppTextStyles.bodyStrong.copyWith(
                          color: _slotIndex == i ? Colors.white : titleColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: AppStrings.book,
              onPressed: _slotIndex == null ? null : _confirm,
            ),
          ],
        ),
      ),
    );
  }
}
