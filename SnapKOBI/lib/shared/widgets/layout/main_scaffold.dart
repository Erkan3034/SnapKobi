import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../features/discover/discover_screen.dart';
import '../../../features/history/history_screen.dart';
import '../../../features/library/library_screen.dart';
import '../../../features/settings/settings_screen.dart';
import '../../../features/create/create_screen.dart';
import 'create_fab_button.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final _screens = const [
    DiscoverScreen(),
    HistoryScreen(),
    SizedBox.shrink(), // placeholder for FAB
    LibraryScreen(),
    SettingsScreen(),
  ];

  void _onTabTap(int idx) {
    if (idx == 2) return; // center FAB slot — handled separately
    setState(() => _selectedIndex = idx);
  }

  void _openCreate() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: CreateFabButton(onTap: _openCreate),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.white,
        elevation: 12,
        child: SizedBox(
          height: 60,
          child: Row(children: [
            _navItem(AppIcons.home, AppIcons.homeFilled, 'Ana Sayfa', 0),
            _navItem(AppIcons.history, AppIcons.history, 'Projelerim', 1),
            const SizedBox(width: 64), // FAB space
            _navItem(AppIcons.gallery, AppIcons.galleryFilled, 'Kütüphane', 3),
            _navItem(AppIcons.person, AppIcons.personFilled, 'Profil', 4),
          ]),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, IconData activeIcon, String label, int idx) {
    final isActive = _selectedIndex == idx;
    return Expanded(
      child: InkWell(
        onTap: () => _onTabTap(idx),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(isActive ? activeIcon : icon,
            color: isActive ? AppColors.primary : AppColors.textHint, size: 22),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(
            fontSize: 10, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? AppColors.primary : AppColors.textHint,
          )),
        ]),
      ),
    );
  }
}
