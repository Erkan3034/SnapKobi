import { ProductAnalysis } from '../providers/gemini.analyzer';

export type Platform =
  | 'instagram'
  | 'trendyol'
  | 'hepsiburada'
  | 'website'
  | 'facebook'
  | 'tiktok';

export type BackgroundStyle =
  | 'studio_white'
  | 'studio_dark'
  | 'nature_outdoor'
  | 'minimalist'
  | 'lifestyle'
  | 'ai_generated';

export interface PlatformPrompts {
  backgroundPrompt: string;
  videoPrompt: string;
  captionSystemPrompt: string;
  captionUserPrompt: string;
  imageSpecs: {
    width: number;
    height: number;
    aspectRatio: string;
    notes: string;
  };
}

function buildProductContext(analysis: ProductAnalysis): string {
  return `Ürün: ${analysis.productType}. Renk: ${analysis.dominantColors.join(', ')}. Kategori: ${analysis.suggestedCategory}. Mevcut arka plan: ${analysis.backgroundType}.`;
}

export function getPlatformPrompts(
  platform: Platform,
  backgroundStyle: BackgroundStyle,
  analysis: ProductAnalysis,
  brandName?: string,
  extraContext?: string
): PlatformPrompts {
  const ctx = buildProductContext(analysis);
  const brand = brandName ? `Marka: ${brandName}.` : '';
  const extra = extraContext ? `Ek bilgi: ${extraContext}.` : '';

  const platformConfigs: Record<Platform, PlatformPrompts> = {
    instagram: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: 'editorial, lifestyle, aesthetically pleasing',
        lighting: 'soft natural light, golden hour glow',
        mood: 'aspirational, premium, Instagram-worthy',
        notes: 'Arka plan ürünü gölgede bırakmamalı. Renk paleti pastel veya muted tonlarda olmalı.',
      }),
      videoPrompt: `
${ctx} ${brand}
Cinematic slow-motion product reveal. The ${analysis.productType} is the hero.
Camera: subtle push-in with slight parallax. 
Motion: gentle rotation or floating effect on product.
Lighting: soft rim light, premium feel.
Duration: 5-7 seconds. No text overlays. 
Style: Instagram Reels aesthetic, aspirational lifestyle brand.
Background: ${getBackgroundDescription(backgroundStyle)}.
      `.trim(),
      captionSystemPrompt: `
Sen Snapkobi'nin Instagram içerik yazarısın. 
Türkçe, genç ve enerjik ama premium bir ton kullan.
Her zaman şu yapıyı takip et:
1. Hook cümlesi (dikkat çekici, emoji ile başla)
2. Ürün faydası (1-2 cümle)
3. CTA (call-to-action)
4. Hashtag bloğu (15-20 hashtag, Türkçe + İngilizce karışık)

KURALLAR:
- Maksimum 2200 karakter
- Emoji kullan ama abartma (her cümlede max 1)
- Hashtag'leri ayrı satırda ver
- Fiyat yazma (kullanıcı ekleyecek)
- "Satın al" yerine "Keşfet", "İncele", "Sahip ol" gibi ifadeler kullan
      `.trim(),
      captionUserPrompt: `
${ctx} ${brand} ${extra}
Bu ürün için Instagram caption yaz. Yukarıdaki sistem kurallarına uy.
      `.trim(),
      imageSpecs: {
        width: 1080,
        height: 1080,
        aspectRatio: '1:1',
        notes: 'Feed için kare. Stories/Reels için 9:16 ayrıca üret.',
      },
    },
    trendyol: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: 'clean, professional, e-commerce catalog',
        lighting: 'even studio lighting, no harsh shadows',
        mood: 'trustworthy, clear, marketplace-ready',
        notes: 'Saf beyaz veya açık gri arka plan tercih edilmeli. Ürün tam görünür ve merkezi olmalı.',
      }),
      videoPrompt: `
${ctx} ${brand}
Professional e-commerce product video for Trendyol marketplace.
360-degree slow rotation OR multi-angle showcase of ${analysis.productType}.
Lighting: professional studio, even illumination, no hot spots.
Background: pure white or light gray, clean.
Duration: 5-8 seconds. Show product features clearly.
Style: catalog quality, trustworthy, no artistic effects.
Text overlays: none (will be added separately).
      `.trim(),
      captionSystemPrompt: `
Sen Trendyol ürün listeleme uzmanısın.
SEO odaklı, bilgi yoğun, güven veren açıklamalar yaz.
Şu yapıyı kullan:

BAŞLIK: [Marka] [Ürün Adı] [Ana Özellik] (max 80 karakter)

KISA AÇIKLAMA: 2-3 cümle, ürünün temel faydası

ÖZELLİKLER:
• Özellik 1
• Özellik 2
• Özellik 3
• Özellik 4
• Özellik 5

UZUN AÇIKLAMA: 100-150 kelime. SEO anahtar kelimeler doğal yerleştir.

ARAMA ETİKETLERİ: virgülle ayrılmış 10 anahtar kelime

KURALLAR:
- Türkçe, resmi ama anlaşılır dil
- Büyük harf abartısı yok
- Ölçü, malzeme, renk bilgilerini vurguyla
- Trendyol'un yasaklı ifadelerini kullanma: "en iyi", "1 numara", "garantili"
      `.trim(),
      captionUserPrompt: `
${ctx} ${brand} ${extra}
Bu ürün için Trendyol listeleme metni yaz. Sistem kurallarına kesinlikle uy.
      `.trim(),
      imageSpecs: {
        width: 1000,
        height: 1000,
        aspectRatio: '1:1',
        notes: 'Beyaz arkaplan zorunlu (ana görsel). Ürün frame\'in %85\'ini kaplamalı.',
      },
    },
    hepsiburada: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: 'clean catalog, marketplace standard',
        lighting: 'bright, even, professional studio',
        mood: 'reliable, clear, detailed',
        notes: 'HepsiBurada standartları: beyaz arka plan, gölgesiz, ürün merkezi.',
      }),
      videoPrompt: `
${ctx} ${brand}
Clean product showcase video for HepsiBurada marketplace.
Show ${analysis.productType} from multiple angles methodically.
Highlight key features with slow close-up shots.
Background: pure white studio. 
Lighting: bright, professional, no shadows.
Duration: 6-10 seconds. Professional, not artistic.
Style: informative product demo, builds purchase confidence.
      `.trim(),
      captionSystemPrompt: `
Sen HepsiBurada ürün içerik uzmanısın.
Detaylı, güven veren ve teknik açıdan doğru açıklamalar yaz.

FORMAT:
ÜRÜN ADI: (net, açıklayıcı, max 100 karakter)

ÜRÜNİN FAYDALARI:
→ Fayda 1
→ Fayda 2  
→ Fayda 3

TEKNİK ÖZELLİKLER:
- Özellik: Değer
- Özellik: Değer
- Özellik: Değer

ÜRÜN AÇIKLAMASI: (150-200 kelime, SEO dahil)

KURALLAR:
- Teknik bilgi ön planda
- Müşteri sorularını önceden yanıtla (malzeme? ölçü? bakım?)
- Türkçe karakter kullan
- Garanti ve iade bilgisi ekleme (platform halleder)
      `.trim(),
      captionUserPrompt: `
${ctx} ${brand} ${extra}
Bu ürün için HepsiBurada ürün açıklaması yaz.
      `.trim(),
      imageSpecs: {
        width: 1200,
        height: 1200,
        aspectRatio: '1:1',
        notes: 'Min 500x500px. Beyaz arka plan zorunlu.',
      },
    },
    website: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: 'premium, brand-consistent, editorial',
        lighting: 'professional with creative latitude',
        mood: 'brand premium, storytelling',
        notes: 'Web sitesi için arkaplan marka kimliğini yansıtmalı. Lifestyle veya stüdyo her ikisi de uygun.',
      }),
      videoPrompt: `
${ctx} ${brand}
Premium website hero video for ${analysis.productType}.
Cinematic quality, brand-story feel.
Camera: smooth dolly or Ken Burns effect.
Include both close-up detail shots and full product reveal.
Duration: 8-15 seconds. Can loop seamlessly.
Style: premium brand video, like Apple or luxury e-commerce.
Background: ${getBackgroundDescription(backgroundStyle)}.
      `.trim(),
      captionSystemPrompt: `
Sen bir e-ticaret web sitesi için ürün sayfası yazarısın.
Dönüşüm odaklı (conversion-focused) copywriting yaz.

ÇIKTILAR (hepsini yaz):

H1 BAŞLIK: (ana ürün başlığı, max 60 karakter)
H2 ALT BAŞLIK: (değer önerisi, max 100 karakter)
HERO PARAGRAF: (3-4 cümle, duygusal bağ + mantıksal fayda)
ÖZELLIK KARTLARI (4 adet):
  Kart 1: [İkon önerisi] | Başlık | Açıklama (max 20 kelime)
  Kart 2: [İkon önerisi] | Başlık | Açıklama
  Kart 3: [İkon önerisi] | Başlık | Açıklama
  Kart 4: [İkon önerisi] | Başlık | Açıklama
CTA BUTONU METNİ: (max 5 kelime)
META DESCRIPTION: (max 160 karakter, SEO)

KURALLAR:
- Problem → Çözüm → Fayda yapısı
- Rakam kullan (varsa: "3 renk", "2 yıl garanti")
- Müşteri dilini kullan, teknik jargon yok
      `.trim(),
      captionUserPrompt: `
${ctx} ${brand} ${extra}
Bu ürün için web sitesi ürün sayfası metinleri yaz.
      `.trim(),
      imageSpecs: {
        width: 1920,
        height: 1080,
        aspectRatio: '16:9',
        notes: 'Hero banner için. Ayrıca 1:1 ürün karesi de üret.',
      },
    },
    facebook: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: 'relatable, lifestyle, warm',
        lighting: 'natural, warm tones',
        mood: 'trustworthy, community, value-for-money',
        notes: 'Facebook demografisi için güven veren, samimi arka planlar. Aşırı polished görünmemeli.',
      }),
      videoPrompt: `
${ctx} ${brand}
Facebook feed video ad for ${analysis.productType}.
Hook in first 3 seconds (strong visual movement).
Show product in use or in lifestyle context.
Duration: 8-15 seconds. Subtitles-ready (no burnt-in text).
Style: authentic, relatable, not overly produced.
Background: ${getBackgroundDescription(backgroundStyle)}.
CTA moment at end: product prominently shown.
      `.trim(),
      captionSystemPrompt: `
Sen Facebook reklam ve organik gönderi metin yazarısın.
Hedef kitle: 25-55 yaş, Türk e-ticaret kullanıcıları.

FORMAT:
HOOK (ilk cümle, kaydırmayı durduracak, soru veya şaşırtıcı ifade)
AÇIKLAMA (3-4 cümle, ürün faydası + sosyal kanıt ipucu)
TEKLİF (varsa indirim/kampanya vurgusu)
CTA ("Şimdi İncele", "Linke Tıkla", "Sayfamızı Ziyaret Et")

KURALLAR:
- Samimi, arkadaşça ton
- Emoji kullan ama Instagram kadar değil
- Fiyat-değer dengesini vurgula
- Max 500 karakter (organik gönderi için)
      `.trim(),
      captionUserPrompt: `
${ctx} ${brand} ${extra}
Facebook gönderi / reklam metni yaz.
      `.trim(),
      imageSpecs: {
        width: 1200,
        height: 628,
        aspectRatio: '1.91:1',
        notes: 'Link paylaşımı için. Feed için 1:1 de üret.',
      },
    },
    tiktok: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: 'vibrant, trendy, Gen-Z aesthetic',
        lighting: 'ring light aesthetic or colorful studio',
        mood: 'fun, energetic, viral-potential',
        notes: 'TikTok için arkaplan canlı, dikkat çekici olmalı. Trend renkler ve dokular tercih edilmeli.',
      }),
      videoPrompt: `
${ctx} ${brand}
TikTok-native product video for ${analysis.productType}.
VERTICAL format (9:16 implied). Fast-paced cuts.
First frame MUST be attention-grabbing (close-up reveal or dramatic angle).
Duration: 7-15 seconds. Loop-friendly ending.
Style: UGC (user-generated content) aesthetic, authentic but polished.
Motion: dynamic camera moves, product transitions.
Background: ${getBackgroundDescription(backgroundStyle)}.
Energy: high. This should stop the scroll.
      `.trim(),
      captionSystemPrompt: `
Sen TikTok ürün içerik yazarısın.
Gen-Z ve Millennial dili, trend, eğlenceli.

FORMAT:
HOOK TEXT (video üstüne yazılacak - max 8 kelime, merak uyandırıcı)
CAPTION (max 150 karakter, samimi, emoji yoğun)
HASHTAG (8-12 adet, trending + niche karışık)
SES ÖNERİSİ (trending sound tipi: "upbeat pop", "viral sound", vb.)

KURALLAR:
- "POV:", "Tell me why", "#fyp" tarzı TikTok dili kullan
- Türkçe ağırlıklı ama trend İngilizce ifadeler karıştır
- Soru veya meydan okuma ile bitir
- Kesinlikle resmi dil kullanma
      `.trim(),
      captionUserPrompt: `
${ctx} ${brand} ${extra}
TikTok video için script hook ve caption yaz.
      `.trim(),
      imageSpecs: {
        width: 1080,
        height: 1920,
        aspectRatio: '9:16',
        notes: 'Dikey format zorunlu. Thumbnail için 1:1 de üret.',
      },
    },
  };

  return platformConfigs[platform];
}

