import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../backend/repositories/order_repository.dart';
import '../../core/constants/app_images.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/preferences_service.dart';
import '../../models/order.dart';
import '../../models/veterinarian.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/radar_rings.dart';
import '../../widgets/remote_image.dart';

/// Veterinar shifokorini qidirish va chaqirish ekrani (Premium UI).
class VetCallSearchScreen extends StatefulWidget {
  final Veterinarian vet;
  final String dateTimeLabel;

  const VetCallSearchScreen({
    super.key,
    required this.vet,
    required this.dateTimeLabel,
  });

  @override
  State<VetCallSearchScreen> createState() => _VetCallSearchScreenState();
}

class _VetCallSearchScreenState extends State<VetCallSearchScreen> {
  int _searchStage = 0; // 0: Lokatsiya aniqlanmoqda, 1: Shifokor bilan bog'lanilmoqda, 2: Qabul qilindi
  Timer? _stageTimer;

  @override
  void initState() {
    super.initState();
    
    // Simulyatsiya qilingan bosqichma-bosqich qidiruv
    _stageTimer = Timer.periodic(const Duration(milliseconds: 1800), (timer) {
      if (!mounted) return;
      setState(() {
        _searchStage++;
        if (_searchStage >= 2) {
          _searchStage = 2;
          timer.cancel();
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.selectionClick();
        }
      });
    });
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    super.dispose();
  }

  String get _stageText {
    switch (_searchStage) {
      case 0:
        return "Sizning manzilingiz aniqlanmoqda...";
      case 1:
        return "Yaqin atrofdagi shifokorlarga so'rov yuborilmoqda...";
      default:
        return "Chaqiruv muvaffaqiyatli qabul qilindi!";
    }
  }

  void _confirmBooking() {
    final isPro = PreferencesService.instance.isPro;
    final finalPrice = isPro ? (widget.vet.priceSom * 0.9).round() : widget.vet.priceSom;
    
    // Buyurtmani ro'yxatga qo'shish
    final orderId = 2000 + (DateTime.now().millisecond % 1000);
    OrderRepository.addLocalOrder(
      OrderModel(
        id: orderId,
        totalSom: finalPrice,
        status: 'processing',
        createdAt: DateTime.now(),
        itemCount: 0, // Xizmat ko'rsatish
      ),
    );

    HapticFeedback.mediumImpact();

    // Muvaffaqiyat xabaridan so'ng orqaga qaytish
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.vet.name} chaqiruvi muvaffaqiyatli band qilindi!"),
        backgroundColor: AppColors.success,
      ),
    );
    
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final isPro = PreferencesService.instance.isPro;
    final discountPrice = (widget.vet.priceSom * 0.9).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shifokor chaqirish", style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),
              
              // Animatsiyali qidiruv sohasi
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Radar sonar to'lqinlari (agar hali topilmagan bo'lsa)
                      if (_searchStage < 2)
                        RadarRings(
                          color: AppColors.primary.withValues(alpha: 0.8),
                          waves: 4,
                          center: Alignment.center,
                        ),

                      // Markaziy vizual holat
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _searchStage < 2
                            ? Container(
                                key: const ValueKey('searching'),
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_searching,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                              )
                            : Column(
                                key: const ValueKey('matched'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(AppRadius.xl),
                                    child: SizedBox(
                                      width: 110,
                                      height: 110,
                                      child: RemoteImage(
                                        url: AppImages.avatar(widget.vet.name),
                                        fallbackBuilder: (_) => Container(
                                          color: AppColors.primary,
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.vet.initials,
                                            style: AppTextStyles.h1.copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    widget.vet.name,
                                    style: AppTextStyles.h2.copyWith(color: titleColor),
                                  ),
                                  Text(
                                    widget.vet.specialty,
                                    style: AppTextStyles.body.copyWith(color: secondary),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star, size: 16, color: AppColors.star),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.vet.rating.toStringAsFixed(1),
                                        style: AppTextStyles.bodyStrong.copyWith(color: titleColor),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(Icons.directions_car_filled_outlined, size: 16, color: secondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        "15 daqiqa",
                                        style: AppTextStyles.bodyStrong.copyWith(color: titleColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Matnli ma'lumot
              Text(
                _stageText,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyStrong.copyWith(
                  color: _searchStage == 2 ? AppColors.success : titleColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Sana va vaqt: ${widget.dateTimeLabel}",
                style: AppTextStyles.caption.copyWith(color: secondary),
              ),
              
              const SizedBox(height: AppSpacing.xl),

              // Pastki qism: Narx va Tasdiqlash tugmasi
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _searchStage == 2 ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Xizmat haqi:",
                            style: AppTextStyles.body.copyWith(color: secondary),
                          ),
                          if (isPro)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${widget.vet.priceSom} so'm",
                                  style: AppTextStyles.caption.copyWith(
                                    color: secondary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  "$discountPrice so'm",
                                  style: AppTextStyles.h3.copyWith(color: AppColors.success),
                                ),
                              ],
                            )
                          else
                            Text(
                              "${widget.vet.priceSom} so'm",
                              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                            ),
                        ],
                      ),
                      
                      // PRO chegirma belgisi
                      if (isPro) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: AppColors.success, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                "Premium -10% chegirma qo'llandi",
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: AppSpacing.lg),
                      PrimaryButton(
                        label: "Chaqiruvni tasdiqlash",
                        onPressed: _searchStage == 2 ? _confirmBooking : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
