// Sonuç ekranı: üretilen görsel + video + caption'ı gösterir, paylaş/indir. Rota: /results
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/navigation/routes.dart';
import 'widgets/result_caption_section.dart';
import 'widgets/result_image_comparison.dart';
import 'widgets/result_share_button.dart';
import 'widgets/result_share_sheet.dart';
import 'widgets/result_success_banner.dart';
import 'widgets/result_video_section.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor, surfaceTintColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => context.go(AppRoutes.home)),
        title: Text('Sonuçlar', style: AppTypography.headlineMedium.copyWith(color: theme.colorScheme.onSurface)),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.ios_share, color: theme.colorScheme.onSurface),
          onPressed: () => ResultShareSheet.show(context))],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.only(bottom: AppDimensions.spacing48),
        child: Column(children: [
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
        ]),
      ),
    );
  }
}
