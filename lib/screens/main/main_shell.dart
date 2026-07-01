import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../home/home_screen.dart';
import '../map/map_screen.dart';
import '../market/market_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import 'widgets/app_bottom_nav.dart';

/// Asosiy "qobiq" — pastki navigatsiya va 5 ta bo'limni boshqaradi.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const List<NavDestination> _destinations = [
    NavDestination(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: AppStrings.navHome,
    ),
    NavDestination(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: AppStrings.navSearch,
    ),
    NavDestination(
      icon: Icons.location_on_outlined,
      activeIcon: Icons.location_on,
      label: AppStrings.navMap,
    ),
    NavDestination(
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront,
      label: AppStrings.navMarket,
    ),
    NavDestination(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: AppStrings.navProfile,
    ),
  ];

  late final List<Widget> _screens = [
    HomeScreen(onNavigate: _goTo),
    const SearchScreen(),
    const MapScreen(),
    const MarketScreen(),
    const ProfileScreen(),
  ];

  void _goTo(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: _goTo,
        destinations: _destinations,
      ),
    );
  }
}
