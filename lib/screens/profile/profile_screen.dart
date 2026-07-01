import 'package:flutter/material.dart';

import '../../backend/repositories/auth_repository.dart';
import '../../backend/repositories/profile_repository.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_controller.dart';
import '../../data/mock_data.dart';
import '../../models/user_profile.dart';
import '../../widgets/brand_wordmark.dart';
import '../../widgets/circle_icon_button.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../animals/my_animals_screen.dart';
import '../common/coming_soon_screen.dart';
import '../farm/farm_management_screen.dart';
import '../help/help_center_screen.dart';
import '../orders/orders_screen.dart';
import 'card_binding_screen.dart';
import 'edit_profile_screen.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_menu_tile.dart';
import 'widgets/profile_stat_card.dart';

/// Profil ekrani — ma'lumot repository'dan yuklanadi, tahrirlash bilan.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile> _future = ProfileRepository().fetchCurrentProfile();

  void _reload() =>
      setState(() => _future = ProfileRepository().fetchCurrentProfile());

  Future<void> _edit(UserProfile current) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => EditProfileScreen(profile: current),
      ),
    );
    if (!mounted) return;
    if (saved == true) _reload();
  }

  void _onMenu(String label) {
    if (label == AppStrings.aiAssistant) {
      Navigator.of(context).pushNamed(AppRoutes.ai);
    } else if (label == AppStrings.settings) {
      Navigator.of(context).pushNamed(AppRoutes.settings);
    } else if (label == AppStrings.orders) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const OrdersScreen()));
    } else if (label == AppStrings.myAnimals) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const MyAnimalsScreen()));
    } else if (label == AppStrings.farmManagement) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const FarmManagementScreen()),
      );
    } else if (label == AppStrings.helpCenter) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const HelpCenterScreen()));
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => ComingSoonScreen(title: label)),
      );
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.logout, style: AppTextStyles.h3),
        content: Text(AppStrings.logoutConfirm, style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              AppStrings.logout,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await AuthRepository().signOut();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  Widget _buildGuestView(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandWordmark(),
              const Spacer(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_circle_outlined,
                        size: 72,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      "Tizimga kiring",
                      style: AppTextStyles.h1.copyWith(color: titleColor),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      "Chorva mollaringizni boshqarish, buyurtmalar tarixi va shaxsiy tavsiyalardan foydalanish uchun tizimga kiring.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(color: secondary),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    PrimaryButton(
                      label: "Kirish yoki Ro'yxatdan o'tish",
                      onPressed: () async {
                        final ok = await Navigator.of(context).pushNamed(AppRoutes.login);
                        if (ok == true) {
                          _reload();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final menu = MockData.profileMenu;

    if (!AuthRepository().isLoggedIn) {
      return _buildGuestView(context);
    }

    return SafeArea(
      bottom: false,
      child: FutureBuilder<UserProfile>(
        future: _future,
        builder: (context, snap) {
          final user = snap.data ?? MockData.user;
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.sm,
              AppSpacing.screenH,
              AppSpacing.xxl,
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BrandWordmark(),
                  Row(
                    children: [
                      CircleIconButton(
                        icon: Icons.edit_outlined,
                        onTap: () => _edit(user),
                      ),
                      const SizedBox(width: 10),
                      CircleIconButton(
                        icon: theme.isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        onTap: theme.toggle,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileHeaderCard(user: user),
              if (!user.isPro) ...[
                const SizedBox(height: AppSpacing.md),
                _PremiumPromoBanner(
                  onTap: () => _showPaywall(context),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProfileStatCard(
                      value: '${user.animals}',
                      label: AppStrings.statAnimals,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    ProfileStatCard(
                      value: '${user.orders}',
                      label: AppStrings.statOrders,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    ProfileStatCard(
                      value: user.rating.toStringAsFixed(1),
                      label: AppStrings.statRating,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < menu.length; i++) ...[
                      if (i != 0)
                        Divider(
                          height: 1,
                          indent: AppSpacing.lg + 38 + AppSpacing.md,
                          color: Theme.of(context).dividerColor,
                        ),
                      ProfileMenuTile(
                        item: menu[i],
                        onTap: () => _onMenu(menu[i].label),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SecondaryButton(
                label: AppStrings.logout,
                leadingIcon: Icons.logout,
                foreground: AppColors.danger,
                borderColor: AppColors.danger.withValues(alpha: 0.4),
                onPressed: _logout,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Obuna paywall bottom sheeti.
  void _showPaywall(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => _PaywallSheet(
        onUpgrade: () async {
          Navigator.pop(ctx); // paywallni yopish
          final ok = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CardBindingScreen()),
          );
          if (ok == true) _reload();
        },
      ),
    );
  }
}

/// Premium promo banner
class _PremiumPromoBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _PremiumPromoBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.amber, AppColors.accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.amber.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "VetUz Premium-ga o'ting",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Cheksiz AI va maxsus chegirmalar",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Paywall tanlov oynasi
class _PaywallSheet extends StatefulWidget {
  final VoidCallback onUpgrade;
  const _PaywallSheet({required this.onUpgrade});

  @override
  State<_PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends State<_PaywallSheet> {
  int _selectedPlan = 1; // 0: oylik, 1: yillik

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              "VetUz Premium-ga obuna bo'lish",
              style: AppTextStyles.h2.copyWith(color: titleColor),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Ilovadan to'liq va cheksiz foydalanish imkoniyati",
              style: AppTextStyles.body.copyWith(color: secondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Afzalliklar ro'yxati
            _BenefitRow(
              icon: Icons.psychology_outlined,
              title: "Cheksiz VetAI maslahatlari",
              desc: "Tashxislar va tavsiyalar cheklovlarsiz",
            ),
            const SizedBox(height: AppSpacing.md),
            _BenefitRow(
              icon: Icons.percent_outlined,
              title: "Veterinarlar ko'rigiga chegirma",
              desc: "Har bir chaqiruvda 10% gacha keshbek",
            ),
            const SizedBox(height: AppSpacing.md),
            _BenefitRow(
              icon: Icons.analytics_outlined,
              title: "Smart Ferma tahlillari",
              desc: "Mollarning og'irlik grafiklari va hisobotlar",
            ),
            const SizedBox(height: AppSpacing.xl),

            // Planlar
            _PlanCard(
              title: "Oylik obuna",
              price: "29,000 so'm / oy",
              active: _selectedPlan == 0,
              onTap: () => setState(() => _selectedPlan = 0),
            ),
            const SizedBox(height: AppSpacing.md),
            _PlanCard(
              title: "Yillik obuna",
              price: "249,000 so'm / yil",
              badge: "TEJAMKOR -30%",
              active: _selectedPlan == 1,
              onTap: () => setState(() => _selectedPlan = 1),
            ),
            const SizedBox(height: AppSpacing.xl),

            PrimaryButton(
              label: "Premium-ga o'tish",
              onPressed: widget.onUpgrade,
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.amber.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: AppColors.amber, size: 16),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.title.copyWith(color: titleColor),
              ),
              Text(
                desc,
                style: AppTextStyles.caption.copyWith(color: secondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String? badge;
  final bool active;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.active,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.08)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: active ? AppColors.primary : Theme.of(context).dividerColor,
            width: active ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              active ? Icons.radio_button_checked : Icons.radio_button_off,
              color: active ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.title.copyWith(color: titleColor),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.amber,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Text(
                            "TEJAMKOR -30%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(price, style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
