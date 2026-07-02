import 'package:flutter/material.dart';

import '../../../backend/repositories/auth_repository.dart';
import '../../../backend/repositories/profile_repository.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_controller.dart';
import '../../data/mock_data.dart';
import '../../models/profile_menu_item.dart';
import '../../models/user_profile.dart';
import '../../widgets/brand_wordmark.dart';
import '../../widgets/circle_icon_button.dart';
import '../../widgets/primary_button.dart';
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

  void _reload() {
    setState(() {
      _future = ProfileRepository().fetchCurrentProfile();
    });
  }

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

  void _showRatingInfo(BuildContext context, double rating) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Row(
          children: [
            const Icon(Icons.star_rounded, color: AppColors.amber, size: 28),
            const SizedBox(width: AppSpacing.sm),
            Text("Reyting tizimi", style: AppTextStyles.h3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sizning joriy reytingingiz: $rating",
              style: AppTextStyles.bodyStrong,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "Ushbu ko'rsatkich sizning platformadagi faolligingiz, veterinarlar bilan bo'lgan muloqotlaringiz va buyurtmalaringiz asosida avtomatik hisoblab chiqiladi.",
              style: AppTextStyles.body.copyWith(
                color: Theme.of(ctx).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Tushunarli", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final menu = MockData.profileMenu;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                const SizedBox(height: AppSpacing.md + 4),
                _PremiumPromoBanner(
                  onTap: () => _showPaywall(context),
                ),
              ],
              const SizedBox(height: AppSpacing.lg + 2),
              Row(
                children: [
                  Expanded(
                    child: ProfileStatCard(
                      value: '${user.animals}',
                      label: AppStrings.statAnimals,
                      icon: Icons.agriculture_rounded,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => const MyAnimalsScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ProfileStatCard(
                      value: '${user.orders}',
                      label: AppStrings.statOrders,
                      icon: Icons.shopping_bag_rounded,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => const OrdersScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ProfileStatCard(
                      value: user.rating.toStringAsFixed(1),
                      label: AppStrings.statRating,
                      icon: Icons.star_rounded,
                      onTap: () => _showRatingInfo(context, user.rating),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg + 4),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: Theme.of(context).dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < menu.length; i++) ...[
                      if (i != 0)
                        Divider(
                          height: 1,
                          indent: AppSpacing.lg + 40 + AppSpacing.md,
                          color: Theme.of(context).dividerColor,
                        ),
                      ProfileMenuTile(
                        item: menu[i],
                        onTap: () => _onMenu(menu[i].label),
                      ),
                    ],
                    Divider(
                      height: 1,
                      indent: AppSpacing.lg + 40 + AppSpacing.md,
                      color: Theme.of(context).dividerColor,
                    ),
                    ProfileMenuTile(
                      item: const ProfileMenuItem(
                        label: AppStrings.logout,
                        subtitle: 'Hisobdan xavfsiz chiqish',
                        icon: Icons.logout_rounded,
                        color: AppColors.danger,
                        tint: AppColors.redTint,
                      ),
                      onTap: _logout,
                    ),
                  ],
                ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1B2321), const Color(0xFF0F1513)]
                : [const Color(0xFFE6F4EE), const Color(0xFFD3EBE1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.amber.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.amber.withValues(alpha: isDark ? 0.15 : 0.08),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA000), AppColors.amber],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.amber.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: AppSpacing.md + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "VetUz Premium-ga o'ting",
                    style: AppTextStyles.title.copyWith(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Cheksiz AI yordami va veterinarlar uchun maxsus chegirmalar",
                    style: AppTextStyles.caption.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.amber.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_right, color: AppColors.amber, size: 20),
            ),
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
                          child: Text(
                            badge!,
                            style: const TextStyle(
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
