import 'package:flutter/material.dart';

import '../../../backend/repositories/profile_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_profile.dart';
import '../../widgets/primary_button.dart';
import '../auth/widgets/labeled_field.dart';

/// Profil tahrirlash — ism, rol, shahar (saqlanadi).
class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(
    text: widget.profile.fullName,
  );
  late final TextEditingController _city = TextEditingController(
    text: widget.profile.city,
  );
  late String _role = widget.profile.role;
  bool _saving = false;

  static const List<String> _roles = [
    'Chorvador',
    'Uy hayvoni egasi',
    'Fermer',
    'Veterinar',
    'Foydalanuvchi',
  ];

  @override
  void dispose() {
    _name.dispose();
    _city.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final updated = widget.profile.copyWith(
      fullName: _name.text.trim(),
      role: _role,
      city: _city.text.trim(),
    );
    await ProfileRepository().updateProfile(updated);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilni tahrirlash', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledField(
                  label: "To'liq ism",
                  child: TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Ismingizni kiriting'
                        : null,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                LabeledField(
                  label: 'Rol',
                  child: DropdownButtonFormField<String>(
                    initialValue: _roles.contains(_role) ? _role : _roles.last,
                    items: [
                      for (final r in _roles)
                        DropdownMenuItem(value: r, child: Text(r)),
                    ],
                    onChanged: (v) => setState(() => _role = v ?? _role),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                LabeledField(
                  label: 'Shahar',
                  child: TextFormField(
                    controller: _city,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_city_outlined, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Saqlash',
                  loading: _saving,
                  trailingIcon: Icons.check,
                  background: AppColors.primary,
                  onPressed: _saving ? null : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
