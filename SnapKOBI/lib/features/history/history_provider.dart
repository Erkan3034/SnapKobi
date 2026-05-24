import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HistoryFilter { all, thisWeek, images, videos }

class HistoryItem {
  final String id;
  final String title;
  final String platformLabel;
  final String timeAgo;
  final String imageUrl;
  const HistoryItem({required this.id, required this.title, required this.platformLabel, required this.timeAgo, required this.imageUrl});
}

class HistoryState {
  final HistoryFilter filter;
  final List<HistoryItem> items;
  const HistoryState({this.filter = HistoryFilter.all, this.items = _mockItems});
  HistoryState copyWith({HistoryFilter? filter}) => HistoryState(filter: filter ?? this.filter, items: items);
}

const _mockItems = [
  HistoryItem(id: '1', title: 'Kırmızı Spor Ayakkabı', platformLabel: 'IG', timeAgo: '3 gün önce', imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80'),
  HistoryItem(id: '2', title: 'Akıllı Saat Pro', platformLabel: 'TR', timeAgo: '4 gün önce', imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80'),
  HistoryItem(id: '3', title: 'Deri El Çantası', platformLabel: 'IG', timeAgo: '5 gün önce', imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&q=80'),
  HistoryItem(id: '4', title: 'Gurme Dilimi', platformLabel: 'TR', timeAgo: '1 hafta önce', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80'),
];

class HistoryNotifier extends StateNotifier<HistoryState> {
  HistoryNotifier() : super(const HistoryState());
  void setFilter(HistoryFilter f) => state = state.copyWith(filter: f);
}

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>(
  (ref) => HistoryNotifier(),
);
