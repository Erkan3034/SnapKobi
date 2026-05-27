import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_typography.dart';
import 'library_provider.dart';
import 'widgets/library_category_selector.dart';
import 'widgets/library_helpers.dart';
import 'widgets/template_grid_card.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryProvider);
    final filtered = state.selectedCategory == 'all'
        ? state.templates
        : state.templates.where((t) => t.category == state.selectedCategory).toList();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                onPressed: () => context.pop(),
              )
            : null,
        title: Text('Kütüphane', style: AppTypography.headlineMedium.copyWith(fontSize: 20, color: theme.textTheme.headlineMedium?.color)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(AppIcons.filter, color: theme.iconTheme.color ?? theme.colorScheme.onSurface),
            onPressed: () => showLibraryFilterSheet(context),
          )
        ],
      ),
      body: Column(children: [
        const LibraryCategorySelector(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppDimensions.spacing12,
              mainAxisSpacing: AppDimensions.spacing12,
              childAspectRatio: 0.82,
            ),
            itemCount: filtered.length,
            itemBuilder: (_, i) => TemplateGridCard(template: filtered[i]),
          ),
        ),
      ]),
    );
  }
}
