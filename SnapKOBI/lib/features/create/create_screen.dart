// Yeni üretim ekranı: foto seç → platform/tema seç → Üret. Orta FAB ile açılır. Rota: /create
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/navigation/routes.dart';
import '../home/widgets/action_buttons.dart';
import '../home/widgets/credit_counter.dart';
import '../home/widgets/image_upload_zone.dart';
import '../home/widgets/platform_selection_sheet.dart';
import '../home/widgets/submit_button.dart';
import 'create_provider.dart';
import 'widgets/background_theme_selector.dart';
import 'widgets/platform_chip_button.dart';
import 'widgets/template_feed_widget.dart';


class CreateScreen extends ConsumerStatefulWidget {
  final String? initialTemplateId;
  const CreateScreen({super.key, this.initialTemplateId});

  @override
  ConsumerState<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen> {
  @override
  void initState() {
    super.initState();
    final tid = widget.initialTemplateId;
    if (tid != null && tid.isNotEmpty) {
      // Library'den "Bu Şablonu Kullan" ile gelindiyse şablonu önceden seç.
      Future.microtask(() => ref.read(createProvider.notifier).setTemplateId(tid));
    }
  }

  Future<void> _pickImage(WidgetRef ref, ImageSource src) async {
    final img = await ImagePicker().pickImage(source: src);
    if (img != null) ref.read(createProvider.notifier).setImagePath(img.path);
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final state = ref.watch(createProvider);
    final hasImg = state.selectedImagePath != null;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor, surfaceTintColor: Colors.transparent,
        leading: IconButton(icon: Icon(AppIcons.close, color: theme.iconTheme.color), onPressed: () => context.pop()),
        title: Text('Yeni Üretim ✨', style: AppTypography.headlineMedium.copyWith(fontSize: 18, color: theme.textTheme.headlineMedium?.color)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const UsageBanner(),
          const SizedBox(height: AppDimensions.spacing20),
          ImageUploadZone(imagePath: state.selectedImagePath,
            onClear: () => ref.read(createProvider.notifier).setImagePath(null),
            onTap: () => _pickImage(ref, ImageSource.gallery)),
          if (!hasImg) ...[
            const SizedBox(height: AppDimensions.spacing16),
            QuickActionButtons(onCameraTap: () => _pickImage(ref, ImageSource.camera), onGalleryTap: () => _pickImage(ref, ImageSource.gallery)),
          ],
          const SizedBox(height: AppDimensions.spacing20),
          PlatformChipButton(selectedPlatform: state.selectedPlatform,
            onTap: () => PlatformSelectionSheet.show(context, current: state.selectedPlatform, onConfirm: ref.read(createProvider.notifier).setPlatform)),
          if (hasImg) ...[
            const SizedBox(height: AppDimensions.spacing20),
            BackgroundThemeSelector(selectedTheme: state.selectedBackgroundTheme, onThemeSelected: ref.read(createProvider.notifier).setBackgroundTheme),
            const SizedBox(height: AppDimensions.spacing20),
            const TemplateFeedWidget(),
          ],
          const SizedBox(height: AppDimensions.spacing32),
          SubmitButton(isEnabled: hasImg, onTap: () => context.push(AppRoutes.processing)),
        ]),
      ),
    );
  }
}
