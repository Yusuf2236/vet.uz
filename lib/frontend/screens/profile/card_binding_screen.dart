import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../backend/repositories/profile_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../auth/widgets/labeled_field.dart';

/// Click/Payme Humo/Uzcard bog'lash ekrani (Tokenization demo).
class CardBindingScreen extends StatefulWidget {
  const CardBindingScreen({super.key});

  @override
  State<CardBindingScreen> createState() => _CardBindingScreenState();
}

class _CardBindingScreenState extends State<CardBindingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNo = TextEditingController();
  final _expiry = TextEditingController();
  final _holder = TextEditingController();
  bool _binding = false;

  @override
  void dispose() {
    _cardNo.dispose();
    _expiry.dispose();
    _holder.dispose();
    super.dispose();
  }

  /// SMS OTP tasdiqlash dialogi
  Future<void> _verifyOtp() async {
    final otpController = TextEditingController();
    final otpFormKey = GlobalKey<FormState>();

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          top: AppSpacing.xl,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
        ),
        child: Form(
          key: otpFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("SMS tasdiqlash", style: AppTextStyles.h2),
              const SizedBox(height: 6),
              Text(
                "Telefon raqamingizga yuborilgan 4 xonali kodni kiriting (Demo: 1111)",
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(ctx).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              LabeledField(
                label: 'SMS Kod',
                child: TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2.copyWith(letterSpacing: 8),
                  maxLength: 4,
                  validator: (v) =>
                      v != '1111' ? "Noto'g'ri kod kiritildi" : null,
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: '••••',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Tasdiqlash',
                onPressed: () {
                  if (otpFormKey.currentState?.validate() ?? false) {
                    Navigator.pop(ctx, true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      _completeBinding();
    } else {
      setState(() => _binding = false);
    }
  }

  /// Bog'lashni yakunlash va PRO rejimni yoqish
  Future<void> _completeBinding() async {
    final repo = ProfileRepository();
    final current = await repo.fetchCurrentProfile();
    final updated = current.copyWith(isPro: true);
    await repo.updateProfile(updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text("Karta muvaffaqiyatli ulandi. Premium faollashtirildi!"),
          backgroundColor: AppColors.success,
        ),
      );
    Navigator.pop(context, true);
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _binding = true);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      _verifyOtp();
    });
  }

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karta bog\'lash', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Vizual Karta maketi
                ListenableBuilder(
                  listenable: Listenable.merge([_cardNo, _expiry, _holder]),
                  builder: (context, _) {
                    final numText =
                        _cardNo.text.isEmpty ? '•••• •••• •••• ••••' : _cardNo.text;
                    final expText = _expiry.text.isEmpty ? 'MM/YY' : _expiry.text;
                    final nameText = _holder.text.isEmpty
                        ? 'KARTA EGASI'
                        : _holder.text.toUpperCase();

                    return Container(
                      height: 180,
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.contactless_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                              Text(
                                numText.startsWith('8600') ? 'UZCARD' : 'HUMO',
                                style: AppTextStyles.bodyStrong.copyWith(
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            numText,
                            style: AppTextStyles.h2.copyWith(
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  nameText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.caption.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Text(
                                expText,
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Kirish Formasi
                LabeledField(
                  label: "Karta raqami",
                  child: TextFormField(
                    controller: _cardNo,
                    keyboardType: TextInputType.number,
                    maxLength: 19,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CardNumberFormatter(),
                    ],
                    validator: (v) => (v == null || v.replaceFirst(' ', '').length < 19)
                        ? "Raqamni to'liq kiriting"
                        : null,
                    decoration: const InputDecoration(
                      counterText: '',
                      prefixIcon: Icon(Icons.credit_card, size: 20),
                      hintText: '8600 0000 0000 0000',
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: LabeledField(
                        label: "Amal qilish muddati",
                        child: TextFormField(
                          controller: _expiry,
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _ExpiryDateFormatter(),
                          ],
                          validator: (v) => (v == null || v.length < 5)
                              ? "Xato muddat"
                              : null,
                          decoration: const InputDecoration(
                            counterText: '',
                            hintText: 'MM/YY',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: LabeledField(
                        label: "Karta egasi",
                        child: TextFormField(
                          controller: _holder,
                          textCapitalization: TextCapitalization.characters,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? "Ismni kiriting"
                              : null,
                          decoration: const InputDecoration(
                            hintText: 'NAME SURNAME',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                PrimaryButton(
                  label: "Karta ulash",
                  loading: _binding,
                  onPressed: _binding ? null : _submit,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  "Click va Payme orqali xavfsiz tokenizatsiya amalga oshiriladi. Karta ma'lumotlari VetUz serverlarida saqlanmaydi.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(color: secondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Karta raqamining 4 ta raqamdan keyin bo'shliq qo'shuvchi formatlagichi.
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

/// Amal qilish muddatining MM/YY formatlagichi.
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 2 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
