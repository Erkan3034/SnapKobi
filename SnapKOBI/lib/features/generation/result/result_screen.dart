import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import 'widgets/result_caption_section.dart';
import 'widgets/result_image_comparison.dart';
import 'widgets/result_share_button.dart';
import 'widgets/result_success_banner.dart';
import 'widgets/result_video_section.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Sonuçlar',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.only(bottom: AppDimensions.spacing48),
        child: Column(
          children: [
            SizedBox(height: AppDimensions.spacing12),
            ResultSuccessBanner(),
            SizedBox(height: AppDimensions.spacing16),
            ResultImageComparison(),
            SizedBox(height: AppDimensions.spacing16),
            ResultVideoSection(),
            SizedBox(height: AppDimensions.spacing16),
            ResultCaptionSection(),
            SizedBox(height: AppDimensions.spacing24),
            ResultShareButton(),
            SizedBox(height: AppDimensions.spacing32),
          ],
        ),
      ),
    );
  }
}
