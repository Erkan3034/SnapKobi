import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';
import '../../../features/create/create_screen.dart';
import '../../../features/discover/discover_screen.dart';
import '../../../features/history/history_screen.dart';
import '../../../features/library/library_screen.dart';
import '../../../features/settings/settings_screen.dart';
import 'create_fab_button.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final _screens = const [
    DiscoverScreen(), HistoryScreen(), SizedBox.shrink(), LibraryScreen(), SettingsScreen(),
  ];

  void _onTabTap(int idx) {
    if (idx != 2) setState(() => _selectedIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: CreateFabButton(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateScreen()))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), notchMargin: 8,
        color: theme.bottomAppBarTheme.color ?? theme.colorScheme.surface, elevation: 12,
        child: SizedBox(height: 60, child: Row(children: [
          _navItem(theme, AppIcons.home, AppIcons.homeFilled, 'Ana Sayfa', 0),
          _navItem(theme, AppIcons.history, AppIcons.history, 'Projelerim', 1),
          const SizedBox(width: 64),
          _navItem(theme, AppIcons.gallery, AppIcons.galleryFilled, 'Kütüphane', 3),
          _navItem(theme, AppIcons.person, AppIcons.personFilled, 'Profil', 4),
        ])),
      ),
    );
  }

  Widget _navItem(ThemeData theme, IconData icon, IconData activeIcon, String label, int idx) {
    final isActive = _selectedIndex == idx;
    final color = isActive ? theme.colorScheme.primary : theme.hintColor;
    return Expanded(
      child: InkWell(
        onTap: () => _onTabTap(idx),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(isActive ? activeIcon : icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, color: color)),
        ]),
      ),
    );
  }
}
