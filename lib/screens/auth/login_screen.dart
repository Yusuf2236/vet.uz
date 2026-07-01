import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_strings.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/phone_input_formatter.dart';
import '../../core/utils/validators.dart';
import '../../backend/app_config.dart';
import '../../backend/repositories/auth_repository.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import 'widgets/labeled_field.dart';

/// Tizimga kirish ekrani (senior daraja: validatsiya, loading/xato holatlari,
/// fokus oqimi, autofill, accessibility).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscure = true;
  bool _isLoading = false;
  bool _autovalidate = false;
  String? _errorText;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      setState(() => _autovalidate = true);
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    // Demo rejim (backend auth o'chiq): mock kechikish + '000000' = xato.
    // Backend auth yoqilganda bu o'tkazib yuboriladi — faqat real signIn.
    if (!AppConfig.useBackendAuth) {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      if (_password.text.trim() == '000000') {
        setState(() {
          _isLoading = false;
          _errorText = AppStrings.loginError;
        });
        HapticFeedback.heavyImpact();
        return;
      }
    }

    try {
      final digits = UzPhoneInputFormatter.digitsOf(_phone.text);
      await AuthRepository().signIn('+998$digits', _password.text.trim());
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorText = AppStrings.loginError;
      });
      HapticFeedback.heavyImpact();
      return;
    }
    HapticFeedback.lightImpact();
    TextInput.finishAutofillContext();
    if (!mounted) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
    }
  }

  Future<void> _biometricLogin() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    HapticFeedback.lightImpact();
    try {
      // Demo: lokal kirish. (Haqiqiy biometrika local_auth + saqlangan sessiya
      // bilan keyin ulanadi.)
      await AuthRepository().signIn('+998000000000', 'biometric');
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorText = AppStrings.loginError;
      });
      return;
    }
    if (!mounted) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
    }
  }

  void _back() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: _FadeSlideIn(
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.sm),
                      _BackButton(onTap: _back),
                      const SizedBox(height: AppSpacing.xl),
                      const ExcludeSemantics(child: AppLogo.badge(size: 52)),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        AppStrings.welcome,
                        style: AppTextStyles.h1.copyWith(color: titleColor),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppStrings.loginSubtitle,
                        style: AppTextStyles.body.copyWith(color: secondary),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      LabeledField(
                        label: AppStrings.phone,
                        child: _PhoneField(
                          controller: _phone,
                          focusNode: _phoneFocus,
                          onComplete: () => _passwordFocus.requestFocus(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      LabeledField(
                        label: AppStrings.password,
                        child: TextFormField(
                          controller: _password,
                          focusNode: _passwordFocus,
                          obscureText: _obscure,
                          obscuringCharacter: '•',
                          keyboardType: TextInputType.visiblePassword,
                          enableSuggestions: false,
                          autocorrect: false,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          validator: Validators.password,
                          onFieldSubmitted: (_) => _login(),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              tooltip: _obscure
                                  ? AppStrings.showPassword
                                  : AppStrings.hidePassword,
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _LinkButton(
                          label: AppStrings.forgotPassword,
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.forgotPassword),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _ErrorBanner(text: _errorText),
                      PrimaryButton(
                        label: AppStrings.login,
                        loading: _isLoading,
                        onPressed: _isLoading ? null : _login,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _OrDivider(label: AppStrings.orDivider, color: secondary),
                      const SizedBox(height: AppSpacing.xl),
                      Semantics(
                        button: true,
                        label: AppStrings.biometricLogin,
                        child: SecondaryButton(
                          label: AppStrings.biometricLogin,
                          leadingIcon: Icons.fingerprint,
                          foreground: titleColor ?? AppColors.textPrimary,
                          onPressed: _isLoading ? null : _biometricLogin,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${AppStrings.noAccount} ',
                            style: AppTextStyles.body.copyWith(
                              color: secondary,
                            ),
                          ),
                          _LinkButton(
                            label: AppStrings.register,
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.register),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Orqaga" tugmasi — 48dp tap-target + ripple + semantics.
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyMedium?.color;
    return Semantics(
      button: true,
      label: AppStrings.back,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chevron_left, color: color),
                Text(
                  AppStrings.back,
                  style: AppTextStyles.bodyStrong.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Matnli havola tugmasi — 44dp+ tap-target, ripple, semantics.
class _LinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LinkButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: AppTextStyles.bodyStrong.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Umumiy xato banneri — skrinrider e'lon qilishi uchun liveRegion.
class _ErrorBanner extends StatelessWidget {
  final String? text;
  const _ErrorBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: text == null
          ? const SizedBox(width: double.infinity, key: ValueKey('no-error'))
          : Padding(
              key: const ValueKey('error'),
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Semantics(
                liveRegion: true,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: AppColors.danger.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.danger,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          text!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.danger,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

/// Telefon maydoni — avto-format, 🇺🇿 bayroq, to'liq bo'lganda ✓.
class _PhoneField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onComplete;

  const _PhoneField({
    required this.controller,
    required this.focusNode,
    this.onComplete,
  });

  @override
  State<_PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<_PhoneField> {
  bool _complete = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    final done = UzPhoneInputFormatter.isComplete(widget.controller.text);
    if (done != _complete) {
      setState(() => _complete = done);
      if (done) {
        HapticFeedback.selectionClick();
        widget.onComplete?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor;
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: true,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      inputFormatters: [UzPhoneInputFormatter()],
      validator: Validators.phone,
      decoration: InputDecoration(
        hintText: AppStrings.phoneHint,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ExcludeSemantics(
                child: Text('🇺🇿', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '+998',
                style: AppTextStyles.bodyStrong.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(width: 1, height: 22, color: dividerColor),
            ],
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: _complete
              ? Icon(
                  Icons.check_circle,
                  key: const ValueKey('valid'),
                  color: AppColors.success,
                  size: 20,
                  semanticLabel: AppStrings.phoneCompleteHint,
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ),
    );
  }
}

/// "yoki" ajratuvchi chiziq.
class _OrDivider extends StatelessWidget {
  final String label;
  final Color? color;
  const _OrDivider({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Divider(color: Theme.of(context).dividerColor),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: color),
          ),
        ),
        line,
      ],
    );
  }
}

/// Ekran ochilganda kontentni silliq ko'tarib chiqaruvchi animatsiya
/// (fade + pastdan yuqoriga siljish).
class _FadeSlideIn extends StatefulWidget {
  final Widget child;
  const _FadeSlideIn({required this.child});

  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 480),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.04),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
