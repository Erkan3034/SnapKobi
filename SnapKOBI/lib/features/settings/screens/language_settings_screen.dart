import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLangCode = 'tr';

  final List<Map<String, String>> _langs = [
    {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.iconTheme.color), onPressed: () => context.pop()),
        title: Text('Dil Seçimi', style: AppTypography.headlineMedium.copyWith(color: theme.textTheme.headlineMedium?.color)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        itemCount: _langs.length,
        itemBuilder: (context, index) {
          final lang = _langs[index];
          final isSelected = _selectedLangCode == lang['code'];
          return Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
            decoration: BoxDecoration(
              color: theme.cardTheme.color ?? theme.cardColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: isSelected ? theme.colorScheme.primary : theme.dividerColor, width: isSelected ? 2 : 1),
            ),
            child: ListTile(
              leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
              title: Text(lang['name']!, style: AppTypography.bodyLarge.copyWith(color: theme.textTheme.bodyLarge?.color, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              trailing: isSelected ? Icon(Icons.check_circle, color: theme.colorScheme.primary) : null,
              onTap: () {
                setState(() => _selectedLangCode = lang['code']!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${lang['name']} dili seçildi!')),
                );
                context.pop();
              },
            ),
          );
        },
      ),
    );
  }
}
