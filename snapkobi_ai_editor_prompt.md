# Snapkobi — AI Editör Prompt'u
## Konu: Sistem Prompt Mimarisi + Admin Şablon Yönetimi

---

## BAĞLAM (Bu dosyayı editörüne ver)

Snapkobi, e-ticaret satıcıları (Trendyol, HepsiBurada, Instagram, web sitesi gibi platformlarda satan işletmeler) için ürün görselini yükleyip platform seçerek şunları otomatik ürettiren bir SaaS uygulaması:

1. **Satış görseli** — arka plan değişimi (stüdyo, doğa, minimalist, vb.) + upscale
2. **Tanıtım videosu** — min. 5 saniyelik image-to-video
3. **Caption + ürün açıklaması** — seçilen platforma özel metin çıktısı

Stack: Next.js (App Router) + FastAPI backend + fal.ai (görsel/video) + Groq/Gemini (metin) + Supabase

---

## GÖREV

Aşağıdaki iki sistemi tam olarak implemente et:

### SİSTEM 1 — Platform Bazlı Dinamik Sistem Promptları

### SİSTEM 2 — Admin Şablon Yönetimi (Haftalık Popüler Şablonlar + Özel Sistem Promptları)

---

## SİSTEM 1: PLATFORM BAZLI DİNAMİK SİSTEM PROMPTLARI

### 1.1 Görsel Analiz Aşaması (Her platformda ortak — ilk adım)

Kullanıcı görsel yüklediğinde, API'ye göndermeden önce **Gemini Flash** ile görsel analizi yapılır. Bu analiz sonraki tüm adımlar için kontekst sağlar.

**`lib/ai/imageAnalyzer.ts` dosyasını oluştur:**

```typescript
// lib/ai/imageAnalyzer.ts

import { GoogleGenerativeAI } from "@google/generative-ai";

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY!);

export interface ProductAnalysis {
  productType: string;        // "ayakkabı", "kozmetik", "elektronik" vb.
  dominantColors: string[];   // ["beyaz", "siyah"]
  backgroundType: string;     // "düz zemin", "karmaşık arkaplan", "stüdyo"
  productCondition: string;   // "tek ürün", "çoklu ürün", "ürün + model"
  lightingQuality: string;    // "iyi aydınlatma", "düşük ışık", "karşı ışık"
  suggestedCategory: string;  // "fashion", "electronics", "food", "beauty", "home"
  rawDescription: string;     // Gemini'nin ham açıklaması
}

const IMAGE_ANALYSIS_SYSTEM_PROMPT = `
Sen bir e-ticaret ürün fotoğrafı uzmanısın. Yüklenen görseli analiz et ve JSON formatında döndür.

KURALLAR:
- Sadece JSON döndür, başka metin ekleme
- Türkçe değerler kullan
- productType için kısa ve net ol (max 3 kelime)
- suggestedCategory SADECE şu değerlerden biri olabilir: fashion, electronics, food, beauty, home, sports, toys, automotive, other

JSON ŞEMASI:
{
  "productType": "string",
  "dominantColors": ["string"],
  "backgroundType": "string",
  "productCondition": "string",
  "lightingQuality": "string",
  "suggestedCategory": "string",
  "rawDescription": "string (max 2 cümle)"
}
`;

export async function analyzeProductImage(
  imageBase64: string,
  mimeType: string = "image/jpeg"
): Promise<ProductAnalysis> {
  const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

  const result = await model.generateContent({
    contents: [
      {
        role: "user",
        parts: [
          {
            inlineData: {
              mimeType,
              data: imageBase64,
            },
          },
          { text: IMAGE_ANALYSIS_SYSTEM_PROMPT },
        ],
      },
    ],
  });

  const raw = result.response.text().replace(/```json|```/g, "").trim();
  return JSON.parse(raw) as ProductAnalysis;
}
```

---

### 1.2 Platform Sistem Promptları

**`lib/ai/platformPrompts.ts` dosyasını oluştur:**

