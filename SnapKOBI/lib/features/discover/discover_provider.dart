import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/discover_mock_data.dart';
import 'models/discover_models.dart';

export 'models/discover_models.dart';

class DiscoverState {
  final List<TrendItem> trends;
  final List<TemplateItem> templates;
  final List<CommunityItem> community;
  final bool isLoading;

  const DiscoverState({
    this.trends = const [],
    this.templates = const [],
    this.community = const [],
    this.isLoading = true,
  });
}

class DiscoverNotifier extends StateNotifier<DiscoverState> {
  DiscoverNotifier() : super(const DiscoverState(isLoading: true)) {
    _load();
  }

  void _load() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        state = DiscoverState(
          isLoading: false,
          trends: mockTrendItems,
          templates: mockTemplateItems,
          community: mockCommunityItems,
        );
      }
    });
  }
}

final discoverProvider = StateNotifierProvider<DiscoverNotifier, DiscoverState>(
  (ref) => DiscoverNotifier(),
);
