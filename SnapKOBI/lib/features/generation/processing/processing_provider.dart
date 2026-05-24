import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProcessingStep { analyzingImage, changingBackground, generatingCaption }
enum ProcessingStepStatus { completed, inProgress, pending }

class ProcessingStepInfo {
  final ProcessingStep step;
  final String label;
  final ProcessingStepStatus status;
  const ProcessingStepInfo({required this.step, required this.label, required this.status});
  ProcessingStepInfo copyWith({ProcessingStepStatus? status}) =>
      ProcessingStepInfo(step: step, label: label, status: status ?? this.status);
}

class ProcessingState {
  final List<ProcessingStepInfo> steps;
  final double progress;
  final int estimatedSeconds;
  final String? imagePath;
  const ProcessingState({required this.steps, this.progress = 0.0, this.estimatedSeconds = 45, this.imagePath});
  ProcessingState copyWith({List<ProcessingStepInfo>? steps, double? progress, int? estimatedSeconds, String? imagePath}) =>
      ProcessingState(steps: steps ?? this.steps, progress: progress ?? this.progress,
          estimatedSeconds: estimatedSeconds ?? this.estimatedSeconds, imagePath: imagePath ?? this.imagePath);
}

const _initialSteps = [
  ProcessingStepInfo(step: ProcessingStep.analyzingImage, label: 'Görsel Analiz Edildi', status: ProcessingStepStatus.completed),
  ProcessingStepInfo(step: ProcessingStep.changingBackground, label: 'Arka Plan Değiştiriliyor...', status: ProcessingStepStatus.inProgress),
  ProcessingStepInfo(step: ProcessingStep.generatingCaption, label: 'Metin Üretiliyor', status: ProcessingStepStatus.pending),
];

class ProcessingNotifier extends StateNotifier<ProcessingState> {
  Timer? _timer;
  ProcessingNotifier() : super(const ProcessingState(steps: _initialSteps));

  List<ProcessingStepInfo> _stepsFor(double p) {
    final s = state.steps;
    if (p >= 0.66) return [s[0].copyWith(status: ProcessingStepStatus.completed), s[1].copyWith(status: ProcessingStepStatus.completed), s[2].copyWith(status: ProcessingStepStatus.inProgress)];
    if (p >= 0.33) return [s[0].copyWith(status: ProcessingStepStatus.completed), s[1].copyWith(status: ProcessingStepStatus.inProgress), s[2].copyWith(status: ProcessingStepStatus.pending)];
    return s;
  }

  void simulateProgress() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (t) {
      if (!mounted) { t.cancel(); return; }
      final next = (state.progress + 0.02).clamp(0.0, 1.0);
      state = state.copyWith(progress: next, estimatedSeconds: ((1.0 - next) * 45).round(), steps: _stepsFor(next));
      if (next >= 1.0) t.cancel();
    });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
}

final processingProvider = StateNotifierProvider<ProcessingNotifier, ProcessingState>(
  (ref) => ProcessingNotifier(),
);