```typescript
// lib/ai/platformPrompts.ts

import { ProductAnalysis } from "./imageAnalyzer";

export type Platform =
  | "instagram"
  | "trendyol"
  | "hepsiburada"
  | "website"
  | "facebook"
  | "tiktok";

export type BackgroundStyle =
  | "studio_white"
  | "studio_dark"
  | "nature_outdoor"
  | "minimalist"
  | "lifestyle"
  | "ai_generated";

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

// ─────────────────────────────────────────────────────────────
// YARDIMCI: Ürün analizinden temel bağlam cümlesi üret
// ─────────────────────────────────────────────────────────────
function buildProductContext(analysis: ProductAnalysis): string {
  return `Ürün: ${analysis.productType}. Renk: ${analysis.dominantColors.join(", ")}. Kategori: ${analysis.suggestedCategory}. Mevcut arka plan: ${analysis.backgroundType}.`;
}

// ─────────────────────────────────────────────────────────────
// PLATFORM PROMPT FACTORY
// ─────────────────────────────────────────────────────────────
export function getPlatformPrompts(
  platform: Platform,
  backgroundStyle: BackgroundStyle,
  analysis: ProductAnalysis,
  brandName?: string,
  extraContext?: string
): PlatformPrompts {
  const ctx = buildProductContext(analysis);
  const brand = brandName ? `Marka: ${brandName}.` : "";
  const extra = extraContext ? `Ek bilgi: ${extraContext}.` : "";

  const platformConfigs: Record<Platform, PlatformPrompts> = {
    // ──────────── INSTAGRAM ────────────
    instagram: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: "editorial, lifestyle, aesthetically pleasing",
        lighting: "soft natural light, golden hour glow",
        mood: "aspirational, premium, Instagram-worthy",
        notes:
          "Arka plan ürünü gölgede bırakmamalı. Renk paleti pastel veya muted tonlarda olmalı.",
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
        aspectRatio: "1:1",
        notes: "Feed için kare. Stories/Reels için 9:16 ayrıca üret.",
      },
    },

    // ──────────── TRENDYOL ────────────
    trendyol: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: "clean, professional, e-commerce catalog",
        lighting: "even studio lighting, no harsh shadows",
        mood: "trustworthy, clear, marketplace-ready",
        notes:
          "Saf beyaz veya açık gri arka plan tercih edilmeli. Ürün tam görünür ve merkezi olmalı.",
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
        aspectRatio: "1:1",
        notes:
          "Beyaz arkaplan zorunlu (ana görsel). Ürün frame'in %85'ini kaplamalı.",
      },
    },

    // ──────────── HEPSİBURADA ────────────
    hepsiburada: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: "clean catalog, marketplace standard",
        lighting: "bright, even, professional studio",
        mood: "reliable, clear, detailed",
        notes:
          "HepsiBurada standartları: beyaz arka plan, gölgesiz, ürün merkezi.",
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
        aspectRatio: "1:1",
        notes: "Min 500x500px. Beyaz arka plan zorunlu.",
      },
    },

    // ──────────── WEBSİTE ────────────
    website: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: "premium, brand-consistent, editorial",
        lighting: "professional with creative latitude",
        mood: "brand premium, storytelling",
        notes:
          "Web sitesi için arkaplan marka kimliğini yansıtmalı. Lifestyle veya stüdyo her ikisi de uygun.",
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
Audio: none (will be added separately).
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
        aspectRatio: "16:9",
        notes: "Hero banner için. Ayrıca 1:1 ürün karesi de üret.",
      },
    },

    // ──────────── FACEBOOK ────────────
    facebook: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: "relatable, lifestyle, warm",
        lighting: "natural, warm tones",
        mood: "trustworthy, community, value-for-money",
        notes:
          "Facebook demografisi için güven veren, samimi arka planlar. Aşırı polished görünmemeli.",
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
        aspectRatio: "1.91:1",
        notes: "Link paylaşımı için. Feed için 1:1 de üret.",
      },
    },

    // ──────────── TİKTOK ────────────
    tiktok: {
      backgroundPrompt: buildBackgroundPrompt(backgroundStyle, analysis, {
        style: "vibrant, trendy, Gen-Z aesthetic",
        lighting: "ring light aesthetic or colorful studio",
        mood: "fun, energetic, viral-potential",
        notes:
          "TikTok için arkaplan canlı, dikkat çekici olmalı. Trend renkler ve dokular tercih edilmeli.",
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
        aspectRatio: "9:16",
        notes: "Dikey format zorunlu. Thumbnail için 1:1 de üret.",
      },
    },
  };

  return platformConfigs[platform];
}

// ─────────────────────────────────────────────────────────────
// YARDIMCI: Arka plan prompt builder
// ─────────────────────────────────────────────────────────────
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
    studio_white:
      "Pure white studio background, professional photography seamless paper backdrop, even lighting",
    studio_dark:
      "Dark charcoal or deep navy studio background, dramatic moody lighting, luxury feel",
    nature_outdoor:
      "Natural outdoor setting, soft bokeh background, grass or stone surface, golden hour light",
    minimalist:
      "Ultra-minimal background, single subtle color or texture, Scandinavian aesthetic",
    lifestyle:
      "Contextual lifestyle setting relevant to product use, relatable real-world environment",
    ai_generated:
      "AI-generated creative background that complements product colors and category",
  };

  return `
Product: ${analysis.productType}. Colors: ${analysis.dominantColors.join(", ")}.
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
    studio_white: "clean white studio",
    studio_dark: "dark moody studio",
    nature_outdoor: "natural outdoor setting",
    minimalist: "minimal clean surface",
    lifestyle: "contextual lifestyle environment",
    ai_generated: "AI-generated complementary scene",
  };
  return map[style];
}
```

---

### 1.3 API Route — Tüm Pipeline'ı Tetikleyen Endpoint

**`app/api/generate/route.ts` dosyasını oluştur:**

```typescript
// app/api/generate/route.ts

