# SnapKOBİ Backend

KOBİ'ler için ürün fotoğrafından **paylaşıma hazır görsel + tanıtım videosu + caption/hashtag** üreten AI servisi.
Fastify + TypeScript + Prisma + Supabase (PostgreSQL/Storage) üzerinde çalışır ve **ücretsiz AI modelleriyle** (Gemini + Pollinations + yerel ffmpeg) üretim yapar.

> Bu dosya backend'i **sıfırdan** ayağa kaldırmak içindir: bağımlılıklar → API key'leri → `.env` → veritabanı → çalıştırma → **ngrok ile gerçek telefona bağlama**.

---

## İçindekiler
1. [Mimari & Akış](#1-mimari--akış)
2. [Gereksinimler](#2-gereksinimler)
3. [Kurulum](#3-kurulum)
4. [API Key'leri Nereden Alınır](#4-api-keyleri-nereden-alınır)
5. [.env Dosyası](#5-env-dosyası)
6. [Veritabanı (Prisma + Supabase)](#6-veritabanı-prisma--supabase)
7. [Çalıştırma](#7-çalıştırma)
8. [Sağlık Kontrolü & Endpoint'ler](#8-sağlık-kontrolü--endpointler)
9. [ngrok ile Gerçek Telefona Bağlama](#9-ngrok-ile-gerçek-telefona-bağlama)
10. [Flutter Uygulamasını Bağlama](#10-flutter-uygulamasını-bağlama)
11. [Sorun Giderme](#11-sorun-giderme)

---

## 1. Mimari & Akış

```
Flutter (emülatör/telefon)
        │  HTTP  /v1/...
        ▼
Fastify API (bu proje, :3000)
        │
        ├─ Prisma  ──► Supabase PostgreSQL   (kullanıcı, üretim kayıtları)
        ├─ Supabase Storage                  (yüklenen + üretilen medya)
        └─ AI Pipeline (ücretsiz):
             1) Gemini 2.5 Flash   → ürün analizi + caption        (GOOGLE_AI_API_KEY)
             2) Pollinations flux  → arka plan görseli              (anahtarsız ÜCRETSİZ, key opsiyonel)
             3) @imgly/bg-removal  → ürün kesimi (yerel)
             4) Jimp               → kompozit + gölge (yerel)
             5) Video: Pollinations → FAL → yerel ffmpeg "Ken Burns" (her zaman üretir)
```

Üretim **arka planda** (`setImmediate`) işlenir; istek hemen döner, durum DB'den/WS'den izlenir.

---

## 2. Gereksinimler

| Araç | Sürüm | Not |
|------|-------|-----|
| **Node.js** | 20 LTS+ | `node -v` ile kontrol et |
| **npm** | 9+ | Node ile gelir |
| **Supabase projesi** | — | PostgreSQL + Storage + Auth (zaten var: `bzqqbvviujqxoyhefqoj`) |
| **ffmpeg** | — | **Kurmana gerek yok**: `ffmpeg-static` paketi binary'yi getirir |
| **ngrok** | son sürüm | Yalnızca gerçek telefondan erişim için (Bölüm 9) |

> Windows'ta `@imgly/background-removal-node` ilk kurulumda model dosyalarını indirir; ilk çalıştırma biraz yavaş olabilir.

---

## 3. Kurulum

```bash
cd snapkobi-backend

# 1) Bağımlılıklar
npm install

# 2) Prisma client üret
npm run prisma:generate
```

---

## 4. API Key'leri Nereden Alınır

Aşağıdaki anahtarları toplayıp Bölüm 5'teki `.env`'e yazacaksın. **Yalnızca Google AI key'i zorunlu**; gerisi opsiyonel (yoksa ücretsiz yollara düşülür).

### 🔑 GOOGLE_AI_API_KEY — **zorunlu** (analiz + caption, ücretsiz)
1. https://aistudio.google.com/app/apikey adresine git (Google hesabıyla).
2. **"Create API key"** → bir projede oluştur.
3. Çıkan `AIza...` anahtarını kopyala.
4. Ücretsiz katman üretim için yeterlidir.

### 🎨 POLLINATIONS_KEY — opsiyonel (görsel/video kalitesi)
- Pollinations **anahtarsız da ücretsiz** çalışır. Daha yüksek rate-limit/AI video için token alınabilir: https://pollinations.ai → "API/Token".
- Boş bırakırsan: görsel yine ücretsiz `flux` endpoint'inden üretilir; video yerel **ffmpeg Ken Burns**'e düşer.

### 🎬 FAL_KEY — opsiyonel (ücretli AI video)
- https://fal.ai → Dashboard → **Keys**. Boş bırak → video ffmpeg ile üretilir (ücretsiz). **Maliyet istemiyorsan boş bırak.**

### 🤖 ANTHROPIC_API_KEY / OPENAI_API_KEY — opsiyonel
- Caption için alternatif sağlayıcılar. Boşsa Gemini kullanılır. Gerekmez.

### 🗄️ Supabase anahtarları (zaten elimizde)
Supabase Dashboard → **Project Settings → API**:
- `SUPABASE_URL` → "Project URL"
- `SUPABASE_ANON_KEY` → "Project API keys → anon public"
- `SUPABASE_SERVICE_ROLE_KEY` → "service_role" (**gizli**, sadece backend'de)

DB bağlantısı için → **Project Settings → Database → Connection string**:
- `DATABASE_URL` → **Transaction pooler** (port `6543`, `?pgbouncer=true`)
- `DIRECT_DATABASE_URL` → **Session/direct** (port `5432`) — Prisma migration için

---

## 5. .env Dosyası

`snapkobi-backend/.env` oluştur (yoksa) ve doldur. **Bu dosya gizlidir, git'e commit etme.**

```dotenv
# ─── Supabase PostgreSQL ───────────────────────────────────────────────
# Transaction pooler (uygulama çalışırken kullanılır)
DATABASE_URL=postgresql://postgres.<REF>:<DB_PAROLA>@aws-1-eu-central-1.pooler.supabase.com:6543/postgres?pgbouncer=true
# Direct (yalnızca prisma db push / migration için)
DIRECT_DATABASE_URL=postgresql://postgres.<REF>:<DB_PAROLA>@aws-1-eu-central-1.pooler.supabase.com:5432/postgres

# ─── Supabase Auth / Storage ───────────────────────────────────────────
SUPABASE_URL=https://<REF>.supabase.co
SUPABASE_ANON_KEY=<anon_public_key>
SUPABASE_SERVICE_ROLE_KEY=<service_role_key>

# ─── AI ────────────────────────────────────────────────────────────────
GOOGLE_AI_API_KEY=<AIza_ile_baslayan_key>     # ZORUNLU
GEMINI_MODEL=gemini-2.5-flash
POLLINATIONS_KEY=                              # opsiyonel (boş = ücretsiz endpoint)
FAL_KEY=                                       # opsiyonel (boş = ffmpeg video)
ANTHROPIC_API_KEY=                             # opsiyonel
OPENAI_API_KEY=                                # opsiyonel

# ─── Redis (şu an kullanılmıyor) ───────────────────────────────────────
UPSTASH_REDIS_URL=

# ─── Sunucu ────────────────────────────────────────────────────────────
PORT=3000
NODE_ENV=development
```

> `src/config/env.ts` bu değişkenleri **Zod** ile doğrular. `DATABASE_URL`, `DIRECT_DATABASE_URL`, `SUPABASE_URL`, `SUPABASE_ANON_KEY` boşsa sunucu açılmaz ve eksik alanları loglar.

---

## 6. Veritabanı (Prisma + Supabase)

Şema **Prisma** ile yönetilir (`prisma/schema.prisma`), resmi migration klasörü yerine `db push` kullanılır.

```bash
# Şemayı remote Supabase'e uygula (DIRECT_DATABASE_URL kullanır)
npm run prisma:push
```

> **Showcase / arka plan temaları** (trends, community_posts, admin_templates, background_themes) RLS politikaları Prisma'da yönetilmez. Bunları **Supabase SQL Editor**'de çalıştır:
> - `../supabase/SETUP_SHOWCASE_FULL.sql`
> - `../supabase/SETUP_BACKGROUND_THEMES.sql`

---

## 7. Çalıştırma

```bash
# Geliştirme (hot-reload, ts-node-dev)
npm run dev

# Üretim derlemesi
npm run build      # -> dist/
npm start          # node dist/index.js
```

Başarılı çıktı:
```
🚀 Server listening on http://0.0.0.0:3000
```

> Sunucu `0.0.0.0`'a bağlanır → emülatör (`10.0.2.2`) ve ngrok erişebilir.
> AI config seed'i `listen`'den **sonra** arka planda çalışır; remote DB yavaşsa bile sunucu hemen istek alır.

---

## 8. Sağlık Kontrolü & Endpoint'ler

```bash
curl http://localhost:3000/health
# {"status":"healthy","timestamp":"..."}
```

| Prefix | Açıklama |
|--------|----------|
| `GET  /health` | Sağlık kontrolü |
| `/v1/ai-configs` | AI model konfigürasyonları |
| `/v1/users` | Kullanıcı profili |
| `/v1/brand-kit` | Marka kiti |
| `/v1/products` | Ürünler |
| `/v1/generations` | **Üretim başlatma/sorgulama** (ana akış) |
| `/v1/admin` | Admin işlemleri |

---

## 9. ngrok ile Gerçek Telefona Bağlama

Emülatör backend'e `10.0.2.2` ile ulaşır; **gerçek telefon `localhost`/`10.0.2.2`'ye ulaşamaz**. Geliştirme sırasında bilgisayardaki backend'i telefona açmak için ngrok ile bir public HTTPS tüneli kurarız.

### 9.1 Kurulum
- İndir: https://ngrok.com/download (veya `choco install ngrok` / `npm i -g ngrok`).

### 9.2 Auth token (bir kez)
1. https://dashboard.ngrok.com/get-started/your-authtoken → token'ı kopyala.
2. Terminalde:
   ```bash
   ngrok config add-authtoken <NGROK_TOKEN>
   ```

### 9.3 Tüneli aç (backend çalışırken)
Önce **backend'i çalıştır** (`npm run dev`), ardından **ayrı bir terminalde**:
```bash
ngrok http 3000
```
Çıktıdaki **Forwarding** satırını al:
```
Forwarding   https://a1b2-c3d4.ngrok-free.app -> http://localhost:3000
```
Bu `https://a1b2-c3d4.ngrok-free.app` adresini Flutter'a vereceğiz (Bölüm 10).

> **Önemli sıra:** önce backend `:3000`'de dinlemeli, **sonra** ngrok. Tersi olursa `ERR_NGROK_8012` (backend'e bağlanamadı) alırsın.
> Ücretsiz planda URL her yeniden başlatmada değişir → Flutter'daki `BACKEND_URL`'ü güncellemen gerekir.

---

## 10. Flutter Uygulamasını Bağlama

Flutter, backend adresini şu öncelikle seçer (`SnapKOBI/lib/core/constants/api_constants.dart`):
1. `--dart-define=BACKEND_URL=...` (derleme zamanı, release-güvenli)
2. Gömülü `.env`'deki `BACKEND_URL` (APK'da da okunur — pubspec asset)
3. Platform varsayılanı (yalnızca debug)

> ngrok URL'sine **`/v1` eklemeyi unutma.**

### A) Android Emülatör (ngrok'a gerek yok)
Hiçbir şey yapma — varsayılan `http://10.0.2.2:3000/v1` kullanılır. Sadece backend çalışsın.

### B) Gerçek telefon (debug, ngrok ile)
```bash
cd SnapKOBI
flutter run --dart-define=BACKEND_URL=https://a1b2-c3d4.ngrok-free.app/v1
```

### C) Gerçek telefon (APK, ngrok ile)
```bash
cd SnapKOBI
flutter build apk --dart-define=BACKEND_URL=https://a1b2-c3d4.ngrok-free.app/v1
# çıktı: build/app/outputs/flutter-apk/app-release.apk
```
Alternatif: `SnapKOBI/.env` içine `BACKEND_URL=https://a1b2-c3d4.ngrok-free.app/v1` yaz (asset olduğu için APK'ya gömülür).

> Üretim/yayın için ngrok yerine kalıcı bir public HTTPS backend (örn. Railway) kullan ve `BACKEND_URL`'ü ona ayarla. `Dockerfile` bu proje için hazırdır.

---

## 11. Sorun Giderme

| Belirti | Sebep / Çözüm |
|---------|----------------|
| `❌ Invalid environment variables` | `.env`'de zorunlu alan eksik (DATABASE_URL / SUPABASE_*). Bölüm 5'i kontrol et. |
| `ERR_NGROK_8012` | Backend `:3000`'de dinlemiyor. Önce `npm run dev`, sonra `ngrok http 3000`. |
| Telefonda "bağlanılamadı" | `BACKEND_URL` yanlış/eski ngrok URL'si ya da `/v1` eksik. Yeni Forwarding URL'siyle yeniden derle. |
| `P1001` (Prisma bağlanamadı) | `DIRECT_DATABASE_URL` yanlış ya da ağ/firewall remote pooler'ı blokluyor. Connection string'i Supabase'den tekrar al. |
| Video'da anlamsız yazı | AI arka plan halüsinasyonu — `flux` + güçlü "no-text" prompt zaten ayarlı; `POLLINATIONS_KEY` boşsa ffmpeg fallback metinsizdir. |
| HEIC görsel hatası | iPhone HEIC'i pipeline başında `heic-convert` ile JPEG'e çevriliyor; sorun sürerse paketin kurulu olduğunu doğrula. |
| Caption kullanıcı adını kullanıyor | Düzeltildi — yalnızca `brandName` kullanılır, `displayName` enjekte edilmez. |
| İlk üretim çok yavaş | `@imgly/background-removal-node` modelini ilk seferde indirir; sonraki üretimler hızlanır. |

---

### Hızlı başlangıç (özet)
```bash
cd snapkobi-backend
npm install
npm run prisma:generate
# .env'i doldur (en az GOOGLE_AI_API_KEY + Supabase + DATABASE_URL'ler)
npm run dev                       # -> http://0.0.0.0:3000
# Gerçek telefon için ayrı terminalde:
ngrok http 3000                   # Forwarding https://...ngrok-free.app
# Flutter:
cd ../SnapKOBI
flutter run --dart-define=BACKEND_URL=https://<NGROK>.ngrok-free.app/v1
```