function buildBackgroundPrompt(
  style: BackgroundStyle,
  analysis: ProductAnalysis,
  platformHints: {
    style: string;
    lighting: string;
    mood: string;
    notes: string;
  }
): string {
  const styleDescriptions: Record<BackgroundStyle, string> = {
    studio_white: 'Pure white studio background, professional photography seamless paper backdrop, even lighting',
    studio_dark: 'Dark charcoal or deep navy studio background, dramatic moody lighting, luxury feel',
    nature_outdoor: 'Natural outdoor setting, soft bokeh background, grass or stone surface, golden hour light',
    minimalist: 'Ultra-minimal background, single subtle color or texture, Scandinavian aesthetic',
    lifestyle: 'Contextual lifestyle setting relevant to product use, relatable real-world environment',
    ai_generated: 'AI-generated creative background that complements product colors and category',
  };

  return `
Product: ${analysis.productType}. Colors: ${analysis.dominantColors.join(', ')}.
Background style: ${styleDescriptions[style]}.
Platform requirements: ${platformHints.style}.
Lighting: ${platformHints.lighting}.
Mood: ${platformHints.mood}.
Important: ${platformHints.notes}
The product must remain the clear focal point. Background should enhance, not compete.
Photorealistic, commercial quality, no watermarks, no text.
  `.trim();
}

function getBackgroundDescription(style: BackgroundStyle): string {
  const map: Record<BackgroundStyle, string> = {
    studio_white: 'clean white studio',
    studio_dark: 'dark moody studio',
    nature_outdoor: 'natural outdoor setting',
    minimalist: 'minimal clean surface',
    lifestyle: 'contextual lifestyle environment',
    ai_generated: 'AI-generated complementary scene',
  };
  return map[style];
}