import { NextRequest, NextResponse } from "next/server";
import { analyzeProductImage } from "@/lib/ai/imageAnalyzer";
import { getPlatformPrompts, Platform, BackgroundStyle } from "@/lib/ai/platformPrompts";
import Groq from "groq-sdk";
import * as fal from "@fal-ai/client";

const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

fal.config({ credentials: process.env.FAL_API_KEY });

export async function POST(req: NextRequest) {
  try {
    const formData = await req.formData();
    const imageFile = formData.get("image") as File;
    const platform = formData.get("platform") as Platform;
    const backgroundStyle = formData.get("backgroundStyle") as BackgroundStyle;
    const brandName = formData.get("brandName") as string | undefined;
    const extraContext = formData.get("extraContext") as string | undefined;
    // Admin şablonu seçildiyse:
    const templateId = formData.get("templateId") as string | undefined;

    // 1. Görseli base64'e çevir
    const imageBuffer = await imageFile.arrayBuffer();
    const imageBase64 = Buffer.from(imageBuffer).toString("base64");
    const mimeType = imageFile.type;

    // 2. Görsel analizi (Gemini)
    const analysis = await analyzeProductImage(imageBase64, mimeType);

    // 3. Platform promptlarını al (veya şablon override)
    let prompts = getPlatformPrompts(
      platform,
      backgroundStyle,
      analysis,
      brandName,
      extraContext
    );

    // 3a. Eğer admin şablonu seçildiyse promptları override et
    if (templateId) {
      prompts = await applyTemplateOverride(prompts, templateId, analysis);
    }

    // 4. Paralel olarak tüm üretim adımlarını başlat
    const [backgroundResult, videoResult, captionResult] = await Promise.allSettled([
      // 4a. Arka plan değiştirme (fal.ai)
      generateBackground(imageBase64, mimeType, prompts.backgroundPrompt),
      // 4b. Video (fal.ai WAN i2v) — sadece base64 upload + prompt
      generateVideo(imageBase64, mimeType, prompts.videoPrompt),
      // 4c. Caption (Groq)
      generateCaption(
        prompts.captionSystemPrompt,
        prompts.captionUserPrompt,
        platform
      ),
    ]);

    return NextResponse.json({
      success: true,
      analysis,
      platform,
      outputs: {
        background:
          backgroundResult.status === "fulfilled"
            ? backgroundResult.value
            : { error: backgroundResult.reason?.message },
        video:
          videoResult.status === "fulfilled"
            ? videoResult.value
            : { error: videoResult.reason?.message },
        caption:
          captionResult.status === "fulfilled"
            ? captionResult.value
            : { error: captionResult.reason?.message },
      },
      imageSpecs: prompts.imageSpecs,
    });
  } catch (err: any) {
    console.error("[generate] error:", err);
    return NextResponse.json({ success: false, error: err.message }, { status: 500 });
  }
}

// ─────────────────────────────────────────────────────────────
// SUB-FUNCTIONS
// ─────────────────────────────────────────────────────────────

async function generateBackground(
  imageBase64: string,
  mimeType: string,
  prompt: string
) {
  // 1. remove.bg ile arka planı kaldır
  const removeBgRes = await fetch("https://api.remove.bg/v1.0/removebg", {
    method: "POST",
    headers: { "X-Api-Key": process.env.REMOVEBG_API_KEY! },
    body: (() => {
      const fd = new FormData();
      fd.append(
        "image_file",
        new Blob([Buffer.from(imageBase64, "base64")], { type: mimeType })
      );
      fd.append("size", "auto");
      return fd;
    })(),
  });

  const cutoutBuffer = await removeBgRes.arrayBuffer();
  const cutoutBase64 = Buffer.from(cutoutBuffer).toString("base64");

  // 2. fal.ai Flux ile yeni arka plan üret + composite et
  const result = await fal.subscribe("fal-ai/flux/schnell", {
    input: {
      prompt: prompt,
      image_size: "square_hd",
      num_inference_steps: 4,
    },
  });

  return {
    backgroundUrl: (result as any).data?.images?.[0]?.url,
    cutoutBase64: `data:image/png;base64,${cutoutBase64}`,
  };
}

async function generateVideo(
  imageBase64: string,
  mimeType: string,
  prompt: string
) {
  // fal.ai'ye önce görseli upload et, sonra URL ile i2v çağır
  const uploadResult = await fal.storage.upload(
    new Blob([Buffer.from(imageBase64, "base64")], { type: mimeType })
  );

  const result = await fal.subscribe("fal-ai/wan-i2v", {
    input: {
      prompt,
      image_url: uploadResult.url,
      duration: "5",
      aspect_ratio: "9:16",
    },
  });

  return {
    videoUrl: (result as any).data?.video?.url,
  };
}

async function generateCaption(
  systemPrompt: string,
  userPrompt: string,
  platform: Platform
) {
  const completion = await groq.chat.completions.create({
    messages: [
      { role: "system", content: systemPrompt },
      { role: "user", content: userPrompt },
    ],
    model: "llama-3.1-8b-instant",
    temperature: 0.7,
    max_tokens: 1024,
  });

  return {
    text: completion.choices[0]?.message?.content,
    platform,
    tokensUsed: completion.usage?.total_tokens,
  };
}

