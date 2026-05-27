````md
# SnapKobi — AI Content Automation Pipeline (MVP → Scale)

## Amaç

SnapKobi’nin amacı:

- Kullanıcının yüklediği ürün görselini otomatik işlemek
- Arkaplan kaldırmak
- Profesyonel e-ticaret görselleri üretmek
- Tanıtım videosu oluşturmak
- Caption / SEO / açıklama üretmek
- Marketplace formatlarına uygun export almak

Tüm pipeline mümkün olduğunca:
- düşük maliyetli
- hızlı
- API-first
- AI-agent uyumlu
- otomasyona uygun

şekilde tasarlanmıştır.

---

# GENEL PIPELINE

```text
Ürün Görseli Upload
        ↓
1. Background Removal
        ↓
2. AI Background Generation / Product Scene
        ↓
3. Image-to-Video Promo
        ↓
4. Caption / SEO / Product Text
        ↓
5. Upscale + Platform Resize
        ↓
Export (Instagram / Trendyol / Shopify / Amazon / TikTok)
````

---

# TEKNOLOJİ STRATEJİSİ

## MVP Mantığı

Her adımda:

* ücretsiz/free-tier çözüm = PRIMARY
* düşük maliyetli ücretli servis = FALLBACK

mantığı kullanılacak.

---

# 1. ARKAPLAN KALDIRMA

## PRIMARY (MVP)

### remove.bg API

Avantajlar:

* En stabil bg removal API
* Basit HTTP API
* Curl / JS / Python desteği
* Hızlı response
* Production-ready

Free:

* 50 call / ay ücretsiz

Kullanım:

* Basit ürün görselleri
* Tek obje extraction

API:
[https://www.remove.bg/api](https://www.remove.bg/api)

---

## SECONDARY / FALLBACK

### Pixazo SD Inpainting API

Avantaj:

* Background kaldır + değiştir tek işlem
* Mask + prompt destekli
* Stable Diffusion tabanlı
* Open beta ücretsiz

Use-case:

* Daha yaratıcı bg replacement

---

## SCALE FALLBACK

### fal.ai — BRIA RMBG v2.0

Avantaj:

* Çok kaliteli commercial-grade bg removal
* fal.ai ecosystem içinde çalışır
* Aynı key ile tüm pipeline yönetilebilir

Maliyet:
~$0.01 / görsel

---

# 2. AI ARKAPLAN ÜRETME

Amaç:
Ürünü:

* minimalist stüdyo
* outdoor
* lifestyle
* luxury setup
* neon
* cinematic
  vb. ortamlara yerleştirmek.

---

## PRIMARY

### fal.ai — Flux Schnell

Tür:
text-to-image

Use-case:

* sıfırdan ürün sahnesi üretmek
* hızlı generation

Avantaj:

* ucuz
* hızlı
* free credit mevcut

Maliyet:
~$0.003 / görsel

---

## PRIMARY #2

### fal.ai — Flux Kontext Pro

Tür:
instruction-based image editing

Örnek:

```text
Put this sneaker into a clean white studio setup
```

Avantaj:

* doğal dil ile edit
* ürün korunur
* sadece sahne değişir

Maliyet:
~$0.04 / görsel

Use-case:

* gerçek ürünün korunması gereken durumlar

---

## FALLBACK

### Replicate — Flux Fill Pro

Avantaj:

* signup sonrası $5 credit
* mask tabanlı inpainting
* güçlü community ecosystem

Use-case:

* fallback background replacement

---

# 3. IMAGE → VIDEO (PROMO VIDEO)

Amaç:
Tek ürün görselinden:

* cinematic promo
* rotating showcase
* TikTok/Reels ads
* motion product demo
  oluşturmak.

---

## PRIMARY

### fal.ai — WAN 2.6 / 2.7 i2v

Endpoint:

```text
fal-ai/wan-i2v
```

Avantaj:

* yüksek quality/price ratio
* async queue sistemi
* JS client hazır
* tek FAL_KEY yeterli

Use-case:

* otomatik ürün reels üretimi

Maliyet:
~$0.05–0.15 / video

---

## FREE MVP ALTERNATİFİ

### Kling AI — Kling 3.0 API

Avantaj:

* günlük 66 ücretsiz kredi
* watermarklı demo üretilebilir
* kaliteli motion generation

Kısıt:

* watermark
* limitli kullanım

Use-case:

* MVP demo
* yatırımcı demosu
* ilk kullanıcı validasyonu

---

## FALLBACK

### WaveSpeedAI API

Avantaj:

* tek endpoint altında çok model
* Kling + WAN + Seedance erişimi
* REST API

Signup:
~$1 free credit

---

# 4. CAPTION / SEO / PRODUCT TEXT

Amaç:
AI ile:

* caption
* hashtag
* SEO açıklaması
* ürün açıklaması
* kategori etiketleri
* Trendyol/Amazon açıklamaları
  üretmek.

---

## PRIMARY

### Groq API — Llama 3.1 8B Instant

Avantaj:

* inanılmaz hızlı
* yüksek free limit
* caption için yeterli kalite
* çok ucuz

Free limit:
~14.400 request/gün

Use-case:

* yüksek hacimli AI caption generation

Örnek:

```text
Generate trendy Instagram caption for this product
```

---

## PRIMARY #2

### Gemini Flash 2.0 API

Avantaj:

* multimodal
* görsel → açıklama
* ürün görselini analiz eder

Use-case:

* görselden otomatik ürün açıklaması

Örnek:

```text
Analyze this product image and generate ecommerce listing
```

---

## SCALE QUALITY MODEL

### Claude Haiku 4.5

Avantaj:

* en kaliteli marketing copy
* platform-specific tone
* yüksek conversion odaklı metin

Use-case:

* premium müşteriler
* upscale paket

Maliyet:
~$0.001 / caption

---

# 5. UPSCALE + PLATFORM RESIZE

Amaç:

* kalite artırma
* marketplace optimize export
* Instagram/TikTok ratio conversion

---

## PRIMARY

### fal.ai — Real-ESRGAN Upscaler

Avantaj:

* hızlı
* kaliteli
* ucuz
* e-commerce için ideal

Maliyet:
~$0.002 / görsel

---

## FREE ALTERNATİF

### Pixazo Upscaler API

Avantaj:

* ücretsiz beta
* aynı key ile inpainting + upscale

---

# MVP İÇİN GEREKEN API KEYLER

| Servis       | Amaç                            |
| ------------ | ------------------------------- |
| fal.ai       | bg generation + video + upscale |
| remove.bg    | bg removal fallback             |
| Groq         | caption generation              |
| Gemini Flash | multimodal açıklama             |
| Kling AI     | free video generation           |
| Replicate    | inpainting fallback             |

---

# ÖNERİLEN MVP STRATEJİSİ

## En düşük maliyetli setup

### Görsel Pipeline

```text
Upload
→ remove.bg
→ fal.ai Flux Kontext
→ Real-ESRGAN
```

### Video Pipeline

```text
Product Image
→ WAN i2v
→ TikTok/Reels Export
```

### Text Pipeline

```text
Image
→ Gemini Flash Analysis
→ Groq Caption Generation
```

---

# TEK PLATFORM STRATEJİSİ

Uzun vadede:

## SADECE fal.ai

ile:

* bg removal
* image editing
* video
* upscale

tek provider altında yönetilebilir.

Avantaj:

* tek API key
* tek billing
* tek SDK
* orchestration kolaylığı

---

# ÖNERİLEN BACKEND MİMARİSİ

## Stack

```text
Next.js
Node.js
BullMQ / Queue
Redis
Supabase
fal.ai SDK
```

---

# PIPELINE ORCHESTRATION

```text
Upload Job
    ↓
