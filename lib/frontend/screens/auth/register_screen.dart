import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/phone_input_formatter.dart';
import '../../core/utils/validators.dart';
import '../../../backend/repositories/auth_repository.dart';
import '../../widgets/primary_button.dart';
import 'widgets/labeled_field.dart';

/// Ro'yxatdan o'tish ekrani.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  bool _autovalidate = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _autovalidate = true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final digits = UzPhoneInputFormatter.digitsOf(_phone.text);
      await AuthRepository().signUp('+998$digits', _password.text.trim());
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Xatolik yuz berdi')));
      return;
    }
    if (!mounted) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.registerTitle, style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.registerSubtitle,
                  style: AppTextStyles.body.copyWith(color: secondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                LabeledField(
                  label: AppStrings.fullName,
                  child: TextFormField(
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? AppStrings.fullNameRequired
                        : null,
                    decoration: const InputDecoration(
                      hintText: AppStrings.fullNameHint,
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                LabeledField(
                  label: AppStrings.phone,
                  child: TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [UzPhoneInputFormatter()],
                    validator: Validators.phone,
                    decoration: InputDecoration(
                      hintText: AppStrings.phoneHint,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🇺🇿', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '+998',
                              style: AppTextStyles.bodyStrong.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                LabeledField(
                  label: AppStrings.password,
                  child: TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    obscuringCharacter: '•',
                    textInputAction: TextInputAction.next,
                    validator: Validators.password,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
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
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                LabeledField(
                  label: AppStrings.confirmPassword,
                  child: TextFormField(
                    controller: _confirm,
                    obscureText: _obscure,
                    obscuringCharacter: '•',
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _register(),
                    validator: (v) => v != _password.text
                        ? AppStrings.passwordMismatch
                        : null,
                    decoration: const InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: Icon(Icons.lock_outline, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: AppStrings.registerTitle,
                  loading: _isLoading,
                  onPressed: _isLoading ? null : _register,
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '${AppStrings.haveAccount} ',
                        style: AppTextStyles.body.copyWith(color: secondary),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Text(
                          AppStrings.login,
                          style: AppTextStyles.bodyStrong.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
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