async function applyTemplateOverride(
  basePompts: any,
  templateId: string,
  analysis: any
) {
  // Supabase'den şablonu çek ve promptları override et
  // Bu fonksiyon SİSTEM 2'de implemente edilecek
  const { createClient } = await import("@/lib/supabase/server");
  const supabase = createClient();

  const { data: template } = await supabase
    .from("admin_templates")
    .select("*")
    .eq("id", templateId)
    .single();

  if (!template) return basePompts;

  return {
    ...basePompts,
    backgroundPrompt: template.background_system_prompt
      ? `${template.background_system_prompt}\n\nÜrün: ${analysis.productType}. Renkler: ${analysis.dominantColors.join(", ")}.`
      : basePompts.backgroundPrompt,
    videoPrompt: template.video_system_prompt || basePompts.videoPrompt,
    captionSystemPrompt:
      template.caption_system_prompt || basePompts.captionSystemPrompt,
  };
}
```

---

## SİSTEM 2: ADMIN ŞABLON YÖNETİMİ

### 2.1 Supabase Şema

**`supabase/migrations/001_admin_templates.sql` dosyasını oluştur:**

```sql
-- Admin tarafından yönetilen haftalık popüler şablonlar
CREATE TABLE admin_templates (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  
  -- Şablon kimliği
  name TEXT NOT NULL,                          -- "Bahar Koleksiyonu 2026"
  slug TEXT NOT NULL UNIQUE,                   -- "bahar-koleksiyonu-2026"
  description TEXT,                            -- Kullanıcıya gösterilecek açıklama
  thumbnail_url TEXT,                          -- Önizleme görseli
  category TEXT NOT NULL,                      -- "fashion", "electronics", vb.
  
  -- Feed'de görünüm
  is_active BOOLEAN DEFAULT true,
  is_featured BOOLEAN DEFAULT false,           -- Haftalık öne çıkan şablon
  sort_order INTEGER DEFAULT 0,               -- Sıralama
  display_week DATE,                           -- Hangi haftada gösterilecek
  
  -- AI Sistem Promptları (admin tarafından yazılır)
  background_system_prompt TEXT,               -- fal.ai'ye gidecek arka plan promptu
  video_system_prompt TEXT,                    -- fal.ai WAN i2v'ye gidecek video promptu
  caption_system_prompt TEXT,                  -- LLM'e gidecek sistem promptu (override)
  caption_user_prompt_suffix TEXT,             -- Platform promptuna eklenti
  
  -- Hangi platformlar için geçerli (boşsa hepsi)
  applicable_platforms TEXT[] DEFAULT '{}',   -- ["instagram", "trendyol"]
  
  -- Hangi arka plan stili default olarak seçilsin
  default_background_style TEXT DEFAULT 'studio_white',
  
  -- Örnek çıktılar (admin girebilir)
  example_output_image_url TEXT,
  example_output_video_url TEXT,
  example_caption TEXT,
  
  -- Meta
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Kullanım istatistikleri
CREATE TABLE template_usage_stats (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  template_id UUID REFERENCES admin_templates(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id),
  platform TEXT,
  used_at TIMESTAMPTZ DEFAULT now()
);

-- RLS: Şablonları herkes okuyabilir, sadece admin yazabilir
ALTER TABLE admin_templates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "templates_select_public"
  ON admin_templates FOR SELECT USING (is_active = true);

CREATE POLICY "templates_admin_all"
  ON admin_templates FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM auth.users
      WHERE id = auth.uid()
      AND raw_user_meta_data->>'role' = 'admin'
    )
  );
```

---

### 2.2 Admin Panel — Şablon Yönetim Ekranı

**`app/admin/templates/page.tsx` dosyasını oluştur:**

```tsx
// app/admin/templates/page.tsx
"use client";

import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";

interface AdminTemplate {
  id: string;
  name: string;
  slug: string;
  description: string;
  category: string;
  is_active: boolean;
  is_featured: boolean;
  background_system_prompt: string;
  video_system_prompt: string;
  caption_system_prompt: string;
  caption_user_prompt_suffix: string;
  applicable_platforms: string[];
  default_background_style: string;
  display_week: string;
  thumbnail_url: string;
}

const EMPTY_TEMPLATE: Partial<AdminTemplate> = {
  name: "",
  slug: "",
  description: "",
  category: "fashion",
  is_active: true,
  is_featured: false,
  background_system_prompt: "",
  video_system_prompt: "",
  caption_system_prompt: "",
  caption_user_prompt_suffix: "",
  applicable_platforms: [],
  default_background_style: "studio_white",
};

