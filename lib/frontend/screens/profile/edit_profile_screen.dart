import 'dart:io';

import 'package:flutter/material.dart';

import '../../../backend/repositories/profile_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/text_utils.dart';
import '../../models/user_profile.dart';
import '../../widgets/primary_button.dart';
import '../auth/widgets/labeled_field.dart';

/// Profil tahrirlash — ism, rol, shahar, avatar (saqlanadi).
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
  late String? _avatarUrl = widget.profile.avatarUrl;
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
      avatarUrl: _avatarUrl,
    );
    await ProfileRepository().updateProfile(updated);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  void _changeAvatar() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Profil rasmini tanlang",
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                "Tizimdagi tayyor rasmlardan foydalaning yoki yangi rasm yuklang.",
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Tayyor rasmlar ro'yxati
              SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _AvatarOption(
                      imageUrl: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80",
                      onTap: () {
                        setState(() => _avatarUrl = "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80");
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _AvatarOption(
                      imageUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80",
                      onTap: () {
                        setState(() => _avatarUrl = "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80");
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _AvatarOption(
                      imageUrl: "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=150&q=80",
                      onTap: () {
                        setState(() => _avatarUrl = "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=150&q=80");
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _AvatarOption(
                      imageUrl: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80",
                      onTap: () {
                        setState(() => _avatarUrl = "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80");
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Custom upload harakatlar
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                ),
                title: const Text("Galereyadan tanlash", style: AppTextStyles.bodyStrong),
                onTap: () => _simulateUpload(context, "Galereya"),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                ),
                title: const Text("Kamera orqali tushirish", style: AppTextStyles.bodyStrong),
                onTap: () => _simulateUpload(context, "Kamera"),
              ),
              if (_avatarUrl != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  title: Text("Rasmga olib tashlash", style: AppTextStyles.bodyStrong.copyWith(color: Colors.red)),
                  onTap: () {
                    setState(() => _avatarUrl = null);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _simulateUpload(BuildContext sheetContext, String source) {
    Navigator.pop(sheetContext); // Close sheet
    
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _UploadSimulationDialog(
          source: source,
          onComplete: (mockPath) {
            setState(() => _avatarUrl = mockPath);
          },
        );
      },
    );
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
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                              ? (_avatarUrl!.startsWith('http')
                                  ? Image.network(
                                      _avatarUrl!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(_avatarUrl!),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ))
                              : Container(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  alignment: Alignment.center,
                                  child: Text(
                                    TextUtils.initials(_name.text.isEmpty ? widget.profile.fullName : _name.text),
                                    style: AppTextStyles.h1.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 32,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _changeAvatar,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
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

class _AvatarOption extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const _AvatarOption({
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 2),
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _UploadSimulationDialog extends StatefulWidget {
  final String source;
  final ValueChanged<String> onComplete;

  const _UploadSimulationDialog({
    required this.source,
    required this.onComplete,
  });

  @override
  State<_UploadSimulationDialog> createState() => _UploadSimulationDialogState();
}

class _UploadSimulationDialogState extends State<_UploadSimulationDialog> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  Future<void> _startSimulation() async {
    for (int i = 1; i <= 10; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      setState(() {
        _progress = i / 10.0;
      });
    }
    // Tanlangan rasm
    final mockImages = [
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80",
      "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=150&q=80",
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80",
      "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=150&q=80",
    ];
    final chosen = mockImages[DateTime.now().millisecond % mockImages.length];
    widget.onComplete(chosen);
    if (!mounted) return;
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profil rasmi muvaffaqiyatli yuklandi!"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: _progress,
                strokeWidth: 4.5,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              "${widget.source} orqali rasm yuklanmoqda...",
              style: AppTextStyles.bodyStrong,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "${(_progress * 100).toInt()}% bajarildi",
              style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
