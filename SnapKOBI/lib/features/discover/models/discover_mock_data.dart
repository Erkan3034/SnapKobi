import '../../../core/constants/app_constants.dart';
import 'discover_models.dart';

const List<TrendItem> mockTrendItems = [
  TrendItem(
    title: 'Spor Ayakkabı',
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80',
    beforeUrl: 'https://images.unsplash.com/photo-1485738422979-f5c462d49f74?w=400&q=80',
    usageCount: 1247, category: 'Tekstil', popularity: '%94', sector: 'Tekstil', platform: 'Instagram',
    caption: 'Yeni sezonun en göz alıcı kırmızıları SnapKOBİ ile hazır! ❤️ Hem şık hem rahat bu modelle tarzını konuştur. Stoklar bitmeden hemen incele. 👟✨',
    hashtags: ['#TrendSneaker', '#Moda2024', '#SnapKOBİ', '#AyakkabiModasi', '#TarziniYansit'],
    scenes: AppConstants.defaultSceneImages,
  ),
  TrendItem(
    title: 'Akıllı Saat',
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80',
    beforeUrl: 'https://images.unsplash.com/photo-1546868871-af0de0ae72be?w=400&q=80',
    usageCount: 856, category: 'Elektronik', popularity: '%91', sector: 'Elektronik', platform: 'Trendyol',
    caption: 'Günün her anında şıklığı yakala! ⌚ En trend tasarımlarla zamanı tarzınla yönet. Sınırlı stoklarla hemen sepetine ekle. ✨',
    hashtags: ['#TrendWatch', '#Moda2024', '#SnapKOBİ', '#AkilliSaat', '#TarziniYansit'],
    scenes: AppConstants.defaultSceneImages,
  ),
  TrendItem(
    title: 'Deri El Çantası',
    imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&q=80',
    beforeUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&q=80',
    usageCount: 634, category: 'Tekstil', popularity: '%89', sector: 'Tekstil', platform: 'Instagram',
    caption: 'Zarafet ve şıklık bir arada! 👜 Kombinlerinin en şık tamamlayıcısı olacak deri el çantası şimdi stoklarda. Kaçırma! ❤️',
    hashtags: ['#TrendBag', '#Moda2024', '#SnapKOBİ', '#DeriCanta', '#TarziniYansit'],
    scenes: AppConstants.defaultSceneImages,
  ),
];

const List<TemplateItem> mockTemplateItems = [
  TemplateItem(id: '1', title: 'Studio Beyaz', imageUrl: 'https://images.unsplash.com/photo-1596265376427-4688ee0f616f?w=300&q=80', category: 'Stüdyo', usageCount: 2340),
  TemplateItem(id: '2', title: 'Doğa Yeşili', imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=300&q=80', category: 'Doğa', usageCount: 1120),
  TemplateItem(id: '3', title: 'Minimalist', imageUrl: 'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?w=300&q=80', category: 'Minimal', usageCount: 980),
  TemplateItem(id: '4', title: 'Neon Gece', imageUrl: 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=300&q=80', category: 'Neon', usageCount: 870),
];

const List<CommunityItem> mockCommunityItems = [
  CommunityItem(
    userName: 'ayakkabi_dunyasi',
    beforeUrl: 'https://images.unsplash.com/photo-1485738422979-f5c462d49f74?w=400&q=80',
    afterUrl: 'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=400&q=80',
    timeAgo: '2 saat önce', platform: 'Instagram', likesCount: 242, commentsCount: 18,
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=80&q=80',
  ),
  CommunityItem(
    userName: 'tech_store_tr',
    beforeUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80',
    afterUrl: 'https://images.unsplash.com/photo-1546868871-af0de0ae72be?w=400&q=80',
    timeAgo: '5 saat önce', platform: 'Trendyol', likesCount: 1200, commentsCount: 56,
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&q=80',
  ),
  CommunityItem(
    userName: 'butik_moda',
    beforeUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&q=80',
    afterUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&q=80',
    timeAgo: '8 saat önce', platform: 'Mağaza', likesCount: 840, commentsCount: 31,
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&q=80',
  ),
  CommunityItem(
    userName: 'kozmetik_dunyam',
    beforeUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&q=80',
    afterUrl: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=400&q=80',
    timeAgo: '1 gün önce', platform: 'Instagram', likesCount: 620, commentsCount: 24,
    avatarUrl: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=80&q=80',
  ),
  CommunityItem(
    userName: 'lezzet_sofrasi',
    beforeUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80',
    afterUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&q=80',
    timeAgo: '2 gün önce', platform: 'Trendyol', likesCount: 450, commentsCount: 12,
    avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=80&q=80',
  ),
];
