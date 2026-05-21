import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/history/history_screen.dart';
import '../../../features/home/home_screen.dart';
import '../../../features/settings/settings_screen.dart';
import '../../../features/subscription/subscription_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const SubscriptionScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryLightest.withOpacity(0.5),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.edit, color: AppColors.primary),
            label: 'Projelerim',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.photo_library, color: AppColors.primary),
            label: 'Kütüphane',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