// ─── Sistem prompt şablonları (admin için başlangıç noktası) ───
const PROMPT_TEMPLATES = {
  background: {
    bahar_koleksiyonu: `Ürünü bahar temalı lifestyle ortamda göster. 
Arkaplan: açık yeşil çimenler, çiçekler, doğal güneş ışığı.
Renk paleti: pastel tonlar (açık pembe, lila, mint yeşili).
Işık: altın saat (golden hour) güneş ışığı, yumuşak gölgeler.
Atmosfer: taze, canlı, sevinçli.
Ürün odak noktası olmalı, arkaplan bulanık (f/2.8 bokeh efekti).`,

    minimalist_luxe: `Ultra minimalist luxury arkaplan.
Yüzey: mermer veya mat beton doku, hafif gri-beyaz.
Işık: tek yönlü diffused studio ışığı, ince gölge.
Atmosfer: sakin, premium, editorial.
Renk paleti: nötr (krem, taş, gri).
Ürün mükemmel kompozisyonda, çok ince drop shadow.`,

    trendyol_beyaz: `E-ticaret standardı saf beyaz arka plan.
Tam beyaz (RGB 255,255,255) seamless kağıt backdrop.
Işık: çok yönlü, gölgesiz, pürüzsüz.
Ürün frame'in %85'ini doldurmalı, merkezi.
Hiçbir dekorasyon veya prop yok.
Trendyol ve HepsiBurada marketplace standardına uygun.`,
  },

  video: {
    product_reveal: `Sinematik ürün reveal videosu.
0-2 sn: Siyah veya blur arkaplan, ürün ortaya çıkıyor (fade in veya push).
2-5 sn: Yavaş 360 derece rotasyon veya multi-angle showcase.
5-7 sn: Kapanış - ürün tam ortada, sabit, premium kompozisyon.
Hareket: yavaş, akıcı, titreşimsiz.
Işık: studio kalitesi, sabit.`,

    lifestyle_teaser: `Lifestyle ürün tanıtım videosu.
Hızlı kesimler (her shot 1-2 sn).
Ürünü kullanım bağlamında göster.
Işık değişiyor (dış mekan, iç mekan karışık).
Son kare: ürün ön planda, arkaplan blur.
Enerji: dinamik ama premium.`,
  },

  caption: {
    instagram_fashion: `Sen bir moda markası için Instagram içerik yazarısın.
Hedef kitle: 18-35 yaş, trend odaklı, online alışveriş yapan.
Ton: aspirasyonel ama ulaşılabilir, samimi.
Her zaman bir "OOTD moment" veya styling ipucu ekle.
Türkçe ağırlıklı, trend İngilizce terimler doğal karışsın.
Caption başı her zaman emoji ile açılsın.
Son satır her zaman bir soru olsun (engagement için).`,

    trendyol_seo: `Sen Trendyol SEO optimizasyon uzmanısın.
Anahtar kelime yoğunluğu %2-3 olmalı.
Her zaman kategoriye özel arama terimlerini dahil et.
Başlıkta marka + ürün tipi + ana özellik formatı kullan.
Fiyat-değer ilişkisini vurgula.
Müşteri yorumlarında sık sorulan soruları yanıtla (malzeme, bakım, beden).`,
  },
};

