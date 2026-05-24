import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import 'processing_provider.dart';
import 'widgets/processing_footer.dart';
import 'widgets/processing_header.dart';
import 'widgets/processing_progress_ring.dart';
import 'widgets/processing_steps_card.dart';

class ProcessingScreen extends ConsumerStatefulWidget {
  const ProcessingScreen({super.key});
  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(processingProvider.notifier).simulateProgress());
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => Navigator.of(context).pop(),
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
