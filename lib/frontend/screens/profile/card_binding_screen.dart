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
                    return _AnimatedCreditCard(
                      cardNumber: _cardNo.text,
                      expiry: _expiry.text,
                      cardHolder: _holder.text,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                // Test kartalari sarlavhasi va tugmalari
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Demo test kartalari (karta turini o'zgarishini ko'rish uchun tanlang):",
                    style: AppTextStyles.caption.copyWith(
                      color: secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _TestCardBadge(
                        label: "UZCARD",
                        color: const Color(0xFF00b09b),
                        onTap: () {
                          _cardNo.text = "8600 1234 5678 9012";
                          _expiry.text = "12/28";
                          _holder.text = "IVAN IVANOV";
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TestCardBadge(
                        label: "HUMO",
                        color: const Color(0xFF0072ff),
                        onTap: () {
                          _cardNo.text = "9860 1234 5678 9012";
                          _expiry.text = "08/29";
                          _holder.text = "PETR PETROV";
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TestCardBadge(
                        label: "VISA",
                        color: const Color(0xFF1D3557),
                        onTap: () {
                          _cardNo.text = "4000 1234 5678 9012";
                          _expiry.text = "05/30";
                          _holder.text = "JOHN DOE";
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TestCardBadge(
                        label: "MC",
                        color: const Color(0xFFe65c00),
                        onTap: () {
                          _cardNo.text = "5100 1234 5678 9012";
                          _expiry.text = "11/27";
                          _holder.text = "JANE DOE";
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

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
                    validator: (v) => (v == null || v.replaceAll(' ', '').length < 16)
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
    final text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    final clean = text.replaceAll(RegExp(r'\D'), '');

    final baseOffset = newValue.selection.baseOffset;
    final textBeforeCursor = baseOffset >= 0 && baseOffset <= text.length
        ? text.substring(0, baseOffset)
        : '';
    final digitsBeforeCursor = textBeforeCursor.replaceAll(RegExp(r'\D'), '').length;

    int cursorOffset = 0;
    int digitsWritten = 0;

    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(clean[i]);
      digitsWritten++;
      if (digitsWritten == digitsBeforeCursor) {
        cursorOffset = buffer.length;
      }
    }

    if (digitsBeforeCursor > digitsWritten) {
      cursorOffset = buffer.length;
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: cursorOffset),
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
    final text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    final clean = text.replaceAll(RegExp(r'\D'), '');

    final baseOffset = newValue.selection.baseOffset;
    final textBeforeCursor = baseOffset >= 0 && baseOffset <= text.length
        ? text.substring(0, baseOffset)
        : '';
    final digitsBeforeCursor = textBeforeCursor.replaceAll(RegExp(r'\D'), '').length;

    int cursorOffset = 0;
    int digitsWritten = 0;

    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(clean[i]);
      digitsWritten++;
      if (digitsWritten == digitsBeforeCursor) {
        cursorOffset = buffer.length;
      }
    }

    if (digitsBeforeCursor > digitsWritten) {
      cursorOffset = buffer.length;
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }
}

enum CardBrand { unknown, uzcard, humo, visa, mastercard }

class _TestCardBadge extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TestCardBadge({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedCreditCard extends StatefulWidget {
  final String cardNumber;
  final String expiry;
  final String cardHolder;

  const _AnimatedCreditCard({
    required this.cardNumber,
    required this.expiry,
    required this.cardHolder,
  });

  @override
  State<_AnimatedCreditCard> createState() => _AnimatedCreditCardState();
}

class _AnimatedCreditCardState extends State<_AnimatedCreditCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  CardBrand _detectBrand(String number) {
    final clean = number.replaceAll(' ', '');
    if (clean.startsWith('8600')) return CardBrand.uzcard;
    if (clean.startsWith('9860')) return CardBrand.humo;
    if (clean.startsWith('4')) return CardBrand.visa;
    if (clean.startsWith('5')) return CardBrand.mastercard;
    return CardBrand.unknown;
  }

  List<Color> _brandColors(CardBrand brand) {
    switch (brand) {
      case CardBrand.uzcard:
        return [const Color(0xFF00b09b), const Color(0xFF96c93d)];
      case CardBrand.humo:
        return [const Color(0xFF00c6ff), const Color(0xFF0072ff)];
      case CardBrand.visa:
        return [const Color(0xFF0E1A40), const Color(0xFF1D3557)];
      case CardBrand.mastercard:
        return [const Color(0xFFe65c00), const Color(0xFFF9D423)];
      default:
        return [AppColors.primary, AppColors.primaryLight];
    }
  }

  String _brandName(CardBrand brand) {
    switch (brand) {
      case CardBrand.uzcard:
        return 'UZCARD';
      case CardBrand.humo:
        return 'HUMO';
      case CardBrand.visa:
        return 'VISA';
      case CardBrand.mastercard:
        return 'MASTERCARD';
      default:
        return 'KARTA';
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = _detectBrand(widget.cardNumber);
    final colors = _brandColors(brand);
    final brandName = _brandName(brand);

    final numText = widget.cardNumber.isEmpty
        ? '•••• •••• •••• ••••'
        : widget.cardNumber;
    final expText = widget.expiry.isEmpty ? 'MM/YY' : widget.expiry;
    final nameText = widget.cardHolder.isEmpty
        ? 'KARTA EGASI'
        : widget.cardHolder.toUpperCase();

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background color transitions
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),

          // Metallic reflection shimmer effect
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.08),
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.08),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                    begin: Alignment(-2.0 + _shimmerController.value * 4.0, -1.0),
                    end: Alignment(-1.0 + _shimmerController.value * 4.0, 1.0),
                  ),
                ),
              );
            },
          ),

          // Card contents
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
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
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => ScaleTransition(
                        scale: anim,
                        child: child,
                      ),
                      child: Text(
                        brandName,
                        key: ValueKey(brandName),
                        style: AppTextStyles.bodyStrong.copyWith(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    numText,
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                    ),
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
          ),
        ],
      ),
    );
  }
}
