import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../../backend/repositories/vet_repository.dart';
import '../../models/veterinarian.dart';
import '../../widgets/async_view.dart';
import '../../widgets/vet_card.dart';
import 'vet_detail_screen.dart';

/// Veterinarlar ro'yxati — repository orqali yuklaydi, ixtiyoriy filtr bilan.
class VetListScreen extends StatefulWidget {
  final String title;
  final bool Function(Veterinarian vet)? filter;

  const VetListScreen({super.key, required this.title, this.filter});

  @override
  State<VetListScreen> createState() => _VetListScreenState();
}

class _VetListScreenState extends State<VetListScreen> {
  late Future<List<Veterinarian>> _future = VetRepository().fetchVets();

  void _reload() => setState(() => _future = VetRepository().fetchVets());

  List<Veterinarian> _apply(List<Veterinarian> all) =>
      widget.filter == null ? all : all.where(widget.filter!).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title, style: AppTextStyles.h3)),
      body: AsyncView<List<Veterinarian>>(
        future: _future,
        onRetry: _reload,
        isEmpty: (all) => _apply(all).isEmpty,
        emptyMessage: 'Veterinar topilmadi',
        builder: (context, all) {
          final vets = _apply(all);
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            itemCount: vets.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) => VetCard(
              vet: vets[i],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => VetDetailScreen(vet: vets[i]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
