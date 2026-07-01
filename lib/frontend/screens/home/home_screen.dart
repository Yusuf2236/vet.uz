import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/mock_data.dart';
import '../../../backend/repositories/vet_repository.dart';
import '../../../backend/repositories/profile_repository.dart';
import '../../models/category_item.dart';
import '../../models/veterinarian.dart';
import '../../models/user_profile.dart';
import '../../widgets/ai_assistant_banner.dart';
import '../../widgets/emergency_banner.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/farm_status_card.dart';
import '../../widgets/promo_banner.dart';
import '../../widgets/search_field.dart';
import '../../widgets/section_header.dart';
import '../../widgets/vet_card.dart';
import '../clinic/clinic_list_screen.dart';
import '../farm/farm_management_screen.dart';
import '../market/category_products_screen.dart';
import '../more/more_services_screen.dart';
import '../promo/promo_screen.dart';
import '../vet/vet_detail_screen.dart';
import '../vet/vet_list_screen.dart';
import 'widgets/category_grid.dart';
import 'widgets/greeting_header.dart';
import 'widgets/home_app_header.dart';

/// Asosiy ekran. [onNavigate] orqali boshqa bo'limlarga (tab) o'tiladi.
class HomeScreen extends StatefulWidget {
  final ValueChanged<int> onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Stream<List<Veterinarian>> _vetsStream = VetRepository()
      .watchVets();

  void _openVet(Veterinarian vet) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => VetDetailScreen(vet: vet)));
  }

  void _push(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  void _onCategory(CategoryItem item) {
    switch (item.label) {
      case 'Veterinar':
        _push(const VetListScreen(title: 'Veterinarlar'));
      case 'Klinika':
        _push(const ClinicListScreen());
      case 'Chorva':
        _push(
          VetListScreen(
            title: 'Chorva mutaxassislari',
            filter: (v) => v.animalType.contains('Sigir'),
          ),
        );
      case 'Dorixona':
        _push(
          const CategoryProductsScreen(
            title: 'Dorixona',
            allowed: {'Dorilar', 'Vitaminlar'},
          ),
        );
      case 'Pet Shop':
        _push(
          const CategoryProductsScreen(
            title: 'Pet Shop',
            allowed: {'Oziq-ovqat', 'Jihozlar'},
          ),
        );
      case 'Market':
        widget.onNavigate(3);
      case 'AI':
        Navigator.of(context).pushNamed(AppRoutes.ai);
      default:
        _push(const MoreServicesScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: AppSpacing.xl);

    return FutureBuilder<UserProfile>(
      future: ProfileRepository().fetchCurrentProfile(),
      builder: (context, snapshot) {
        final user = snapshot.data ?? MockData.user;
        return SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenH,
                  AppSpacing.sm,
                  AppSpacing.screenH,
                  AppSpacing.md,
                ),
                child: HomeAppHeader(
                  notificationBadge: '2',
                  onNotifications: () =>
                      Navigator.of(context).pushNamed(AppRoutes.notifications),
                ),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenH,
                    AppSpacing.lg,
                    AppSpacing.screenH,
                    AppSpacing.xxl,
                  ),
                  children: [
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 50),
                      child: GreetingHeader(
                        user: user,
                        onAvatarTap: () => widget.onNavigate(4),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 100),
                      child: SearchField(
                        hint: AppStrings.searchHint,
                        readOnly: true,
                        onTap: () => widget.onNavigate(1),
                      ),
                    ),
                    gap,
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 150),
                      child: EmergencyBanner(
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoutes.emergency),
                      ),
                    ),
                    gap,
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 200),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SectionHeader(
                            title: AppStrings.categories,
                            actionLabel: AppStrings.all,
                            onAction: () => widget.onNavigate(1),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          CategoryGrid(items: MockData.categories, onTap: _onCategory),
                        ],
                      ),
                    ),
                    gap,
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 250),
                      child: PromoBanner(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const PromoScreen(),
                          ),
                        ),
                      ),
                    ),
                    gap,
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 300),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SectionHeader(
                            title: AppStrings.nearbyVets,
                            actionLabel: AppStrings.onMap,
                            onAction: () => widget.onNavigate(2),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _NearbyVets(stream: _vetsStream, onTapVet: _openVet),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 350),
                      child: FarmStatusCard(
                        stats: MockData.farmStats,
                        onDetails: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const FarmManagementScreen(),
                          ),
                        ),
                      ),
                    ),
                    gap,
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 400),
                      child: AiAssistantBanner(
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.ai),
                      ),
                    ),
                  ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}

/// Yaqin veterinarlar — repository'dan yuklanadi (loading/bo'sh holatli).
class _NearbyVets extends StatelessWidget {
  final Stream<List<Veterinarian>> stream;
  final void Function(Veterinarian vet) onTapVet;

  const _NearbyVets({required this.stream, required this.onTapVet});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Veterinarian>>(
      stream: stream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return const SizedBox(
            height: 80,
            child: Center(child: Text("Veterinarlarni yuklab bo'lmadi")),
          );
        }
        final vets = (snap.data ?? const <Veterinarian>[]).take(3).toList();
        if (vets.isEmpty) return const SizedBox.shrink();
        return Column(
          children: [
            for (final vet in vets) ...[
              VetCard(vet: vet, onTap: () => onTapVet(vet)),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }
}
