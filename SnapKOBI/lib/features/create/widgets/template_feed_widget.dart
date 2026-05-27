import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../domain/entities/platform_type.dart';
import '../create_provider.dart';

final templatesProvider = FutureProvider.family<List<Map<String, dynamic>>, PlatformType>((ref, platform) async {
  try {
    final client = ref.watch(supabaseClientProvider);
    final response = await client
        .from('admin_templates')
        .select('*')
        .eq('is_active', true)
        .order('is_featured', ascending: false)
        .order('sort_order', ascending: true);

    final list = List<Map<String, dynamic>>.from(response);
    return list.where((t) {
      final platforms = List<String>.from(t['applicable_platforms'] ?? []);
      return platforms.isEmpty || platforms.contains(platform.name);
    }).toList();
  } catch (e) {
    // If the table doesn't exist yet or connection fails, return mock fallback templates
    return _getMockTemplates(platform);
  }
});

List<Map<String, dynamic>> _getMockTemplates(PlatformType platform) {
  return [
    {
      'id': 'bahar-koleksiyonu',
      'name': 'Bahar Esintisi 🌸',
      'description': 'Bahar temalı soft pastel renkler ve doğal güneş ışığı',
      'is_featured': true,
      'category': 'fashion',
      'thumbnail_url': 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=200&q=80',
    },
    {
      'id': 'minimalist-luxe',
      'name': 'Luxury Minimal 💎',
      'description': 'Ultra sade mermer yüzey ve profesyonel loş ışıklar',
      'is_featured': false,
      'category': 'beauty',
      'thumbnail_url': 'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=200&q=80',
    },
    {
      'id': 'neon-cyber',
      'name': 'Neon Cyberpunk ⚡',
      'description': 'Dinamik pembe-mavi neon ışıklar ve sokak stili',
      'is_featured': true,
      'category': 'electronics',
      'thumbnail_url': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200&q=80',
    },
  ];
}

class TemplateFeedWidget extends ConsumerWidget {
  const TemplateFeedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createState = ref.watch(createProvider);
    final selectedPlatform = createState.selectedPlatform;
    final selectedTemplateId = createState.selectedTemplateId;
    
    final asyncTemplates = ref.watch(templatesProvider(selectedPlatform));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bu Haftanın Popüler Şablonları',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'İsteğe Bağlı',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        SizedBox(
          height: 120,
          child: asyncTemplates.when(
            loading: () => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (err, _) => const Center(
              child: Text('Şablonlar yüklenemedi'),
            ),
            data: (templates) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
                itemCount: templates.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // "None/Default" option
                    final isSelected = selectedTemplateId == null;
                    return _buildTemplateItem(
                      context: context,
                      ref: ref,
                      isSelected: isSelected,
                      name: 'Varsayılan',
                      isFeatured: false,
                      iconWidget: const Center(
                        child: Text('✨', style: TextStyle(fontSize: 32)),
                      ),
                      onTap: () {
                        ref.read(createProvider.notifier).setTemplateId(null);
                      },
                    );
                  }

                  final template = templates[index - 1];
                  final id = template['id'] as String;
                  final isSelected = selectedTemplateId == id;

                  return _buildTemplateItem(
                    context: context,
                    ref: ref,
                    isSelected: isSelected,
                    name: template['name'] as String,
                    isFeatured: template['is_featured'] as bool? ?? false,
                    imageUrl: template['thumbnail_url'] as String?,
                    onTap: () {
                      ref.read(createProvider.notifier).setTemplateId(id);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateItem({
    required BuildContext context,
    required WidgetRef ref,
    required bool isSelected,
    required String name,
    required bool isFeatured,
    String? imageUrl,
    Widget? iconWidget,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 90,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLightest : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.indicatorInactive.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.all(AppDimensions.spacing8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  child: Container(
                    color: Colors.grey[200],
                    width: double.infinity,
                    child: imageUrl != null
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : (iconWidget ?? const Icon(Icons.palette_outlined)),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 11,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (isFeatured)
                Text(
                  '🔥 Trend',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warning,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
