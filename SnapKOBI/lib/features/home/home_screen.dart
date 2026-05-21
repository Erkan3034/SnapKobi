import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import '../../core/di/providers.dart';
import 'home_provider.dart';
import 'widgets/action_buttons.dart';
import 'widgets/credit_counter.dart';
import 'widgets/image_upload_zone.dart';
import 'widgets/platform_selector.dart';
import 'widgets/scene_selector.dart';
import 'widgets/submit_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _pickImage(WidgetRef ref, ImageSource src) async {
    final img = await ImagePicker().pickImage(source: src);
    if (img != null) ref.read(homeProvider.notifier).setImagePath(img.path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final initials = (user?.displayName?.isNotEmpty ?? false) ? user!.displayName![0].toUpperCase() : 'MY';
    final hasImg = homeState.selectedImagePath != null;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('SnapKOBİ', style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark, fontSize: 20)),
            const SizedBox(width: 4),
            const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primaryDark),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacing16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UsageBanner(),
            const SizedBox(height: AppDimensions.spacing20),
            ImageUploadZone(
              imagePath: homeState.selectedImagePath,
              onClear: () => ref.read(homeProvider.notifier).setImagePath(null),
              onTap: () => _pickImage(ref, ImageSource.gallery),
            ),
            if (!hasImg) ...[
              const SizedBox(height: AppDimensions.spacing16),
              QuickActionButtons(
                onCameraTap: () => _pickImage(ref, ImageSource.camera),
                onGalleryTap: () => _pickImage(ref, ImageSource.gallery),
              ),
            ],
            const SizedBox(height: AppDimensions.spacing20),
            PlatformSelector(
              selectedPlatform: homeState.selectedPlatform,
              onPlatformSelected: ref.read(homeProvider.notifier).setPlatform,
            ),
            if (hasImg) ...[
              const SizedBox(height: AppDimensions.spacing20),
              SceneSelector(
                selectedTheme: homeState.selectedBackgroundTheme,
                onThemeSelected: ref.read(homeProvider.notifier).setBackgroundTheme,
              ),
            ],
            const SizedBox(height: AppDimensions.spacing32),
            SubmitButton(isEnabled: hasImg, onTap: () {}),
          ],
        ),
      ),
    );
  }
}
