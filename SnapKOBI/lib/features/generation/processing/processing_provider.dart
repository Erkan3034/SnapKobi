// Üretim orkestrasyonu: başlatır + Supabase Realtime ile durumu canlı izler — ProcessingNotifier.
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../../domain/entities/generation.dart';
import '../../../domain/entities/platform_type.dart';
import '../../../domain/entities/sector.dart';
import '../result/result_provider.dart';

class ProcessingNotifier extends AsyncNotifier<Generation?> {
  StreamSubscription? _subscription;

  @override
  Future<Generation?> build() async {
    ref.onDispose(() {
      _subscription?.cancel();
    });
    return null;
  }

  Future<void> startGeneration({
    required String localImagePath,
    required SectorType sector,
    required PlatformType platform,
    required String backgroundTheme,
    String? templateId,
  }) async {
    state = const AsyncLoading();
    final useCase = ref.read(startGenerationUseCaseProvider);

    final result = await useCase.call(
      localImagePath: localImagePath,
      sector: sector,
      platform: platform,
      backgroundTheme: backgroundTheme,
      templateId: templateId,
    );

    result.fold(
      onSuccess: (generation) {
        state = AsyncData(generation);
        _watchStatus(generation.id);
      },
      onFailure: (error) {
        state = AsyncError(error, StackTrace.current);
      },
    );
  }

  void _watchStatus(String generationId) {
    _subscription?.cancel();
    final useCase = ref.read(watchGenerationUseCaseProvider);

    _subscription = useCase.call(generationId).listen(
      (result) {
        result.fold(
          onSuccess: (gen) {
            state = AsyncData(gen);
            if (gen.isCompleted) {
              _subscription?.cancel();
              // Sync the result provider upon successful completion
              ref.read(resultProvider.notifier).setResult(
                originalImageUrl: gen.originalImageUrl,
                processedImageUrl: gen.processedImageUrl ?? '',
                videoUrl: gen.videoUrl,
                caption: gen.caption ?? '',
                hashtags: gen.hashtags,
                platformLabel: gen.platform.name,
                processingDurationSec: gen.completedAt != null
                    ? gen.completedAt!.difference(gen.createdAt).inSeconds
                    : 0,
              );
            } else if (gen.isFailed) {
              _subscription?.cancel();
            }
          },
          onFailure: (err) {
            state = AsyncError(err, StackTrace.current);
            _subscription?.cancel();
          },
        );
      },
      onError: (err) {
        state = AsyncError(err, StackTrace.current);
        _subscription?.cancel();
      },
    );
  }
}

final processingProvider = AsyncNotifierProvider<ProcessingNotifier, Generation?>(
  ProcessingNotifier.new,
);
