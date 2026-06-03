import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../domain/entities/sector.dart';

enum HistoryFilter { all, thisWeek, images, videos }

const _sectorTitles = {
  SectorType.food: 'Gıda Tanıtımı',
  SectorType.textile: 'Tekstil Tanıtımı',
  SectorType.electronics: 'Elektronik Tanıtımı',
  SectorType.jewelry: 'Takı Tanıtımı',
  SectorType.beauty: 'Kozmetik Tanıtımı',
  SectorType.furniture: 'Mobilya Tanıtımı',
  SectorType.other: 'Ürün Tanıtımı',
};

class HistoryItem {
  final String id;
  final String title;
  final String platformLabel;
  final String timeAgo;
  final String imageUrl;
  final String beforeUrl;
  final String? videoUrl;
  final String caption;
  final List<String> hashtags;
  final DateTime createdAt;

  const HistoryItem({
    required this.id,
    required this.title,
    required this.platformLabel,
    required this.timeAgo,
    required this.imageUrl,
    required this.beforeUrl,
    required this.createdAt,
    this.videoUrl,
    this.caption = '',
    this.hashtags = const [],
  });

  bool get hasVideo => (videoUrl != null && videoUrl!.trim().isNotEmpty);
}

class HistoryState {
  final HistoryFilter filter;
  final List<HistoryItem> items;
  final bool isLoading;
  const HistoryState({this.filter = HistoryFilter.all, this.items = const [], this.isLoading = true});
  HistoryState copyWith({HistoryFilter? filter, List<HistoryItem>? items, bool? isLoading}) =>
      HistoryState(filter: filter ?? this.filter, items: items ?? this.items, isLoading: isLoading ?? this.isLoading);

  /// Seçili filtreye göre süzülmüş liste (UI bunu kullanır).
  List<HistoryItem> get visibleItems {
    switch (filter) {
      case HistoryFilter.thisWeek:
        final weekAgo = DateTime.now().subtract(const Duration(days: 7));
        return items.where((i) => i.createdAt.isAfter(weekAgo)).toList();
      case HistoryFilter.videos:
        return items.where((i) => i.hasVideo).toList();
      case HistoryFilter.images:
        return items.where((i) => !i.hasVideo).toList();
      case HistoryFilter.all:
        return items;
    }
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  final Ref _ref;

  HistoryNotifier(this._ref) : super(const HistoryState(isLoading: true)) {
    loadRealHistory();
  }

  Future<void> loadRealHistory() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = _ref.read(generationRepositoryProvider);
      final result = await repo.getHistory();

      result.fold(
        onSuccess: (list) {
          final items = list.map((gen) {
            final dt = gen.createdAt;
            final diff = DateTime.now().difference(dt);
            String timeAgo;
            if (diff.inMinutes < 60) {
              timeAgo = '${diff.inMinutes} dk önce';
            } else if (diff.inHours < 24) {
              timeAgo = '${diff.inHours} saat önce';
            } else {
              timeAgo = '${diff.inDays} gün önce';
            }

            return HistoryItem(
              id: gen.id,
              title: _sectorTitles[gen.sector] ?? 'Ürün Tanıtımı',
              platformLabel: gen.platform.name.toUpperCase(),
              timeAgo: timeAgo,
              imageUrl: gen.processedImageUrl ?? gen.originalImageUrl,
              beforeUrl: gen.originalImageUrl,
              videoUrl: gen.videoUrl,
              caption: gen.caption ?? '',
              hashtags: gen.hashtags,
              createdAt: dt,
            );
          }).toList();

          if (mounted) {
            state = state.copyWith(items: items, isLoading: false);
          }
        },
        onFailure: (error) {
          if (mounted) {
            state = state.copyWith(items: const [], isLoading: false);
          }
        },
      );
    } catch (e) {
      if (mounted) {
        state = state.copyWith(items: const [], isLoading: false);
      }
    }
  }

  void setFilter(HistoryFilter f) => state = state.copyWith(filter: f);
}

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>(
  (ref) => HistoryNotifier(ref),
);
