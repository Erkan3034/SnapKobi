import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import '../create/create_screen.dart';
import 'library_provider.dart';

class TemplateDetailScreen extends StatelessWidget {
  final LibraryTemplate template;
  const TemplateDetailScreen({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeGreen = theme.brightness == Brightness.dark ? const Color(0xFF10B981) : AppColors.success;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => context.pop(),
        ),
        title: Text(template.title, style: AppTypography.headlineMedium.copyWith(fontSize: 18, color: theme.textTheme.headlineMedium?.color)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 8))],
              image: DecorationImage(image: NetworkImage(template.imageUrl), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing20),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
              child: Text(template.category.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: activeGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
              child: Text('${template.usageCount} kullanım', style: AppTypography.labelSmall.copyWith(color: activeGreen, fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing16),
          Text('Açıklama', style: AppTypography.titleLarge.copyWith(fontSize: 16, color: theme.textTheme.titleLarge?.color)),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            '${template.title} şablonu, ürün görsellerinizi yapay zeka gücüyle profesyonel bir stüdyo ortamına taşır. Minimalist gölgeler, kusursuz ışıklandırma ve KOBİ\'nizin marka diline uygun derinlik efektleri içerir. Bu şablon Trendyol, Instagram ve WhatsApp ürün tanıtımları için optimize edilmiştir.',
            style: AppTypography.bodyMedium.copyWith(color: theme.textTheme.bodyMedium?.color ?? theme.hintColor, height: 1.4),
          ),
          const SizedBox(height: AppDimensions.spacing32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: AppColors.white,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
            ),
            onPressed: () {
              context.pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateScreen()));
            },
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Bu Şablonu Kullan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ]),
      ),
    );
  }
}
