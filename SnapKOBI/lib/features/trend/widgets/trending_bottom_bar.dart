import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';

class TrendingBottomBar extends StatelessWidget {
  const TrendingBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8, color: theme.colorScheme.surface, elevation: 12,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            _navItem(context, AppIcons.homeFilled, 'Ana Sayfa', true, () => context.pop()),
            _navItem(context, AppIcons.history, 'Geçmiş', false, () => context.pop()),
            const SizedBox(width: 64),
            _navItem(context, AppIcons.gallery, 'Planlar', false, () => context.pop()),
            _navItem(context, AppIcons.person, 'Ayarlar', false, () => context.pop()),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? AppColors.primary : Theme.of(context).hintColor, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(
              fontSize: 10, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppColors.primary : Theme.of(context).hintColor,
            )),
          ],
        ),
      ),
    );
  }
}
