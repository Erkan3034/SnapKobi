import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';


enum HistoryFilter { all, thisWeek, images, videos }

class HistoryItem {
  final String id;
  final String title;
  final String platformLabel;
  final String timeAgo;
  final String imageUrl;
  final String beforeUrl;

  const HistoryItem({
    required this.id,
    required this.title,
    required this.platformLabel,
    required this.timeAgo,
    required this.imageUrl,
    required this.beforeUrl,
  });
}

class HistoryState {
  final HistoryFilter filter;
  final List<HistoryItem> items;
  final bool isLoading;
  const HistoryState({this.filter = HistoryFilter.all, this.items = const [], this.isLoading = true});
  HistoryState copyWith({HistoryFilter? filter, List<HistoryItem>? items, bool? isLoading}) =>
      HistoryState(filter: filter ?? this.filter, items: items ?? this.items, isLoading: isLoading ?? this.isLoading);
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
            final title = '${gen.sector.name.toUpperCase()} Reklamı';
            final platformLabel = gen.platform.name.toUpperCase();

            final dt = gen.createdAt;
            final diff = DateTime.now().difference(dt);
            String timeAgo = 'Bilinmiyor';
            if (diff.inMinutes < 60) {
              timeAgo = '${diff.inMinutes} dk önce';
            } else if (diff.inHours < 24) {
              timeAgo = '${diff.inHours} saat önce';
            } else {
              timeAgo = '${diff.inDays} gün önce';
            }

            return HistoryItem(
              id: gen.id,
              title: title,
              platformLabel: platformLabel,
              timeAgo: timeAgo,
              imageUrl: gen.processedImageUrl ?? 'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=400&q=80',
              beforeUrl: gen.originalImageUrl,
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
