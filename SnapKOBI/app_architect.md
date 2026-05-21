# SnapKOBİ — App Architecture Document
> **Hedef Kitle:** Geliştirici ekibi, AI kod editörleri (Cursor, Windsurf, Claude Code)
> **Versiyon:** 1.1.0 | **Tarih:** 2025-05 | **Mimari:** Clean Architecture + SOLID
> **Stack:** Flutter/Dart · PostgreSQL · Supabase · Node.js/Fastify · REST + Supabase Realtime

---

## ⚠️ AI KOD EDİTÖRÜ TALİMATLARI — ÖNCE BU BÖLÜMÜ OKU

> Bu kurallar `.cursorrules`, `CLAUDE.md` ve `AGENTS.md` dosyalarına **aynen** kopyalanmalıdır.
> Cursor, Claude Code, Windsurf veya herhangi bir AI editör kullanılıyorsa bu kurallar **tartışmasızdır**.

### ❌ AI SLOP — KESİNLİKLE YAPILMAYACAKLAR

**State Kirliliği**
```
# YANLIŞ — gereksiz state
class HomeNotifier extends StateNotifier<HomeState> {
  bool _isLoading = false;      // state içinde zaten var
  String? _error = null;        // state içinde zaten var
  List<Generation> _list = [];  // state içinde zaten var
}

# DOĞRU — tek state nesnesi, tek kaynak
class HomeNotifier extends StateNotifier<AsyncValue<List<Generation>>> {
  // Yalnızca business logic metotları burada
}
```

**Yorum Kirliliği**
```dart
// YANLIŞ — AI'ın sevdiği anlamsız yorumlar
// Bu fonksiyon kullanıcıyı getirir
Future<User> getUser() { ... }

// Bu değişken kullanıcı ID'sini tutar
final String userId;

// DOĞRU — yorum yalnızca neden'i açıklar, ne'yi değil
// Supabase RLS user_id kontrolü yaptığı için burada tekrar filtre gerekmez
Future<User> getUser() { ... }
```

**Gereksiz Abstraction**
```
# YANLIŞ — her şeyi interface'e sarma
abstract class StringFormatter { String format(String s); }
class UpperCaseFormatter implements StringFormatter { ... }

# DOĞRU — basit bir extension yeter
extension StringExt on String { String get capitalized => ... }
```

**Boilerplate Kopyalama**
```
# YANLIŞ — her model için aynı fromJson/toJson kopyalanır
# DOĞRU — json_serializable annotation kullan, kod üretsin
@JsonSerializable()
class GenerationModel { ... }
```

**Widget Şişirme**
```dart
// YANLIŞ — 300 satır tek widget
class HomeScreen extends StatelessWidget {
  Widget build(context) {
    return Column(children: [
      // header (80 satır)
      // upload zone (120 satır)
      // platform selector (100 satır)
    ]);
  }
}

// DOĞRU — her parça kendi dosyasında, 80 satırı geçmez
class HomeScreen extends ConsumerWidget {
  Widget build(context, ref) {
    return Column(children: [
      const HomeHeader(),
      const ImageUploadZone(),
      const PlatformSelector(),
    ]);
  }
}
```

### ✅ AI KOD EDİTÖRÜ KURALLARI

```
GENEL:
- Widget içinde asla doğrudan API çağrısı yapma
- Renk için AppColors kullan, asla Color(0xFF...) yazma
- String için l10n veya AppStrings kullan, asla hardcode yazma
- Spacing için AppDimensions kullan, asla sayı yazma (SizedBox(height: 16) değil, SizedBox(height: AppDimensions.spacing16))
- Hata için Result<T> pattern kullan, exception throw etme
- Bir widget 80 satırı geçiyorsa parçala

SUPABASE:
- supabase.from('tablo') çağrısı yalnızca datasource dosyalarında olur
- RLS (Row Level Security) her tabloda aktiftir; Flutter'da user_id filtresi tekrar ekleme
- Realtime dinleme yalnızca repository katmanında, widget'ta asla
- supabase.auth token'ı AuthInterceptor tarafından otomatik eklenir; manuel ekleme

STATE:
- StateNotifier'da field sayısı 3'ü geçiyorsa ayrı bir State class yaz
- AsyncValue<T> kullan; kendi isLoading/isError flag'lerini icat etme
- ref.watch sadece build() içinde; ref.read event handler'larda
- ConsumerWidget yeterince kapsamıyorsa ConsumerStatefulWidget; StatefulWidget + Consumer kombinasyonu yapma

DOSYA:
- Yeni feature → lib/features/<feature_name>/
- Yeni shared widget → lib/shared/widgets/<kategori>/
- Yeni entity → lib/domain/entities/
- Yeni use case → lib/domain/usecases/<feature>/
- Yeni Supabase datasource → lib/data/datasources/remote/supabase_<entity>_datasource.dart

NAMING:
- Widget class: PascalCase + Screen/Widget (HomeScreen, PlatformSelectorWidget)
- Provider: camelCase + Provider (generationListProvider)
- Notifier: camelCase + Notifier (processingNotifier)
- UseCase: PascalCase + UseCase (StartGenerationUseCase)
- Repository interface: PascalCase + Repository (GenerationRepository)
- Supabase datasource: supabase_<entity>_datasource.dart

YASAKLAR:
- BuildContext'i async boşluktan sonra kullanma (mounted kontrol et)
- print() kullanma → AppLogger.d() kullan
- magic number kullanma → const değişkene ata
- // TODO yorumu bırakma → ya yap ya issue aç
- Kullanılmayan import bırakma
- StatefulWidget + setState: yalnızca animasyon/focus gibi gerçek lokal UI state için
```

---

## İçindekiler

