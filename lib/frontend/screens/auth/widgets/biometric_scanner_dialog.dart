import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Premium animatsiyali biometrik (barmoq izi / Face ID) skanerlash dialogi.
class BiometricScannerDialog extends StatefulWidget {
  final bool useFaceId;
  const BiometricScannerDialog({super.key, this.useFaceId = false});

  @override
  State<BiometricScannerDialog> createState() => _BiometricScannerDialogState();
}

class _BiometricScannerDialogState extends State<BiometricScannerDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scannerController;
  late final Animation<double> _laserPosition;
  
  double _progress = 0.0;
  String _statusText = "Barmoq izi skanerlanmoqda...";
  bool _isSuccess = false;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    
    _statusText = widget.useFaceId 
        ? "Yuz tuzilishi skanerlanmoqda..." 
        : "Barmoq izi skanerlanmoqda...";

    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _laserPosition = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scannerController,
        curve: Curves.easeInOut,
      ),
    );

    _scannerController.repeat(reverse: true);

    // Simulyatsiya qilingan progress
    _progressTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.015;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _isSuccess = true;
          _statusText = "Muvaffaqiyatli tanib olindi!";
          _scannerController.stop();
          _progressTimer?.cancel();
          HapticFeedback.mediumImpact();
          
          // Muvaffaqiyatli tugagandan so'ng biroz kutib yopiladi
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? Colors.grey[900]! : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: dialogBg,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Yuqori bar (Tugma bilan yopish)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.useFaceId ? "Face ID" : "Touch ID",
                    style: AppTextStyles.bodyStrong.copyWith(color: textColor),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Skanerlash sohasi (Progress ring va Laser)
              Stack(
                alignment: Alignment.center,
                children: [
                  // Doiraviy progress
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 4,
                      backgroundColor: isDark 
                          ? Colors.white.withValues(alpha: 0.1) 
                          : Colors.black.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isSuccess ? AppColors.success : AppColors.primary,
                      ),
                    ),
                  ),

                  // Skaner belgisi va Laser chizig'i
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ikon
                        AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: _isSuccess ? 1.1 : 1.0,
                          child: Icon(
                            _isSuccess
                                ? Icons.check_circle_outline
                                : (widget.useFaceId
                                    ? Icons.face_retouching_natural
                                    : Icons.fingerprint),
                            size: 64,
                            color: _isSuccess
                                ? AppColors.success
                                : AppColors.primary,
                          ),
                        ),

                        // Laser Sweep (agar muvaffaqiyatli tugamagan bo'lsa)
                        if (!_isSuccess)
                          AnimatedBuilder(
                            animation: _laserPosition,
                            builder: (context, child) {
                              return Positioned(
                                top: 55 + (_laserPosition.value * 40),
                                left: 10,
                                right: 10,
                                child: Container(
                                  height: 2.5,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryLight.withValues(alpha: 0.8),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Holat matni
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _statusText,
                  key: ValueKey(_statusText),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyStrong.copyWith(
                    color: _isSuccess ? AppColors.success : textColor,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