export default function AdminTemplatesPage() {
  const [templates, setTemplates] = useState<AdminTemplate[]>([]);
  const [editing, setEditing] = useState<Partial<AdminTemplate> | null>(null);
  const [loading, setLoading] = useState(false);
  const [activeTab, setActiveTab] = useState<
    "background" | "video" | "caption"
  >("background");
  const supabase = createClient();

  useEffect(() => {
    fetchTemplates();
  }, []);

  async function fetchTemplates() {
    const { data } = await supabase
      .from("admin_templates")
      .select("*")
      .order("sort_order", { ascending: true });
    if (data) setTemplates(data);
  }

  async function saveTemplate() {
    if (!editing) return;
    setLoading(true);
    try {
      if (editing.id) {
        await supabase
          .from("admin_templates")
          .update({ ...editing, updated_at: new Date().toISOString() })
          .eq("id", editing.id);
      } else {
        await supabase.from("admin_templates").insert(editing);
      }
      await fetchTemplates();
      setEditing(null);
    } finally {
      setLoading(false);
    }
  }

  async function toggleFeatured(id: string, current: boolean) {
    await supabase
      .from("admin_templates")
      .update({ is_featured: !current })
      .eq("id", id);
    await fetchTemplates();
  }

  function applyPromptTemplate(
    type: "background" | "video" | "caption",
    key: string
  ) {
    const promptMap: Record<string, Record<string, string>> = {
      background: PROMPT_TEMPLATES.background,
      video: PROMPT_TEMPLATES.video,
      caption: PROMPT_TEMPLATES.caption,
    };
    const fieldMap: Record<string, keyof AdminTemplate> = {
      background: "background_system_prompt",
      video: "video_system_prompt",
      caption: "caption_system_prompt",
    };
    setEditing((prev) => ({
      ...prev,
      [fieldMap[type]]: promptMap[type][key],
    }));
  }

  return (
    <div className="max-w-6xl mx-auto p-6">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-semibold">Şablon Yönetimi</h1>
          <p className="text-gray-500 text-sm mt-1">
            Haftalık feed şablonları ve AI sistem promptları
          </p>
        </div>
        <button
          onClick={() => setEditing(EMPTY_TEMPLATE)}
          className="bg-black text-white px-4 py-2 rounded-lg text-sm font-medium"
        >
          + Yeni Şablon
        </button>
      </div>

      {/* Şablon Listesi */}
      <div className="grid gap-4 mb-8">
        {templates.map((t) => (
          <div
            key={t.id}
            className="border rounded-xl p-4 flex items-center gap-4"
          >
            {t.thumbnail_url && (
              <img
                src={t.thumbnail_url}
                alt={t.name}
                className="w-16 h-16 rounded-lg object-cover"
              />
            )}
            <div className="flex-1">
              <div className="flex items-center gap-2">
                <span className="font-medium">{t.name}</span>
                {t.is_featured && (
                  <span className="bg-amber-100 text-amber-800 text-xs px-2 py-0.5 rounded-full">
                    Öne Çıkan
                  </span>
                )}
                {!t.is_active && (
                  <span className="bg-gray-100 text-gray-500 text-xs px-2 py-0.5 rounded-full">
                    Pasif
                  </span>
                )}
              </div>
              <p className="text-sm text-gray-500">{t.description}</p>
              <div className="flex gap-2 mt-1">
                <span className="text-xs bg-gray-100 px-2 py-0.5 rounded">
                  {t.category}
                </span>
                {t.applicable_platforms?.map((p) => (
                  <span
                    key={p}
                    className="text-xs bg-blue-50 text-blue-700 px-2 py-0.5 rounded"
                  >
                    {p}
                  </span>
                ))}
              </div>
            </div>
            <div className="flex gap-2">
              <button
                onClick={() => toggleFeatured(t.id, t.is_featured)}
                className="text-xs border px-3 py-1.5 rounded-lg"
              >
                {t.is_featured ? "Öne Çıkarmayı Kaldır" : "Öne Çıkar"}
              </button>
              <button
                onClick={() => setEditing(t)}
                className="text-xs bg-gray-900 text-white px-3 py-1.5 rounded-lg"
              >
                Düzenle
              </button>
            </div>
          </div>
        ))}
      </div>

      {/* Düzenleme Formu */}
      {editing && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl w-full max-w-4xl max-h-[90vh] overflow-y-auto">
            <div className="p-6 border-b flex justify-between items-center">
              <h2 className="text-lg font-semibold">
                {editing.id ? "Şablonu Düzenle" : "Yeni Şablon"}
              </h2>
              <button onClick={() => setEditing(null)} className="text-gray-400">
                ✕
              </button>
            </div>

            <div className="p-6 space-y-6">
              {/* Temel Bilgiler */}
              <section>
                <h3 className="font-medium mb-3">Temel Bilgiler</h3>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="text-sm text-gray-600 block mb-1">
                      Şablon Adı
                    </label>
                    <input
                      value={editing.name || ""}
                      onChange={(e) =>
                        setEditing({ ...editing, name: e.target.value })
                      }
                      className="w-full border rounded-lg px-3 py-2 text-sm"
                      placeholder="Bahar Koleksiyonu 2026"
                    />
                  </div>
                  <div>
                    <label className="text-sm text-gray-600 block mb-1">
                      Slug
                    </label>
                    <input
                      value={editing.slug || ""}
                      onChange={(e) =>
                        setEditing({ ...editing, slug: e.target.value })
                      }
                      className="w-full border rounded-lg px-3 py-2 text-sm"
                      placeholder="bahar-koleksiyonu-2026"
                    />
                  </div>
                  <div className="col-span-2">
                    <label className="text-sm text-gray-600 block mb-1">
                      Açıklama
                    </label>
                    <input
                      value={editing.description || ""}
                      onChange={(e) =>
                        setEditing({ ...editing, description: e.target.value })
                      }
                      className="w-full border rounded-lg px-3 py-2 text-sm"
                    />
                  </div>
                  <div>
                    <label className="text-sm text-gray-600 block mb-1">
                      Kategori
                    </label>
                    <select
                      value={editing.category || "fashion"}
                      onChange={(e) =>
                        setEditing({ ...editing, category: e.target.value })
                      }
                      className="w-full border rounded-lg px-3 py-2 text-sm"
                    >
                      <option value="fashion">Fashion</option>
                      <option value="electronics">Electronics</option>
                      <option value="beauty">Beauty</option>
                      <option value="home">Home</option>
                      <option value="food">Food</option>
                      <option value="sports">Sports</option>
                      <option value="other">Other</option>
                    </select>
                  </div>
                  <div>
                    <label className="text-sm text-gray-600 block mb-1">
                      Görüntülenme Haftası
                    </label>
                    <input
                      type="date"
                      value={editing.display_week || ""}
                      onChange={(e) =>
                        setEditing({ ...editing, display_week: e.target.value })
                      }
                      className="w-full border rounded-lg px-3 py-2 text-sm"
                    />
                  </div>
                </div>
                <div className="flex gap-4 mt-3">
                  <label className="flex items-center gap-2 text-sm">
                    <input
                      type="checkbox"
                      checked={editing.is_active ?? true}
                      onChange={(e) =>
                        setEditing({ ...editing, is_active: e.target.checked })
                      }
                    />
                    Aktif
                  </label>
                  <label className="flex items-center gap-2 text-sm">
                    <input
                      type="checkbox"
                      checked={editing.is_featured ?? false}
                      onChange={(e) =>
                        setEditing({
                          ...editing,
                          is_featured: e.target.checked,
                        })
                      }
                    />
                    Öne Çıkan
                  </label>
                </div>
              </section>

              {/* AI Sistem Promptları */}
              <section>
                <h3 className="font-medium mb-3">AI Sistem Promptları</h3>
                <p className="text-xs text-gray-500 mb-3">
                  Bu promptlar, kullanıcı bu şablonu seçtiğinde platform
                  promptlarının üzerine yazılır (override eder).
                </p>

                {/* Tab Seçici */}
                <div className="flex gap-2 mb-4">
                  {(["background", "video", "caption"] as const).map((tab) => (
                    <button
                      key={tab}
                      onClick={() => setActiveTab(tab)}
                      className={`px-4 py-2 rounded-lg text-sm font-medium transition ${
                        activeTab === tab
                          ? "bg-gray-900 text-white"
                          : "border text-gray-600"
                      }`}
                    >
                      {tab === "background"
                        ? "🖼 Arkaplan"
                        : tab === "video"
                        ? "🎬 Video"
                        : "✍️ Caption"}
                    </button>
                  ))}
                </div>

                {/* Hazır Prompt Şablonları */}
                <div className="flex gap-2 mb-3 flex-wrap">
                  <span className="text-xs text-gray-500 self-center">
                    Hızlı yükle:
                  </span>
                  {Object.keys(PROMPT_TEMPLATES[activeTab]).map((key) => (
                    <button
                      key={key}
                      onClick={() => applyPromptTemplate(activeTab, key)}
                      className="text-xs border border-blue-200 text-blue-700 px-3 py-1 rounded-full"
                    >
                      {key.replace(/_/g, " ")}
                    </button>
                  ))}
                </div>

                {activeTab === "background" && (
                  <textarea
                    value={editing.background_system_prompt || ""}
                    onChange={(e) =>
                      setEditing({
                        ...editing,
                        background_system_prompt: e.target.value,
                      })
                    }
                    rows={10}
                    className="w-full border rounded-lg px-3 py-2 text-sm font-mono"
                    placeholder="fal.ai'ye gönderilecek arka plan üretim promptu..."
                  />
                )}

                {activeTab === "video" && (
                  <textarea
                    value={editing.video_system_prompt || ""}
                    onChange={(e) =>
                      setEditing({
                        ...editing,
                        video_system_prompt: e.target.value,
                      })
                    }
                    rows={10}
                    className="w-full border rounded-lg px-3 py-2 text-sm font-mono"
                    placeholder="WAN i2v modeline gönderilecek video üretim promptu..."
                  />
                )}

                {activeTab === "caption" && (
                  <div className="space-y-3">
                    <div>
                      <label className="text-xs text-gray-600 block mb-1">
                        Sistem Promptu (LLM'e gidecek)
                      </label>
                      <textarea
                        value={editing.caption_system_prompt || ""}
                        onChange={(e) =>
                          setEditing({
                            ...editing,
                            caption_system_prompt: e.target.value,
                          })
                        }
                        rows={8}
                        className="w-full border rounded-lg px-3 py-2 text-sm font-mono"
                        placeholder="LLM sistem promptu..."
                      />
                    </div>
                    <div>
                      <label className="text-xs text-gray-600 block mb-1">
                        Kullanıcı Prompt Eki (platform promptuna eklenir)
                      </label>
                      <textarea
                        value={editing.caption_user_prompt_suffix || ""}
                        onChange={(e) =>
                          setEditing({
                            ...editing,
                            caption_user_prompt_suffix: e.target.value,
                          })
                        }
                        rows={3}
                        className="w-full border rounded-lg px-3 py-2 text-sm font-mono"
                        placeholder="Bu hafta bahar teması ön planda olsun..."
                      />
                    </div>
                  </div>
                )}
              </section>
            </div>

            <div className="p-6 border-t flex justify-end gap-3">
              <button
                onClick={() => setEditing(null)}
                className="px-4 py-2 border rounded-lg text-sm"
              >
                İptal
              </button>
              <button
                onClick={saveTemplate}
                disabled={loading}
                className="px-4 py-2 bg-gray-900 text-white rounded-lg text-sm font-medium disabled:opacity-50"
              >
                {loading ? "Kaydediliyor..." : "Kaydet"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
```

---

### 2.3 Feed'de Şablonları Göster (Kullanıcı Tarafı)

**`components/TemplateFeed.tsx` dosyasını oluştur:**

```tsx
// components/TemplateFeed.tsx
"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";

interface Template {
  id: string;
  name: string;
  slug: string;
  description: string;
  category: string;
  thumbnail_url: string;
  is_featured: boolean;
  example_output_image_url: string;
  example_caption: string;
  applicable_platforms: string[];
}

interface TemplateFeedProps {
  onSelectTemplate: (templateId: string) => void;
  selectedPlatform?: string;
}

export function TemplateFeed({
  onSelectTemplate,
  selectedPlatform,
}: TemplateFeedProps) {
  const [templates, setTemplates] = useState<Template[]>([]);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const supabase = createClient();

  useEffect(() => {
    async function fetchTemplates() {
      let query = supabase
        .from("admin_templates")
        .select("*")
        .eq("is_active", true)
        .order("is_featured", { ascending: false })
        .order("sort_order", { ascending: true });

      // Platform filtrelemesi
      if (selectedPlatform) {
        query = query.or(
          `applicable_platforms.cs.{"${selectedPlatform}"},applicable_platforms.eq.{}`
        );
      }

      const { data } = await query;
      if (data) setTemplates(data);
    }
    fetchTemplates();
  }, [selectedPlatform]);

  function handleSelect(id: string) {
    const newId = selectedId === id ? null : id;
    setSelectedId(newId);
    onSelectTemplate(newId || "");
  }

  if (templates.length === 0) return null;

  return (
    <div className="mb-6">
      <div className="flex items-center justify-between mb-3">
        <h3 className="text-sm font-medium text-gray-900">
          Bu Hafta Popüler Şablonlar
        </h3>
        <span className="text-xs text-gray-500">İsteğe bağlı</span>
      </div>

      <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-hide">
        {/* "Şablonsuz" seçeneği */}
        <button
          onClick={() => handleSelect("")}
          className={`flex-shrink-0 w-24 border-2 rounded-xl p-2 text-center transition ${
            selectedId === null
              ? "border-gray-900 bg-gray-50"
              : "border-gray-200"
          }`}
        >
          <div className="w-full aspect-square rounded-lg bg-gray-100 flex items-center justify-center mb-2">
            <span className="text-2xl">✨</span>
          </div>
          <p className="text-xs font-medium text-gray-700">Varsayılan</p>
        </button>

        {templates.map((t) => (
          <button
            key={t.id}
            onClick={() => handleSelect(t.id)}
            className={`flex-shrink-0 w-24 border-2 rounded-xl p-2 text-center transition ${
              selectedId === t.id
                ? "border-gray-900 bg-gray-50"
                : "border-gray-200 hover:border-gray-400"
            }`}
          >
            {t.example_output_image_url || t.thumbnail_url ? (
              <img
                src={t.example_output_image_url || t.thumbnail_url}
                alt={t.name}
                className="w-full aspect-square rounded-lg object-cover mb-2"
              />
            ) : (
              <div className="w-full aspect-square rounded-lg bg-gradient-to-br from-gray-100 to-gray-200 mb-2" />
            )}
            <p className="text-xs font-medium text-gray-700 leading-tight truncate">
              {t.name}
            </p>
            {t.is_featured && (
              <span className="text-xs text-amber-600">🔥 Trend</span>
            )}
          </button>
        ))}
      </div>
    </div>
  );
}
```

---

### 2.4 Environment Variables

**`.env.local.example` dosyasını oluştur:**

```bash
# AI Servisleri
GEMINI_API_KEY=your_gemini_api_key_here
GROQ_API_KEY=your_groq_api_key_here
FAL_API_KEY=your_fal_api_key_here
REMOVEBG_API_KEY=your_removebg_api_key_here

# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# Admin
ADMIN_EMAIL=admin@snapkobi.com
```

---

## UYGULAMA TALİMATLARI (Editöre Verilecek)

Bu promptu editörüne (Cursor/Claude Code) verirken şunları söyle:

1. **"Yukarıdaki tüm dosyaları eksiksiz oluştur"**
2. **"Her dosya için gerekli import'ları kontrol et"**
3. **"`@google/generative-ai`, `groq-sdk`, `@fal-ai/client` paketlerini package.json'a ekle"**
4. **"Supabase migration'ı çalıştırılabilir hale getir"**
5. **"Admin route'u `/admin` prefix'i altında ve middleware ile koru (sadece admin email erişebilsin)"**

---

## KONTROL LİSTESİ

Editör kodları oluşturduktan sonra şunları kontrol et:

- [ ] `imageAnalyzer.ts` → Gemini API çağrısı JSON parse hatası yakatlıyor mu?
- [ ] `platformPrompts.ts` → Her 6 platform için prompt dolu mu?
- [ ] `route.ts` → `Promise.allSettled` kullanılıyor (biri fail ederse diğerleri durmaz)?
- [ ] `applyTemplateOverride` → Supabase'den şablon null gelirse base prompt'a fallback yapıyor mu?
- [ ] Admin panel → Prompt kaydetme ve yükleme çalışıyor mu?
- [ ] `TemplateFeed` → Platform filtresi doğru çalışıyor mu?
- [ ] `.env.local` → Tüm key'ler tanımlı mı?