BG Removal Worker
    ↓
Scene Generation Worker
    ↓
Video Generation Worker
    ↓
Caption Worker
    ↓
Export Worker
```

---

# STORAGE STRATEJİSİ

## Supabase Storage

Bucket yapısı:

```text
/raw
/processed
/videos
/upscaled
/exports
```

---

# AI AGENT MANTIĞI

Her pipeline step'i bağımsız worker olarak çalışmalı.

Örnek:

```text
agent-bg-removal
agent-scene-generator
agent-video-generator
agent-caption-generator
agent-exporter
```

Avantaj:

* scale edilebilirlik
* queue retry
* fallback modeli
* provider switch kolaylığı

---

# FALLBACK LOGIC

Örnek:

```text
remove.bg başarısız
    ↓
BRIA RMBG fallback

WAN başarısız
    ↓
Kling fallback

Groq başarısız
    ↓
Gemini fallback
```

---

# MALİYET ANALİZİ (MVP)

## Ortalama ürün başına

| İşlem         | Tahmini maliyet |
| ------------- | --------------- |
| BG Removal    | $0–0.01         |
| BG Generation | $0.003–0.04     |
| Video         | $0.05–0.15      |
| Caption       | ~$0             |
| Upscale       | $0.002          |

---

## MVP Ortalama

```text
~$0.06–0.20 / ürün
```

Free-tier optimizasyonu ile:

```text
neredeyse $0
```

seviyesine düşürülebilir.

---

# ÖNERİLEN İLK IMPLEMENTASYON SIRASI

## Phase 1

* Upload
* remove.bg
* Groq caption
* export

## Phase 2

* Flux Kontext
* upscale
* presets

## Phase 3

* WAN i2v
* reels automation
* batch processing

## Phase 4

* marketplace integrations
* Shopify
* Trendyol
* Amazon
* TikTok Shop

---

# KRİTİK TASARIM KARARLARI

## DO NOT:

* synchronous uzun AI request
* frontend-side secret usage
* blocking video generation
* tek provider dependency

## DO:

* async queue
* webhook/polling
* retry system
* provider abstraction layer

---

# PROVIDER ABSTRACTION ÖRNEĞİ

```ts
interface ImageToVideoProvider {
  generate(input: ProductImage): Promise<VideoResult>
}
```

Avantaj:

* WAN ↔ Kling ↔ Runway değişimi kolay olur.

---

# SONUÇ

SnapKobi MVP için:

* teknik olarak feasible
* düşük maliyetli
* AI-native
* scale edilebilir
* yatırımcı demosuna uygun

bir architecture'a sahip olabilir.

En mantıklı başlangıç:

```text
fal.ai + Groq + remove.bg
```

kombinasyonu.

```
```
