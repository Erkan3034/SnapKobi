// Arka plan teması seçici (studio/outdoor vb.).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/image/app_network_image.dart';
import '../../discover/discover_provider.dart';

class BackgroundThemeSelector extends ConsumerWidget {
  final String selectedTheme;
  final ValueChanged<String> onThemeSelected;

  const BackgroundThemeSelector({super.key, required this.selectedTheme, required this.onThemeSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Temalar DB'den (background_themes); yuklenirken/bos ise provider yedegi kullanir.
    final themes = ref.watch(backgroundThemesProvider).valueOrNull ?? const [];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        child: Text('Arka Plan Teması', style: AppTypography.headlineMedium.copyWith(fontSize: 16, color: theme.textTheme.titleLarge?.color ?? theme.colorScheme.onSurface)),
      ),
      const SizedBox(height: AppDimensions.spacing12),
      SizedBox(
        height: 100,
        child: themes.isEmpty
            ? const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)))
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                itemCount: themes.length,
                itemBuilder: (_, i) => _buildThemeItem(theme, themes[i].id, themes[i].label, themes[i].imageUrl),
              ),
      ),
    ]);
  }

  Widget _buildThemeItem(ThemeData theme, String id, String label, String imgUrl) {
    final isSelected = selectedTheme == id;
    return GestureDetector(
      onTap: () => onThemeSelected(id),
      child: Padding(
        padding: const EdgeInsets.only(right: AppDimensions.spacing12),
        child: Column(children: [
          Container(
            width: 68, height: 68, padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.transparent, width: 2.5),
            ),
            child: AppNetworkImage(url: imgUrl, width: double.infinity, height: double.infinity, borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(height: AppDimensions.spacing4),
          Text(label, style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : theme.hintColor, fontSize: 10)),
        ]),
      ),
    );
  }
}
