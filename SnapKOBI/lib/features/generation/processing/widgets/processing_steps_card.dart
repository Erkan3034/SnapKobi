import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../processing_provider.dart';

const _successGreen = Color(0xFF22C55E);

class ProcessingStepsCard extends ConsumerWidget {
  const ProcessingStepsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = ref.watch(processingProvider).steps;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Column(
        children: steps.map((info) => _StepRow(info: info)).toList(),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final ProcessingStepInfo info;
  const _StepRow({required this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing8),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Text(info.label, style: AppTypography.bodyMedium.copyWith(
              color: info.status == ProcessingStepStatus.pending
                  ? AppColors.textHint : AppColors.textPrimary,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    switch (info.status) {
      case ProcessingStepStatus.completed:
        return const Icon(Icons.check_circle, color: _successGreen, size: 24);
      case ProcessingStepStatus.inProgress:
        return const SizedBox(
          width: 24, height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        );
      case ProcessingStepStatus.pending:
        return Icon(Icons.radio_button_unchecked,
            color: AppColors.indicatorInactive, size: 24);
    }
  }
}
