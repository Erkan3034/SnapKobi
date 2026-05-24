import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
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
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
        title: Text('Dil Seçimi', style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimary)),
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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
            ),
            child: ListTile(
              leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
              title: Text(lang['name']!, style: AppTypography.bodyLarge.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _selectedLangCode = lang['code']!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${lang['name']} dili seçildi!')),
                );
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
