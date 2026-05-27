import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/sector.dart';

class SectorSettingsScreen extends StatefulWidget {
  const SectorSettingsScreen({super.key});

  @override
  State<SectorSettingsScreen> createState() => _SectorSettingsScreenState();
}

class _SectorSettingsScreenState extends State<SectorSettingsScreen> {
  SectorType _selectedSector = SectorType.textile;

  final Map<SectorType, String> _sectorNames = {
    SectorType.food: '🍔 Gıda & Restoran', SectorType.textile: '👕 Tekstil & Giyim',
    SectorType.electronics: '💻 Elektronik & Teknoloji', SectorType.jewelry: '✨ Takı & Aksesuar',
    SectorType.beauty: '💄 Kozmetik & Güzellik', SectorType.furniture: '🛋️ Mobilya & Dekorasyon',
    SectorType.other: '📦 Diğer Sektörler',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.iconTheme.color), onPressed: () => context.pop()),
        title: Text('Sektör Ayarları', style: AppTypography.headlineMedium.copyWith(color: theme.textTheme.headlineMedium?.color)),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppDimensions.spacing16),
            children: _sectorNames.entries.map((e) {
              final isSel = _selectedSector == e.key;
              return Container(
                margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color ?? theme.cardColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(color: isSel ? theme.colorScheme.primary : theme.dividerColor, width: isSel ? 2 : 1),
                ),
                child: ListTile(
                  title: Text(e.value, style: AppTypography.bodyLarge.copyWith(color: theme.textTheme.bodyLarge?.color, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                  trailing: isSel ? Icon(Icons.check_circle, color: theme.colorScheme.primary) : null,
                  onTap: () => setState(() => _selectedSector = e.key),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sektör ayarları güncellendi!')));
              context.pop();
            },
            child: Text('Kaydet', style: AppTypography.labelLarge.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)),
          ),
        ),
      ]),
    );
  }
}