1. [Mimari Felsefe & Prensipler](#1-mimari-felsefe--prensipler)
2. [Teknoloji Stack'i](#2-teknoloji-stacki)
3. [Monorepo Yapısı & Backend Kararı](#3-monorepo-yapısı--backend-kararı)
4. [Klasör Yapısı — Flutter](#4-klasör-yapısı--flutter)
5. [Klasör Yapısı — Backend](#5-klasör-yapısı--backend)
6. [Katman Mimarisi (Clean Architecture)](#6-katman-mimarisi-clean-architecture)
7. [Veritabanı Şeması — Supabase PostgreSQL](#7-veritabanı-şeması--supabase-postgresql)
8. [API Sözleşmesi (Contract)](#8-api-sözleşmesi-contract)
9. [State Yönetimi — Riverpod](#9-state-yönetimi--riverpod)
10. [AI Pipeline Entegrasyonu](#10-ai-pipeline-entegrasyonu)
11. [Tema & Tasarım Sistemi](#11-tema--tasarım-sistemi)
12. [Constants & Utilities](#12-constants--utilities)
13. [Güvenlik & Auth](#13-güvenlik--auth)
14. [Hata Yönetimi](#14-hata-yönetimi)
15. [Test Stratejisi](#15-test-stratejisi)
16. [CI/CD & Deploy](#16-cicd--deploy)
17. [Geliştirici Kuralları](#17-geliştirici-kuralları)

---

## 1. Mimari Felsefe & Prensipler

### 1.1 SOLID Prensipleri — Flutter Uygulaması

```
S — Single Responsibility  : Her class/widget tek bir iş yapar.
                             SupabaseGenerationDs sadece Supabase sorguları yapar.
                             GenerationNotifier sadece üretim akışı state'ini yönetir.

O — Open/Closed            : Yeni özellik = yeni class. Mevcut class değişmez.
                             Yeni platform eklemek (TikTok) = yeni PlatformStrategy class'ı.

L — Liskov Substitution    : Repository interface'leri gerçek impl'le swap edilebilir.
                             GenerationRepository → MockGenerationRepository test'te sorunsuz çalışır.

I — Interface Segregation  : Büyük interface'leri parçala.
                             ContentGeneratorInterface yerine:
                             ImageGeneratorInterface + VideoGeneratorInterface + CaptionGeneratorInterface

D — Dependency Inversion   : Widget'lar concrete class'a değil abstract'a bağlıdır.
                             Widget → provider → usecase interface → repository interface → impl
```

### 1.2 Mimari Akış

```
UI (Flutter Widgets)
    │  sadece Provider/Notifier'a erişir
    ▼
State Management (Riverpod AsyncNotifier)
    │  sadece UseCase'leri çağırır
    ▼
Domain Layer (Use Cases + Entities)
    │  business logic burada, framework bağımsız
    ▼
Data Layer (Repositories + DataSources)
    │  Supabase client, Dio (backend API), Hive (local cache)
    ▼
External (Supabase · Node.js Backend · AI Services)
```

### 1.3 Temel Kurallar

- **Hiçbir widget** doğrudan API veya Supabase çağrısı yapmaz.
- **Hiçbir use case** Flutter import içermez (`dart:ui` dahil).
- **Hiçbir repository** UI state tutmaz.
- **Tüm string literal**ler `AppStrings` veya `l10n` dosyalarındadır.
- **Tüm renk/boyut/spacing** değerleri `AppTheme` veya `AppDimensions`'dandır.
- **Tüm API URL**'leri `ApiConstants`'tadır.
- **Tüm Supabase tablo adları** `SupabaseConstants`'tadır.

---

## 2. Teknoloji Stack'i

### 2.1 Frontend (Mobile & Web)

| Katman | Teknoloji | Versiyon | Amaç |
|---|---|---|---|
| Framework | Flutter | ≥ 3.22 (stable) | iOS, Android, Web |
| Dil | Dart | ≥ 3.4 | Null-safe, strong-typed |
| State | Riverpod | ≥ 2.5 | Reactive state, DI |
| Navigation | GoRouter | ≥ 13.0 | Deep link, type-safe routing |
| Supabase | supabase_flutter | ≥ 2.5 | Auth + DB + Storage + Realtime |
| HTTP | Dio | ≥ 5.4 | Backend API çağrıları (interceptor, retry) |
| Local DB | Hive | ≥ 4.0 | Offline cache, user prefs |
| Image Picker | image_picker | ≥ 1.0 | Kamera/galeri |
| Video Player | video_player | ≥ 2.8 | Sonuç video oynatma |
| Share | share_plus | ≥ 7.0 | Platforma paylaş |
| Payment | iyzipay_flutter | latest | TR ödeme |
| i18n | flutter_localizations | built-in | TR, EN, AR |
| Serialization | json_serializable | ≥ 6.0 | fromJson/toJson üretimi |
| Linting | flutter_lints + custom | — | Kod kalitesi |

> **Not:** Firebase tamamen kaldırıldı. Auth → Supabase Auth, Realtime → Supabase Realtime, Storage → Supabase Storage, Push Notifications → Supabase + expo-notifications veya OneSignal.

### 2.2 Backend

| Katman | Teknoloji | Amaç |
|---|---|---|
| Runtime | Node.js 20 LTS + TypeScript | API sunucusu |
| Framework | Fastify v4 | Yüksek performanslı REST API |
| Veritabanı | Supabase PostgreSQL | Ana veri deposu (Prisma ile erişim) |
| ORM | Prisma v5 | Type-safe PostgreSQL erişimi |
| Cache | Upstash Redis | Rate limit, session, job queue |
| Queue | BullMQ (Redis tabanlı) | AI job async processing |
| Auth | Supabase JWT doğrulama | Stateless — Supabase token backend'de doğrulanır |
| Storage | Supabase Storage | Medya dosyaları + CDN |
| Realtime | Supabase Realtime | AI job durum güncellemesi (PostgreSQL trigger) |

### 2.3 AI Servisleri

| Görev | Geliştirme (Ücretsiz) | Üretim (Ücretli) | Maliyet/işlem |
|---|---|---|---|
| Görsel dönüştürme | Google Imagen 4 (AI Studio free) | Imagen 4 Fast API | ~$0.02 |
| Arka plan kaldırma | Imagen 4 inpainting | FLUX.2 Kontext (Replicate) | ~$0.01–0.05 |
| Video üretimi | Kling free (66 kredi/gün) | Seedance 2.0 Fast | ~$0.11 |
| Video (premium) | Veo 3.1 (10/ay ücretsiz) | Veo 3.1 Lite | ~$0.25 |
| Metin üretimi | Gemini 2.5 Flash (AI Studio) | Claude Haiku 4.5 | ~$0.001 |

### 2.4 Altyapı

```
Production:
  ├── Backend   : Railway (Node.js konteyner, snapkobi-backend/ klasöründen deploy)
  ├── Database  : Supabase PostgreSQL (managed, migrations Prisma ile)
  ├── Cache     : Upstash Redis (serverless, bölge: eu-west)
  ├── Storage   : Supabase Storage (CDN, public bucket: results / private: uploads)
  ├── Auth      : Supabase Auth (Google, Apple, Email/Password)
  ├── Realtime  : Supabase Realtime (generations tablo change event)
  ├── Mobile    : App Store + Google Play
  └── Web       : Vercel (Flutter web build)

Development:
  ├── Database  : Supabase local (npx supabase start)
  ├── Cache     : Docker Redis lokal
  └── API Mock  : MSW (Mock Service Worker) Flutter'da
```

---

## 3. Monorepo Yapısı & Backend Kararı

### 3.1 Backend Ayrı Klasörde mü?

**Evet. Backend, Flutter uygulamasından ayrı bir klasörde (`snapkobi-backend/`) tutulur.**

Aynı Git reposunda (monorepo) iki bağımsız proje yaşar:

```
snapkobi/                           ← Monorepo kökü
│
├── snapkobi-flutter/               ← Flutter uygulaması
│   ├── lib/
│   ├── pubspec.yaml
│   └── ...
│
├── snapkobi-backend/               ← Node.js/Fastify backend
│   ├── src/
│   ├── prisma/
│   ├── package.json
│   └── ...
│
├── supabase/                       ← Supabase yerel geliştirme & migration
│   ├── migrations/                 ← SQL migration dosyaları (Prisma'dan üretilir)
│   ├── seed.sql
│   └── config.toml
│
├── .github/
│   └── workflows/
│       ├── flutter-ci.yml
│       └── backend-ci.yml
│
└── README.md
```

**Neden ayrı klasör?**

- Flutter ve Node.js bağımlılıkları (`pubspec.yaml` / `package.json`) çakışmaz.
- Railway sadece `snapkobi-backend/` klasörünü deploy eder; Flutter build'i karıştırmaz.
- `supabase/` klasörü her iki projenin de paylaştığı migration ve seed dosyalarını tutar — tek kaynak.
- CI/CD pipeline'ları bağımsız çalışır: Flutter değişikliği backend deploy'u tetiklemez.

**Supabase yerel geliştirme:**
```bash
# Supabase CLI ile lokal ortam
cd snapkobi/
npx supabase start          # PostgreSQL + Auth + Storage + Realtime lokal başlar
npx supabase db diff        # Şema değişikliklerini migration'a dönüştür
npx supabase db push        # Migration'ı Supabase'e uygula
```

---

## 4. Klasör Yapısı — Flutter

```
snapkobi-flutter/
│
├── android/
├── ios/
├── web/
├── assets/
│   ├── fonts/                        # Nunito, Rubik (Google Fonts)
│   ├── images/
│   ├── icons/
│   ├── animations/                   # Lottie JSON
│   └── l10n/
│       ├── app_tr.arb
│       ├── app_en.arb
│       └── app_ar.arb
│
├── lib/
│   ├── main.dart                     # Supabase.initialize() burada
│   ├── app.dart                      # MaterialApp + GoRouter
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── api_constants.dart    # Backend API URL, endpoint, timeout
│   │   │   ├── supabase_constants.dart  # ← YENİ: tablo adları, bucket adları
│   │   │   ├── asset_constants.dart
│   │   │   ├── storage_keys.dart     # Hive key'leri
│   │   │   └── app_strings.dart
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   ├── app_typography.dart
│   │   │   ├── app_dimensions.dart
│   │   │   └── app_shadows.dart
│   │   │
│   │   ├── utils/
│   │   │   ├── extensions/
│   │   │   │   ├── string_ext.dart
│   │   │   │   ├── context_ext.dart
│   │   │   │   ├── datetime_ext.dart
│   │   │   │   └── list_ext.dart
│   │   │   ├── validators/
│   │   │   │   ├── email_validator.dart
│   │   │   │   ├── phone_validator.dart
│   │   │   │   └── image_validator.dart
│   │   │   ├── helpers/
│   │   │   │   ├── file_helper.dart
│   │   │   │   ├── image_helper.dart
│   │   │   │   └── platform_helper.dart
│   │   │   └── logger.dart
│   │   │
│   │   ├── errors/
│   │   │   ├── app_error.dart
│   │   │   ├── network_error.dart
│   │   │   ├── auth_error.dart
│   │   │   ├── ai_error.dart
│   │   │   └── validation_error.dart
│   │   │
│   │   ├── network/
│   │   │   ├── dio_client.dart           # Supabase JWT'yi header'a ekler
│   │   │   ├── interceptors/
│   │   │   │   ├── auth_interceptor.dart     # supabase.auth.currentSession!.accessToken
│   │   │   │   ├── logging_interceptor.dart
│   │   │   │   ├── retry_interceptor.dart
│   │   │   │   └── error_interceptor.dart
│   │   │   └── api_response.dart
│   │   │
│   │   ├── supabase/                     # ← YENİ: Supabase client erişimi
│   │   │   └── supabase_client.dart      # SupabaseClient singleton (main'de init edilir)
│   │   │
│   │   └── storage/
│   │       ├── local_storage.dart
│   │       ├── secure_storage.dart       # Artık yalnızca ek hassas veri için
│   │       └── cache_manager.dart
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── user.dart
│   │   │   ├── generation.dart
│   │   │   ├── subscription.dart
│   │   │   ├── sector.dart
│   │   │   └── platform_type.dart
│   │   │
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── generation_repository.dart
│   │   │   ├── user_repository.dart
│   │   │   ├── subscription_repository.dart
│   │   │   └── media_repository.dart
│   │   │
│   │   └── usecases/
│   │       ├── auth/
│   │       │   ├── sign_in_with_google_usecase.dart
│   │       │   ├── sign_in_with_apple_usecase.dart
│   │       │   ├── sign_out_usecase.dart
│   │       │   └── get_current_user_usecase.dart
│   │       ├── generation/
│   │       │   ├── upload_image_usecase.dart
│   │       │   ├── start_generation_usecase.dart
│   │       │   ├── watch_generation_usecase.dart   # Supabase Realtime
│   │       │   ├── get_generation_history_usecase.dart
│   │       │   └── download_result_usecase.dart
│   │       └── subscription/
│   │           ├── get_user_plan_usecase.dart
│   │           ├── purchase_plan_usecase.dart
│   │           └── check_credit_usecase.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart           # @JsonSerializable()
│   │   │   ├── generation_model.dart     # @JsonSerializable()
│   │   │   ├── subscription_model.dart
│   │   │   └── api_error_model.dart
│   │   │
│   │   ├── datasources/
│   │   │   ├── remote/
│   │   │   │   ├── supabase_auth_datasource.dart         # ← Supabase Auth
│   │   │   │   ├── supabase_generation_datasource.dart   # ← Supabase DB + Realtime
│   │   │   │   ├── supabase_storage_datasource.dart      # ← Supabase Storage (upload)
│   │   │   │   ├── supabase_user_datasource.dart         # ← Supabase DB (users tablosu)
│   │   │   │   └── backend_generation_ds.dart    # ← Node.js backend (AI trigger)
│   │   │   └── local/
│   │   │       ├── generation_local_ds.dart      # Hive cache
│   │   │       └── user_local_ds.dart
│   │   │
│   │   └── repositories_impl/
│   │       ├── auth_repository_impl.dart
│   │       ├── generation_repository_impl.dart
│   │       ├── user_repository_impl.dart
│   │       └── subscription_repository_impl.dart
│   │
│   ├── features/
│   │   ├── splash/
│   │   ├── onboarding/
│   │   ├── auth/
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   ├── home_provider.dart
│   │   │   └── widgets/
│   │   │       ├── image_upload_zone.dart
│   │   │       ├── platform_selector.dart
│   │   │       ├── sector_badge.dart
│   │   │       └── credit_counter.dart
│   │   ├── generation/
│   │   │   ├── processing/
│   │   │   └── result/
│   │   ├── history/
│   │   ├── subscription/
│   │   └── settings/
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── buttons/
│       │   ├── inputs/
│       │   ├── feedback/
│       │   ├── layout/
│       │   └── image/
│       └── navigation/
│           ├── app_router.dart
│           └── routes.dart
│
├── test/
├── analysis_options.yaml
├── pubspec.yaml
└── .env.example
```

---

## 5. Klasör Yapısı — Backend

```
snapkobi-backend/
│
├── src/
│   ├── index.ts                      # Fastify başlangıç
│   ├── app.ts                        # Plugin kayıtları, CORS, rate limit
│   │
│   ├── config/
│   │   ├── env.ts                    # Zod ile env doğrulama
│   │   ├── database.ts               # Prisma client singleton
│   │   ├── supabase.ts               # ← Supabase admin client (service_role key)
│   │   ├── redis.ts                  # Upstash Redis bağlantısı
│   │   └── constants.ts
│   │
│   ├── middleware/
│   │   ├── auth.middleware.ts        # Supabase JWT doğrulama (supabase.auth.getUser)
│   │   ├── rate-limit.middleware.ts
│   │   └── validate.middleware.ts    # Zod şema doğrulama
│   │
│   ├── modules/
│   │   ├── users/
│   │   │   ├── users.routes.ts
│   │   │   ├── users.controller.ts
│   │   │   ├── users.service.ts
│   │   │   └── users.schema.ts       # Zod şemaları
│   │   │
│   │   ├── generations/
│   │   │   ├── generations.routes.ts
│   │   │   ├── generations.controller.ts
│   │   │   ├── generations.service.ts
│   │   │   ├── generations.schema.ts
│   │   │   └── generations.test.ts
│   │   │
│   │   ├── subscriptions/
│   │   │   ├── subscriptions.routes.ts
│   │   │   ├── subscriptions.controller.ts
│   │   │   ├── subscriptions.service.ts
│   │   │   └── subscriptions.schema.ts
│   │   │
│   │   └── webhooks/
│   │       ├── iyzico.webhook.ts     # Ödeme callback
│   │       └── ai.webhook.ts         # AI servis tamamlandı callback
│   │
│   ├── ai/
│   │   ├── pipeline/
│   │   │   ├── pipeline.orchestrator.ts
│   │   │   ├── image.processor.ts
│   │   │   ├── video.processor.ts
│   │   │   └── caption.processor.ts
│   │   └── providers/
│   │       ├── imagen.provider.ts
│   │       ├── seedance.provider.ts
│   │       ├── claude.provider.ts
│   │       └── flux.provider.ts
│   │
│   ├── jobs/                         # BullMQ worker'ları
│   │   ├── generation.worker.ts
│   │   └── cleanup.worker.ts         # Süresi dolan medyaları sil
│   │
│   └── infrastructure/
│       ├── supabase-realtime.ts      # Realtime status update (DB yazınca trigger)
│       └── storage.service.ts        # Supabase Storage upload/sign/delete
│
├── prisma/
│   ├── schema.prisma                 # Tüm tablo tanımları (bkz. Bölüm 7)
│   └── seed.ts
│
├── package.json
├── tsconfig.json
├── Dockerfile
└── .env.example
```

---

## 6. Katman Mimarisi — Kod Örnekleri

### 6.1 Domain Entity

```dart
// lib/domain/entities/generation.dart

import 'package:equatable/equatable.dart';

class Generation extends Equatable {
  final String id;
  final String userId;
  final String originalImageUrl;
  final String? processedImageUrl;
  final String? videoUrl;
  final String? caption;
  final List<String> hashtags;
  final SectorType sector;
  final PlatformType platform;
  final GenerationStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Generation({
    required this.id,
    required this.userId,
    required this.originalImageUrl,
    this.processedImageUrl,
    this.videoUrl,
    this.caption,
    this.hashtags = const [],
    required this.sector,
    required this.platform,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  bool get isCompleted => status == GenerationStatus.completed;
  bool get isFailed => status == GenerationStatus.failed;
  bool get isProcessing => status != GenerationStatus.completed &&
                           status != GenerationStatus.failed;

  Generation copyWith({ ... }) => Generation( ... );

  @override
  List<Object?> get props => [id, status, processedImageUrl, videoUrl, caption];
}

enum GenerationStatus { pending, uploadingImage, processingImage, processingVideo, generatingCaption, completed, failed, cancelled }
enum SectorType { food, textile, electronics, jewelry, beauty, furniture, other }
enum PlatformType { instagram, trendyol, hepsiburada, whatsapp, web, tiktok }
```

### 6.2 Supabase DataSource

```dart
// lib/data/datasources/remote/supabase_generation_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:snapkobi/core/supabase/supabase_client.dart';
import 'package:snapkobi/core/constants/supabase_constants.dart';
import 'package:snapkobi/data/models/generation_model.dart';

class SupabaseGenerationDataSource {
  final SupabaseClient _client;

  const SupabaseGenerationDataSource(this._client);

  // RLS user_id kontrolü Supabase tarafında yapılır; burada filtre tekrar edilmez.
  Future<List<GenerationModel>> getHistory({int limit = 20, String? cursor}) async {
    var query = _client
        .from(SupabaseConstants.generationsTable)
        .select()
        .order('created_at', ascending: false)
        .limit(limit);

    if (cursor != null) {
      query = query.lt('created_at', cursor);
    }

    final data = await query;
    return data.map(GenerationModel.fromJson).toList();
  }

  // Supabase Realtime ile anlık durum takibi
  Stream<GenerationModel> watchStatus(String generationId) {
    return _client
        .from(SupabaseConstants.generationsTable)
        .stream(primaryKey: ['id'])
        .eq('id', generationId)
        .map((rows) => GenerationModel.fromJson(rows.first));
  }
}
```

### 6.3 Repository Implementation

```dart
// lib/data/repositories_impl/generation_repository_impl.dart

class GenerationRepositoryImpl implements GenerationRepository {
  final SupabaseGenerationDataSource _supabaseDs;
  final BackendGenerationDataSource _backendDs;   // AI tetikleyici için
  final GenerationLocalDataSource _localDs;

  const GenerationRepositoryImpl({
    required SupabaseGenerationDataSource supabaseDs,
    required BackendGenerationDataSource backendDs,
    required GenerationLocalDataSource localDs,
  })  : _supabaseDs = supabaseDs,
        _backendDs = backendDs,
        _localDs = localDs;

  @override
  Future<Result<Generation>> startGeneration({
    required String imageUrl,
    required SectorType sector,
    required PlatformType platform,
  }) async {
    try {
      // Backend AI pipeline'ı başlatır, DB kaydını da oluşturur
      final model = await _backendDs.startGeneration(
        imageUrl: imageUrl,
        sector: sector.name,
        platform: platform.name,
      );
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(NetworkError.fromDio(e));
    } catch (e) {
      return Result.failure(AiProcessingError(message: e.toString()));
    }
  }

  @override
  Stream<Result<Generation>> watchGenerationStatus(String generationId) {
    return _supabaseDs
        .watchStatus(generationId)
        .map((model) => Result.success(model.toEntity()))
        .handleError((e) => Result.failure(NetworkError(message: e.toString())));
  }

  @override
  Future<Result<List<Generation>>> getHistory({int page = 1, int limit = 20}) async {
    try {
      final cached = await _localDs.getHistory();
      if (cached.isNotEmpty && page == 1) return Result.success(cached.map((m) => m.toEntity()).toList());

      final models = await _supabaseDs.getHistory(limit: limit);
      await _localDs.saveHistory(models);
      return Result.success(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(NetworkError(message: e.toString()));
    }
  }
}
```

### 6.4 Riverpod Provider (doğru kullanım)

```dart
// lib/features/generation/processing/processing_provider.dart

// StateNotifier değil AsyncNotifier — AsyncValue otomatik yönetir
class ProcessingNotifier extends AsyncNotifier<Generation?> {
  @override
  Future<Generation?> build() async => null;

  Future<void> startGeneration({
    required String imageUrl,
    required SectorType sector,
    required PlatformType platform,
  }) async {
    state = const AsyncLoading();
    final useCase = ref.read(startGenerationUseCaseProvider);

    final result = await useCase.call(
      imageUrl: imageUrl,
      sector: sector,
      platform: platform,
    );

    result.fold(
      onSuccess: (generation) {
        state = AsyncData(generation);
        _watchStatus(generation.id);
      },
      onFailure: (error) => state = AsyncError(error, StackTrace.current),
    );
  }

  void _watchStatus(String generationId) {
    final repository = ref.read(generationRepositoryProvider);
    repository.watchGenerationStatus(generationId).listen((result) {
      result.fold(
        onSuccess: (gen) => state = AsyncData(gen),
        onFailure: (err) => state = AsyncError(err, StackTrace.current),
      );
    });
  }
}

final processingProvider = AsyncNotifierProvider<ProcessingNotifier, Generation?>(
  ProcessingNotifier.new,
);
```

---

## 7. Veritabanı Şeması — Supabase PostgreSQL

### 7.1 Genel Prensipler

- Tüm tablolarda **Row Level Security (RLS)** aktiftir.
- Her tabloda `id uuid default gen_random_uuid()` kullanılır (cuid yerine UUID).
- `user_id` kolonları `auth.users(id)` referansına bağlıdır (Supabase Auth ile entegre).
- Migrations `supabase/migrations/` klasöründe tutulur, Prisma ile üretilir.
- `updated_at` otomatik güncelleme için PostgreSQL trigger kullanılır.

### 7.2 Prisma Şeması

```prisma
// prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider  = "postgresql"
  url       = env("DATABASE_URL")        // Supabase connection string (pooler)
  directUrl = env("DIRECT_DATABASE_URL") // Supabase direct URL (migration için)
}

// ─── KULLANICILAR ─────────────────────────────────────────────────────────────
// auth.users Supabase tarafından yönetilir.
// Bu tablo uygulama verilerini tutar; auth.users ile 1:1 ilişkisi vardır.

model User {
  id          String     @id @db.Uuid           // Supabase auth.users id ile eşleşir
  email       String     @unique
  displayName String?    @map("display_name")
  avatarUrl   String?    @map("avatar_url")
  phone       String?
  sector      SectorType @default(other)
  language    Language   @default(tr)
  planType    PlanType   @default(free) @map("plan_type")
  creditsLeft Int        @default(5) @map("credits_left")
  createdAt   DateTime   @default(now()) @map("created_at")
  updatedAt   DateTime   @updatedAt @map("updated_at")

  generations  Generation[]
  subscription Subscription?
  payments     Payment[]
  brandKit     BrandKit?

  @@map("users")
}

// ─── ÜRETİMLER ────────────────────────────────────────────────────────────────

model Generation {
  id                String           @id @default(dbgenerated("gen_random_uuid()")) @db.Uuid
  userId            String           @map("user_id") @db.Uuid
  user              User             @relation(fields: [userId], references: [id], onDelete: Cascade)

  // Medya — Supabase Storage bucket URL'leri
  originalImagePath String           @map("original_image_path")  // uploads/{userId}/{filename}
  originalImageSize Int?             @map("original_image_size")  // bytes

  processedImagePath String?         @map("processed_image_path") // results/{userId}/{generationId}/image.webp
  videoPath          String?         @map("video_path")           // results/{userId}/{generationId}/video.mp4
  caption            String?         @db.Text
  hashtags           String[]        @default([])

  sector    SectorType
  platform  PlatformType
  status    GenerationStatus @default(pending)

  // AI Pipeline metadata
  imageModel    String? @map("image_model")   // "imagen-4-fast" | "flux-2-kontext"
  videoModel    String? @map("video_model")   // "seedance-2-fast" | "veo-3-lite"
  captionModel  String? @map("caption_model") // "claude-haiku-4-5"
  processingMs  Int?    @map("processing_ms")
  errorMessage  String? @map("error_message")

  // Seçenekler
  options Json @default("{}") // { generateVideo: true, imageStyle: "studio" }

  createdAt   DateTime  @default(now()) @map("created_at")
  completedAt DateTime? @map("completed_at")
  expiresAt   DateTime? @map("expires_at") // Storage TTL (30 gün sonra silinir)

  @@index([userId, createdAt(sort: Desc)])
  @@index([status, createdAt])
  @@map("generations")
}

// ─── MARKA KİTİ (YENİ) ────────────────────────────────────────────────────────
// Kullanıcının kaydettiği marka tercihleri — tüm üretimlerde kullanılır

model BrandKit {
  id              String  @id @default(dbgenerated("gen_random_uuid()")) @db.Uuid
  userId          String  @unique @map("user_id") @db.Uuid
  user            User    @relation(fields: [userId], references: [id], onDelete: Cascade)

  primaryColor    String? @map("primary_color")    // hex: "#6C3FC5"
  secondaryColor  String? @map("secondary_color")
  logoPath        String? @map("logo_path")         // Supabase Storage path
  preferredStyle  String? @map("preferred_style")   // "studio" | "lifestyle" | "outdoor"
  toneOfVoice     String? @map("tone_of_voice")     // "formal" | "casual" | "playful"

  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")

  @@map("brand_kits")
}

// ─── ÜRÜN HAFIZASI (YENİ) ─────────────────────────────────────────────────────
// Kullanıcının kaydettiği ürünler — tekrar işlemde otomatik doldurulur

model Product {
  id          String     @id @default(dbgenerated("gen_random_uuid()")) @db.Uuid
  userId      String     @map("user_id") @db.Uuid
  user        User       @relation(fields: [userId], references: [id], onDelete: Cascade)

  name        String
  price       Decimal?   @db.Decimal(10, 2)
  currency    String     @default("TRY")
  sector      SectorType
  description String?    @db.Text
  tags        String[]   @default([])
  thumbnailPath String?  @map("thumbnail_path")

  generationCount Int @default(0) @map("generation_count")

  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")

  @@index([userId])
  @@map("products")
}

// ─── ABONELİKLER ──────────────────────────────────────────────────────────────

model Subscription {
  id                 String    @id @default(dbgenerated("gen_random_uuid()")) @db.Uuid
  userId             String    @unique @map("user_id") @db.Uuid
  user               User      @relation(fields: [userId], references: [id], onDelete: Cascade)

  planType           PlanType  @map("plan_type")
  status             SubStatus @default(active)
  currentPeriodStart DateTime  @map("current_period_start")
  currentPeriodEnd   DateTime  @map("current_period_end")
  cancelAtPeriodEnd  Boolean   @default(false) @map("cancel_at_period_end")
  iyzicoSubRef       String?   @map("iyzico_sub_ref")

  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")

  @@map("subscriptions")
}

// ─── ÖDEMELER ─────────────────────────────────────────────────────────────────

model Payment {
  id            String        @id @default(dbgenerated("gen_random_uuid()")) @db.Uuid
  userId        String        @map("user_id") @db.Uuid
  user          User          @relation(fields: [userId], references: [id])

  amount        Decimal       @db.Decimal(10, 2)
  currency      String        @default("TRY")
  planType      PlanType      @map("plan_type")
  status        PaymentStatus @default(pending)
  iyzicoToken   String?       @map("iyzico_token")
  iyzicoPayRef  String?       @unique @map("iyzico_pay_ref")
  errorCode     String?       @map("error_code")

  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")

  @@index([userId, createdAt])
  @@map("payments")
}

// ─── ENUM'LAR ─────────────────────────────────────────────────────────────────

enum SectorType  { food textile electronics jewelry beauty furniture other }
enum PlatformType { instagram trendyol hepsiburada whatsapp web tiktok }

enum GenerationStatus {
  pending
  uploading_image
  processing_image
  processing_video
  generating_caption
  completed
  failed
  cancelled
}

enum PlanType { free starter pro enterprise }
enum Language { tr en ar }
enum SubStatus { active past_due cancelled trialing }
enum PaymentStatus { pending success failed refunded }
```

### 7.3 Supabase RLS Politikaları

```sql
-- supabase/migrations/20250510_rls_policies.sql

-- USERS tablosu
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Kullanıcı kendi profilini okuyabilir"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Kullanıcı kendi profilini güncelleyebilir"
  ON users FOR UPDATE
  USING (auth.uid() = id);

-- GENERATIONS tablosu
ALTER TABLE generations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Kullanıcı kendi üretimlerini okuyabilir"
  ON generations FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Backend service role tüm üretimleri yazabilir"
  ON generations FOR ALL
  USING (auth.role() = 'service_role');

-- BRAND_KITS tablosu
ALTER TABLE brand_kits ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Kullanıcı kendi marka kitini yönetir"
  ON brand_kits FOR ALL
  USING (auth.uid() = user_id);

-- PRODUCTS tablosu
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Kullanıcı kendi ürünlerini yönetir"
  ON products FOR ALL
  USING (auth.uid() = user_id);

-- SUBSCRIPTIONS tablosu
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Kullanıcı kendi aboneliğini okuyabilir"
  ON subscriptions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Backend service role abonelik yönetir"
  ON subscriptions FOR ALL
  USING (auth.role() = 'service_role');
```

### 7.4 Supabase Storage Bucket Yapısı

```
Buckets:

uploads/          (private)
  └── {userId}/
      └── {timestamp}_{filename}.jpg     # Kullanıcı yüklemeleri (geçici)

results/          (private, signed URL ile erişim)
  └── {userId}/
      └── {generationId}/
          ├── image.webp                 # İşlenmiş görsel
          └── video.mp4                 # Üretilen video

brand-kits/       (private)
  └── {userId}/
      └── logo.png                      # Marka logosu

Politikalar:
  - uploads: Yalnızca dosyanın sahibi yükleyebilir/okuyabilir
  - results: Yalnızca dosyanın sahibi okuyabilir (signed URL 24 saat geçerli)
  - brand-kits: Yalnızca dosyanın sahibi
```

### 7.5 PostgreSQL Index Stratejisi

```sql
-- Sık sorgulanan sütunlar için ek index'ler

-- Kullanıcının son üretimlerini listele
CREATE INDEX CONCURRENTLY idx_generations_user_created
  ON generations (user_id, created_at DESC);

-- Bekleyen AI jobları sıraya al
CREATE INDEX CONCURRENTLY idx_generations_pending
  ON generations (status, created_at ASC)
  WHERE status = 'pending';

-- Süresi dolan dosyaları temizle
CREATE INDEX CONCURRENTLY idx_generations_expires
  ON generations (expires_at)
  WHERE expires_at IS NOT NULL AND status = 'completed';

-- Ödeme iyzico referans araması
CREATE INDEX CONCURRENTLY idx_payments_iyzico_ref
  ON payments (iyzico_pay_ref)
  WHERE iyzico_pay_ref IS NOT NULL;

-- Ürün hafızası arama
CREATE INDEX CONCURRENTLY idx_products_user_sector
  ON products (user_id, sector);
```

### 7.6 Supabase Realtime Kurulumu

```sql
-- generations tablosunda Realtime aktif et
ALTER PUBLICATION supabase_realtime ADD TABLE generations;

-- Yalnızca status kolonunu yayınla (veri tasarrufu)
ALTER TABLE generations REPLICA IDENTITY DEFAULT;
```

---

## 8. API Sözleşmesi (Contract)

### 8.1 Temel Yapı

```
Base URL (Prod)  : https://api.snapkobi.com/v1
Base URL (Dev)   : http://localhost:3000/v1
Content-Type     : application/json
Auth             : Authorization: Bearer <supabase_access_token>
```

> Backend, Supabase JWT token'ını `supabase.auth.getUser(token)` ile doğrular.
> Ayrı bir JWT secret veya refresh mekanizmasına gerek yoktur.

#### Standart Yanıt Formatı

```typescript
// Başarılı
{ "success": true, "data": { ... }, "meta": { "page": 1, "limit": 20, "total": 157 } }

// Hata
{ "success": false, "error": { "code": "INSUFFICIENT_CREDITS", "message": "Krediniz yetersiz.", "details": { "creditsLeft": 0 } } }
```

### 8.2 Endpoint Listesi

```
USERS
  GET    /users/me                    # Mevcut kullanıcı profili
  PATCH  /users/me                    # Profil güncelle
  GET    /users/me/credits            # Kalan kredi

GENERATIONS
  POST   /generations                 # Yeni üretim başlat (AI pipeline tetikle)
  GET    /generations                 # Sayfalı geçmiş (cursor tabanlı)
  GET    /generations/:id             # Tek üretim detayı
  DELETE /generations/:id             # Üretim ve dosyaları sil

MEDIA
  POST   /media/upload-url            # Supabase Storage pre-signed upload URL

BRAND-KIT
  GET    /brand-kit                   # Mevcut marka kiti
  PUT    /brand-kit                   # Marka kiti kaydet/güncelle

PRODUCTS
  GET    /products                    # Ürün listesi
  POST   /products                    # Yeni ürün kaydet
  PATCH  /products/:id                # Ürün güncelle
  DELETE /products/:id                # Ürün sil

SUBSCRIPTIONS
  GET    /subscriptions/me            # Mevcut abonelik
  POST   /subscriptions               # Yeni abonelik başlat
  DELETE /subscriptions/me            # Abonelik iptal

PAYMENTS
  POST   /payments/intent             # iyzico ödeme niyeti
  GET    /payments                    # Ödeme geçmişi

WEBHOOKS
  POST   /webhooks/iyzico             # iyzico callback (imzalı)
  POST   /webhooks/ai-complete        # AI servis tamamlandı
```

### 8.3 Realtime — Supabase ile Durum Takibi

Flutter tarafı:
```dart
// lib/data/datasources/remote/supabase_generation_datasource.dart

Stream<GenerationModel> watchStatus(String generationId) {
  return _client
      .from('generations')
      .stream(primaryKey: ['id'])
      .eq('id', generationId)
      .map((rows) => GenerationModel.fromJson(rows.first));
}
```

Backend tarafı (AI tamamlanınca):
```typescript
// Prisma ile DB güncelle → Supabase Realtime otomatik yayınlar
await prisma.generation.update({
  where: { id: generationId },
  data: { status: 'completed', processedImagePath, videoPath, caption, completedAt: new Date() },
});
// Ayrıca notifyClient() veya Socket.io gerekmez — Supabase Realtime halleder
```

---

## 9. State Yönetimi — Riverpod

### 9.1 Provider Hiyerarşisi

```dart
// lib/core/di/providers.dart
// Tüm provider tanımları tek dosyada; feature başına değil.

// ── Supabase ──────────────────────────────────────────────────────────────────
final supabaseClientProvider = Provider<SupabaseClient>(
  (_) => Supabase.instance.client,
);

// ── DataSources ───────────────────────────────────────────────────────────────
final supabaseGenerationDsProvider = Provider<SupabaseGenerationDataSource>(
  (ref) => SupabaseGenerationDataSource(ref.watch(supabaseClientProvider)),
);

final backendGenerationDsProvider = Provider<BackendGenerationDataSource>(
  (ref) => BackendGenerationDataSource(ref.watch(dioClientProvider)),
);

// ── Repositories ──────────────────────────────────────────────────────────────
final generationRepositoryProvider = Provider<GenerationRepository>(
  (ref) => GenerationRepositoryImpl(
    supabaseDs: ref.watch(supabaseGenerationDsProvider),
    backendDs: ref.watch(backendGenerationDsProvider),
    localDs: ref.watch(generationLocalDsProvider),
  ),
);

// ── Use Cases ─────────────────────────────────────────────────────────────────
final startGenerationUseCaseProvider = Provider<StartGenerationUseCase>(
  (ref) => StartGenerationUseCase(ref.watch(generationRepositoryProvider)),
);

// ── Feature Notifiers ─────────────────────────────────────────────────────────
final processingProvider = AsyncNotifierProvider<ProcessingNotifier, Generation?>(
  ProcessingNotifier.new,
);

final historyProvider = AsyncNotifierProvider<HistoryNotifier, List<Generation>>(
  HistoryNotifier.new,
);
```

### 9.2 UI'da Kullanım Örneği

```dart
// lib/features/generation/processing/processing_screen.dart

class ProcessingScreen extends ConsumerWidget {
  const ProcessingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(processingProvider);

    // AsyncValue ile switch — ayrı isLoading/isError flag'i yok
    return state.when(
      loading: () => const ProcessingAnimationWidget(),
      error: (err, _) => ErrorDisplayWidget(
        error: err as AppError,
        onRetry: () => ref.invalidate(processingProvider),
      ),
      data: (generation) => generation == null
          ? const UploadPromptWidget()
          : generation.isCompleted
              ? ResultPreviewWidget(generation: generation)
              : ProcessingStepsWidget(generation: generation),
    );
  }
}
```

---

## 10. AI Pipeline Entegrasyonu

### 10.1 Backend Pipeline Orchestrator

```typescript
// src/ai/pipeline/pipeline.orchestrator.ts

export class PipelineOrchestrator {
  constructor(
    private readonly image: ImageProcessor,
    private readonly video: VideoProcessor,
    private readonly caption: CaptionProcessor,
    private readonly prisma: PrismaClient,
  ) {}

  async run(generationId: string): Promise<void> {
    const gen = await this.prisma.generation.findUniqueOrThrow({ where: { id: generationId } });

    try {
      await this.setStatus(generationId, 'processing_image');
      const processedImagePath = await this.image.process({
        originalPath: gen.originalImagePath,
        sector: gen.sector,
        platform: gen.platform,
        options: gen.options as GenerationOptions,
      });

      // Video ve metin paralel başlatılır
      await this.setStatus(generationId, 'processing_video');
      const [videoPath, { caption, hashtags }] = await Promise.all([
        this.video.process({ imagePath: processedImagePath, sector: gen.sector, platform: gen.platform }),
        this.caption.process({ imagePath: processedImagePath, sector: gen.sector, platform: gen.platform }),
      ]);

      // DB güncelleme → Supabase Realtime Flutter'a push eder
      await this.prisma.generation.update({
        where: { id: generationId },
        data: { processedImagePath, videoPath, caption, hashtags, status: 'completed', completedAt: new Date() },
      });

    } catch (error) {
      await this.prisma.generation.update({
        where: { id: generationId },
        data: { status: 'failed', errorMessage: (error as Error).message },
      });
      throw error;
    }
  }

  private setStatus(id: string, status: string) {
    return this.prisma.generation.update({ where: { id }, data: { status } });
    // Supabase Realtime bu değişikliği otomatik yayınlar
  }
}
```

### 10.2 Supabase Storage Entegrasyonu (Backend)

```typescript
// src/infrastructure/storage.service.ts

import { createClient } from '@supabase/supabase-js';

// service_role key — yalnızca backend'de, asla Flutter'da
const supabase = createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY);

export class StorageService {
  async uploadResult(userId: string, generationId: string, buffer: Buffer, type: 'image' | 'video') {
    const ext = type === 'image' ? 'webp' : 'mp4';
    const path = `${userId}/${generationId}/${type}.${ext}`;

    const { error } = await supabase.storage.from('results').upload(path, buffer, {
      contentType: type === 'image' ? 'image/webp' : 'video/mp4',
      upsert: true,
    });

    if (error) throw new Error(`Storage upload failed: ${error.message}`);
    return path;
  }

  async getSignedUrl(bucket: string, path: string, expiresIn = 86400): Promise<string> {
    const { data, error } = await supabase.storage.from(bucket).createSignedUrl(path, expiresIn);
    if (error) throw new Error(`Signed URL failed: ${error.message}`);
    return data.signedUrl;
  }
}
```

---

## 11. Tema & Tasarım Sistemi

### 11.1 Renk Paleti

```dart
// lib/core/theme/app_colors.dart
abstract class AppColors {
  static const Color primary        = Color(0xFF6C3FC5);
  static const Color primaryLight   = Color(0xFF9B6FE8);
  static const Color primaryDark    = Color(0xFF3A1A6A);
  static const Color primarySurface = Color(0xFFEDE7FF);

  static const Color neutral900 = Color(0xFF1A1A2E);
  static const Color neutral700 = Color(0xFF3A3A5C);
  static const Color neutral500 = Color(0xFF6B6B8A);
  static const Color neutral300 = Color(0xFFBBBBCC);
  static const Color neutral100 = Color(0xFFF5F3FF);

  static const Color success        = Color(0xFF22C55E);
  static const Color successSurface = Color(0xFFEBFBF0);
  static const Color warning        = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0xFFFEF3C7);
  static const Color error          = Color(0xFFEF4444);
  static const Color errorSurface   = Color(0xFFFEEBEB);

  static const Color white = Color(0xFFFFFFFF);
}
```

### 11.2 Supabase Constants

```dart
// lib/core/constants/supabase_constants.dart
abstract class SupabaseConstants {
  // Tablo adları
  static const String usersTable         = 'users';
  static const String generationsTable   = 'generations';
  static const String productsTable      = 'products';
  static const String brandKitsTable     = 'brand_kits';
  static const String subscriptionsTable = 'subscriptions';
  static const String paymentsTable      = 'payments';

  // Storage bucket adları
  static const String uploadsBucket   = 'uploads';
  static const String resultsBucket   = 'results';
  static const String brandKitBucket  = 'brand-kits';

  // Realtime
  static const String generationsChannel = 'generations';
}
```

---

## 12. Constants & Utilities

### 12.1 API Constants (Backend)

```dart
// lib/core/constants/api_constants.dart
abstract class ApiConstants {
  static const String _baseUrlProd = 'https://api.snapkobi.com/v1';
  static const String _baseUrlDev  = 'http://localhost:3000/v1';

  static String get baseUrl =>
      const bool.fromEnvironment('dart.vm.product') ? _baseUrlProd : _baseUrlDev;

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 60);

  static const String generations    = '/generations';
  static const String mediaUploadUrl = '/media/upload-url';
  static const String usersMe        = '/users/me';
  static const String brandKit       = '/brand-kit';
  static const String products       = '/products';
  static const String subscriptionsMe = '/subscriptions/me';
  static const String paymentIntent  = '/payments/intent';

  static const int defaultPageSize = 20;
  static const int maxRetryAttempts = 3;
}
```

### 12.2 App Constants

```dart
// lib/core/constants/app_constants.dart
abstract class AppConstants {
  static const String appName      = 'SnapKOBİ';
  static const String appVersion   = '1.1.0';
  static const String bundleId     = 'com.snapkobi.app';
  static const String supportEmail = 'destek@snapkobi.com';

  static const int maxImageSizeBytes    = 10 * 1024 * 1024;  // 10 MB
  static const int targetImageSizeBytes = 2  * 1024 * 1024;  // 2 MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp', 'heic'];

  // Kredi limitleri (PlanType ile senkron tutulmalı)
  static const int freeMonthlyCredits    = 5;
  static const int starterMonthlyCredits = 15;
  static const int proMonthlyCredits     = 60;

  // Fiyatlar
  static const double starterPriceMonthly = 99.0;
  static const double proPriceMonthly     = 249.0;

  // Cache TTL
  static const Duration userCacheTtl    = Duration(hours: 1);
  static const Duration historyCacheTtl = Duration(minutes: 5);

  // Animasyonlar
  static const Duration animFast   = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 250);
  static const Duration animSlow   = Duration(milliseconds: 400);
}
```

---

## 13. Güvenlik & Auth

### 13.1 Supabase Auth Akışı

```
1. Kullanıcı → Google/Apple Sign-In → Supabase Auth
2. Supabase → access_token + refresh_token döner
3. supabase_flutter → token'ları güvenli depolar (platform keychain/keystore)
4. Flutter → Dio interceptor → Her istekte supabase.auth.currentSession!.accessToken
5. Backend → supabase.auth.getUser(token) ile doğrular
6. Token süresi dolunca → supabase_flutter otomatik yeniler (refresh)
7. Supabase session bitince → GoRouter auth guard login'e yönlendirir

Güvenlik Notları:
  - service_role key asla Flutter koduna girmez (yalnızca backend .env)
  - anon key Flutter'da kullanılır; RLS ile sınırlandırılmıştır
  - Tüm medya erişimi signed URL (24 saat geçerli)
  - Flutter'da doğrudan DB yazma işlemi yoktur (yalnızca okuma + Realtime)
  - Tüm yazma işlemleri backend API üzerinden geçer
```

### 13.2 Backend Auth Middleware

```typescript
// src/middleware/auth.middleware.ts

export async function authMiddleware(request: FastifyRequest, reply: FastifyReply) {
  const token = request.headers.authorization?.replace('Bearer ', '');
  if (!token) return reply.status(401).send({ success: false, error: { code: 'UNAUTHORIZED' } });

  const { data: { user }, error } = await supabase.auth.getUser(token);
  if (error || !user) return reply.status(401).send({ success: false, error: { code: 'INVALID_TOKEN' } });

  request.userId = user.id; // FastifyRequest'e eklenir
}
```

### 13.3 Rate Limiting

```typescript
// src/app.ts
const rateLimits = {
  '/v1/generations':  { max: 10,  window: '1m' },
  '/v1/media/*':      { max: 20,  window: '1m' },
  '/v1/auth/*':       { max: 5,   window: '1m' },
  'default':          { max: 100, window: '1m' },
};
```

---

## 14. Hata Yönetimi

### 14.1 Result Pattern

```dart
// lib/core/errors/app_error.dart

sealed class AppError {
  final String message;
  final String code;
  const AppError({required this.message, required this.code});
}

class NetworkError extends AppError {
  final int? statusCode;
  const NetworkError({required super.message, super.code = 'NETWORK_ERROR', this.statusCode});

  factory NetworkError.fromDio(DioException e) => NetworkError(
    message: e.response?.data?['error']?['message'] ?? 'Bağlantı hatası.',
    statusCode: e.response?.statusCode,
    code: e.response?.data?['error']?['code'] ?? 'NETWORK_ERROR',
  );
}

class AuthError              extends AppError { const AuthError({required super.message, super.code = 'AUTH_ERROR'}); }
class InsufficientCreditsError extends AppError { const InsufficientCreditsError() : super(message: 'Krediniz yetersiz.', code: 'INSUFFICIENT_CREDITS'); }
class AiProcessingError      extends AppError { const AiProcessingError({required super.message, super.code = 'AI_ERROR'}); }
class ValidationError        extends AppError { const ValidationError(String msg) : super(message: msg, code: 'VALIDATION_ERROR'); }
class StorageError           extends AppError { const StorageError({required super.message, super.code = 'STORAGE_ERROR'}); }

sealed class Result<T> {
  const Result();
  factory Result.success(T data) = Success<T>;
  factory Result.failure(AppError error) = Failure<T>;

  bool get isSuccess => this is Success<T>;

  R fold<R>({ required R Function(T) onSuccess, required R Function(AppError) onFailure }) =>
      switch (this) {
        Success(:final data)   => onSuccess(data),
        Failure(:final error)  => onFailure(error),
      };
}

class Success<T> extends Result<T> { final T data;        const Success(this.data); }
class Failure<T> extends Result<T> { final AppError error; const Failure(this.error); }
```

---

## 15. Test Stratejisi

```
Unit Tests   → domain/usecases + data/repositories (mock datasource ile)
Widget Tests → shared/widgets + feature/widgets (mock provider ile)
Integration  → auth_flow, generation_flow (Supabase local ile)

Kural: Her public usecase'in en az 2 testi olmalı:
  - Başarılı senaryo
  - Hata senaryosu (en az 1)

Test coverage hedefi: domain katmanı %80+, data katmanı %60+
```

---

## 16. CI/CD & Deploy

### 16.1 GitHub Actions

```yaml
# .github/workflows/flutter-ci.yml
name: Flutter CI
on:
  push:
    branches: [main, develop]
    paths: ['snapkobi-flutter/**']  # Yalnızca Flutter değişimlerinde çalışır

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.22.x', channel: 'stable' }
      - run: flutter pub get
        working-directory: snapkobi-flutter
      - run: flutter analyze
        working-directory: snapkobi-flutter
      - run: flutter test --coverage
        working-directory: snapkobi-flutter
```

```yaml
# .github/workflows/backend-ci.yml
name: Backend CI
on:
  push:
    branches: [main, develop]
    paths: ['snapkobi-backend/**']  # Yalnızca backend değişimlerinde çalışır

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      redis:
        image: redis:7
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm ci
        working-directory: snapkobi-backend
      - run: npm test
        working-directory: snapkobi-backend
        env:
          DATABASE_URL: ${{ secrets.SUPABASE_DATABASE_URL }}
          SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: railway up
        working-directory: snapkobi-backend
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
```

### 16.2 Ortam Yönetimi

```
development  → Supabase local (npx supabase start) + Imagen AI Studio (ücretsiz) + Kling free
staging      → Supabase remote (staging project) + gerçek AI servisleri + test kredileri
production   → Supabase remote (prod project) + ücretli AI servisleri

Flutter build flavor:
  flutter run --dart-define=ENVIRONMENT=development
  flutter build apk --dart-define=ENVIRONMENT=production

Backend:
  NODE_ENV=development  → Supabase local, AI mock
  NODE_ENV=staging      → Supabase staging project
  NODE_ENV=production   → Supabase prod project
```

---

## 17. Geliştirici Kuralları

### 17.1 Commit Konvansiyonları

```
format: <type>(<scope>): <kısa açıklama>

Types: feat | fix | refactor | test | docs | style | chore

Örnekler:
  feat(generation): Supabase Realtime durum takibi eklendi
  fix(auth): Supabase session refresh iOS crash düzeltildi
  refactor(home): ImageUploadZone widget ayrı dosyaya taşındı
  chore(deps): supabase_flutter 2.5.3'e güncellendi
```

### 17.2 Branch Stratejisi

```
main       → Üretim. Doğrudan commit yasak. PR + review zorunlu.
develop    → Geliştirme ana dalı.
feature/*  → Yeni özellikler.  Örn: feature/brand-kit
fix/*      → Hata düzeltme.    Örn: fix/supabase-realtime-reconnect
release/*  → Sürüm hazırlığı.  Örn: release/1.1.0
hotfix/*   → Acil prod düzeltme.
```

### 17.3 Pull Request Şablonu

```markdown
## Değişiklikler
- [ ] Ne değişti ve neden?
- [ ] Hangi dosyalar etkilendi?

## Supabase Etkisi
- [ ] Yeni migration var mı? (varsa `supabase/migrations/` güncellendi)
- [ ] RLS politikası değişti mi?
- [ ] Yeni bucket veya tablo eklendi mi?

## Test
- [ ] Unit testler yazıldı / güncellendi
- [ ] Manuel test: iOS + Android
- [ ] Supabase local ortamda çalışıyor

## Checklist
- [ ] `flutter analyze` hata yok
- [ ] `flutter test` geçiyor
- [ ] Hardcode renk/string/değer yok
- [ ] AI slop yok (gereksiz yorum, dead code, unused state)
- [ ] Widget 80 satırı geçmiyor
```

---

## Hızlı Başlangıç — Yeni Geliştirici

```bash
# 1. Repoyu klonla
git clone https://github.com/snapkobi/snapkobi.git
cd snapkobi

# ── Flutter ──────────────────────────────────────────────────────────────────
cd snapkobi-flutter
flutter pub get
cp .env.example .env                  # Supabase URL + anon key doldur
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=ENVIRONMENT=development

# ── Backend ──────────────────────────────────────────────────────────────────
cd ../snapkobi-backend
npm install
cp .env.example .env                  # Supabase URL, service_role key, AI key'ler doldur

# ── Supabase Local ───────────────────────────────────────────────────────────
cd ..
npx supabase start                    # Lokal PostgreSQL + Auth + Storage başlar
npx supabase db push                  # Migration'ları uygula

# Backend'i başlat
cd snapkobi-backend
npx prisma generate
npm run dev
```

**Ortam Değişkenleri (.env.example)**

```bash
# snapkobi-flutter/.env
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
BACKEND_URL=http://localhost:3000

# snapkobi-backend/.env
DATABASE_URL=postgresql://postgres:password@localhost:54322/postgres
DIRECT_DATABASE_URL=postgresql://postgres:password@localhost:54322/postgres
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJ...  # Asla Flutter'a verme
GOOGLE_AI_API_KEY=...
ANTHROPIC_API_KEY=...
REPLICATE_API_KEY=...
UPSTASH_REDIS_URL=...
IYZICO_API_KEY=...
IYZICO_SECRET_KEY=...
NODE_ENV=development
```

---

> **Bu doküman yaşayan bir belgedir.**
> Mimari değişiklik alındığında `docs(arch):` prefix'li commit ile güncellenir.
>
> **SnapKOBİ Ekibi** | snapkobi.com
