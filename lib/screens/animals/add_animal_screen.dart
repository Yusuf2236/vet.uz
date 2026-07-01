import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/animal.dart';
import '../../widgets/primary_button.dart';
import '../auth/widgets/labeled_field.dart';

/// Yangi hayvon qo'shish formasi. Saqlanganda `Animal` qaytaradi.
class AddAnimalScreen extends StatefulWidget {
  const AddAnimalScreen({super.key});

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _breed = TextEditingController();
  final _age = TextEditingController();
  String _type = _types.first;

  static const List<String> _types = [
    'Qoramol',
    "Qo'y-echki",
    'It',
    'Mushuk',
    'Parranda',
    'Ot',
  ];

  @override
  void dispose() {
    _name.dispose();
    _breed.dispose();
    _age.dispose();
    super.dispose();
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'It':
      case 'Mushuk':
        return Icons.pets_outlined;
      case 'Parranda':
        return Icons.egg_outlined;
      default:
        return Icons.agriculture_outlined;
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final animal = Animal(
      name: _name.text.trim(),
      type: _type,
      breed: _breed.text.trim().isEmpty ? '—' : _breed.text.trim(),
      age: _age.text.trim().isEmpty ? '—' : _age.text.trim(),
      health: "Sog'lom",
      icon: _iconFor(_type),
    );
    Navigator.of(context).pop(animal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hayvon qo'shish", style: AppTextStyles.h3),
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
                  label: 'Nomi',
                  child: TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nomini kiriting'
                        : null,
                    decoration: const InputDecoration(
                      hintText: 'Masalan: Zebo',
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                LabeledField(
                  label: 'Turi',
                  child: DropdownButtonFormField<String>(
                    initialValue: _type,
                    items: [
                      for (final t in _types)
                        DropdownMenuItem(value: t, child: Text(t)),
                    ],
                    onChanged: (v) => setState(() => _type = v ?? _type),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                LabeledField(
                  label: 'Nasli',
                  child: TextFormField(
                    controller: _breed,
                    decoration: const InputDecoration(
                      hintText: 'Masalan: Golshtin',
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                LabeledField(
                  label: 'Yoshi',
                  child: TextFormField(
                    controller: _age,
                    decoration: const InputDecoration(
                      hintText: 'Masalan: 3 yosh',
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Saqlash',
                  trailingIcon: Icons.check,
                  background: AppColors.primary,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
