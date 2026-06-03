import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/logger.dart';
import 'discover_datasource.dart';
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
  final Ref _ref;

  DiscoverNotifier(this._ref) : super(const DiscoverState(isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    final ds = _ref.read(discoverDatasourceProvider);
    // Her kaynak bagimsiz yuklenir: biri hata verse bile digerleri (or. topluluk)
    // bos kalmasin. (Onceden Future.wait bir hatada hepsini bosaltiyordu.)
    final results = await Future.wait([
      _safe('Trendler', ds.getTrends),
      _safe('Sablonlar', ds.getTemplates),
      _safe('Topluluk', ds.getCommunityPosts),
    ]);
    if (!mounted) return;
    state = DiscoverState(
      isLoading: false,
      trends: (results[0] as List).cast<TrendItem>(),
      templates: (results[1] as List).cast<TemplateItem>(),
      community: (results[2] as List).cast<CommunityItem>(),
    );
  }

  Future<List<T>> _safe<T>(String label, Future<List<T>> Function() fn) async {
    try {
      return await fn();
    } catch (e, st) {
      AppLogger.e('$label yuklenemedi', e, st);
      return <T>[];
    }
  }

  Future<void> refresh() => _load();
}

final discoverProvider = StateNotifierProvider<DiscoverNotifier, DiscoverState>(
  (ref) => DiscoverNotifier(ref),
);

/// DB'deki guvenli yedek: background_themes tablosu bos/erisilemezse bunlar kullanilir.
/// id'ler AI pipeline'in bekledigi stil anahtarlariyla ayni kalmalidir.
const _fallbackBackgroundThemes = <BackgroundThemeOption>[
  BackgroundThemeOption(id: 'studio', label: 'Stüdyo', imageUrl: 'https://images.unsplash.com/photo-1596265376427-4688ee0f616f?w=150&q=80'),
  BackgroundThemeOption(id: 'outdoor', label: 'Outdoor', imageUrl: 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=150&q=80'),
  BackgroundThemeOption(id: 'home', label: 'Ev', imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=150&q=80'),
  BackgroundThemeOption(id: 'nature', label: 'Doğa', imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=150&q=80'),
  BackgroundThemeOption(id: 'minimalist', label: 'Minimalist', imageUrl: 'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?w=150&q=80'),
  BackgroundThemeOption(id: 'luxury', label: 'Lüks', imageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=150&q=80'),
  BackgroundThemeOption(id: 'neon', label: 'Neon', imageUrl: 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=150&q=80'),
  BackgroundThemeOption(id: 'gradient', label: 'Gradient', imageUrl: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=150&q=80'),
];

/// Create ekrani arka plan temalari: once DB (background_themes), bos/hata ise yedek.
final backgroundThemesProvider = FutureProvider<List<BackgroundThemeOption>>((ref) async {
  try {
    final list = await ref.read(discoverDatasourceProvider).getBackgroundThemes();
    return list.isEmpty ? _fallbackBackgroundThemes : list;
  } catch (e, st) {
    AppLogger.e('Arka plan temalari yuklenemedi, yedek kullaniliyor', e, st);
    return _fallbackBackgroundThemes;
  }
});
