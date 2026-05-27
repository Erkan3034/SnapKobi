import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../shared/navigation/routes.dart';
import '../../create/create_provider.dart';
import 'processing_provider.dart';
import 'widgets/processing_footer.dart';
import 'widgets/processing_header.dart';
import 'widgets/processing_progress_ring.dart';
import 'widgets/processing_steps_card.dart';

import 'widgets/processing_error_dialog.dart';

import '../../../domain/entities/sector.dart';
import '../../../domain/entities/generation.dart';

import '../../../core/errors/app_error.dart';

class ProcessingScreen extends ConsumerStatefulWidget {
  const ProcessingScreen({super.key});
  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final create = ref.read(createProvider);
      final user = ref.read(authNotifierProvider).value;

      final path = create.selectedImagePath;
      final platform = create.selectedPlatform;
      final sector = user?.sector ?? SectorType.other;
      final templateId = create.selectedTemplateId;

      if (path != null) {
        ref.read(processingProvider.notifier).startGeneration(
          localImagePath: path,
          sector: sector,
          platform: platform,
          templateId: templateId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Generation?>>(processingProvider, (previous, next) {
      if (next.hasValue && next.value != null && next.value!.isCompleted) {
        context.go(AppRoutes.results);
      }
      if (next.hasError && !next.isLoading) {
        final err = next.error;
        final errorMsg = err is AppError ? err.message : err.toString();
        showProcessingErrorDialog(context, ref, errorMsg);
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [AppColors.primaryMid, AppColors.primaryLight, AppColors.primaryLightest],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: AppDimensions.spacing16),
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: Container(
                    padding: const EdgeInsets.all(AppDimensions.spacing4),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.whiteOpacity(0.2)),
                    child: const Icon(Icons.close, color: AppColors.white, size: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: const [
                  ProcessingHeader(),
                  SizedBox(height: AppDimensions.spacing32),
                  ProcessingProgressRing(),
                  SizedBox(height: AppDimensions.spacing32),
                  ProcessingStepsCard(),
                  SizedBox(height: AppDimensions.spacing24),
                  ProcessingFooter(),
                  SizedBox(height: AppDimensions.spacing24),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
