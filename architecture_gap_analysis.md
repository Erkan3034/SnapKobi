# SnapKOBİ — Mimari ve Akış Uyuşmazlığı Analiz Raporu (Gap Analysis)

Bu rapor, [app_architect.md](file:///c:/yedekler/SnapKobi/SnapKOBI/app_architect.md) mimari tasarım dokümanı ile Flutter (`SnapKOBI`) ve Node.js (`snapkobi-backend`) projelerinin mevcut gerçek kod uygulamaları arasındaki tüm **hata, uyuşmazlık, eksiklik ve güvenlik açıklarını** detaylıca listeler.

---

## 1. 📂 Boş ve İskelet Dosyalar (Skeleton Files)

Uygulamanın çalışmasını doğrudan engelleyen veya mimariye uymayan çok sayıda 0 byte (tamamen boş) dosya tespit edilmiştir:

### 📱 Flutter (SnapKOBI)
- **[generation.dart](file:///c:/yedekler/SnapKobi/SnapKOBI/lib/domain/entities/generation.dart) [0 byte - Boş]:** Domain katmanındaki en kritik entity olan `Generation` sınıfı ve enumu (`GenerationStatus` vb.) taslak aşamasında kalmış, içi doldurulmamıştır.
- **[generation_model.dart](file:///c:/yedekler/SnapKobi/SnapKOBI/lib/data/models/generation_model.dart) [0 byte - Boş]:** Serialization (`fromJson`/`toJson`) ve veri dönüşümleri için kullanılması planlanan model sınıfı boştur.
- **[api_error_model.dart](file:///c:/yedekler/SnapKobi/SnapKOBI/lib/data/models/api_error_model.dart) [0 byte - Boş]:** Standart API hatalarını karşılayacak model bulunmamaktadır.
- **[subscription_model.dart](file:///c:/yedekler/SnapKobi/SnapKOBI/lib/data/models/subscription_model.dart) [0 byte - Boş]:** Abonelik veri modeli boştur.

### 💻 Backend (snapkobi-backend)
- **Çift Klasör Kirliliği (`generations` vs `generation`):** 
  - `src/modules/generations` (çoğul) altındaki [generations.service.ts](file:///c:/yedekler/SnapKobi/snapkobi-backend/src/modules/generations/generations.service.ts), `generations.controller.ts`, `generations.routes.ts` gibi tüm dosyalar **0 byte ve boştur.**
  - Gerçek kodlar ise tekil olan `src/modules/generation/` altındadır. Bu durum proje içerisinde kafa karışıklığı yaratmaktadır.
- **AI Servis Sağlayıcıları [0 byte - Boş]:**
  - [claude.provider.ts](file:///c:/yedekler/SnapKobi/snapkobi-backend/src/ai/providers/claude.provider.ts)
  - [flux.provider.ts](file:///c:/yedekler/SnapKobi/snapkobi-backend/src/ai/providers/flux.provider.ts)
  - [imagen.provider.ts](file:///c:/yedekler/SnapKobi/snapkobi-backend/src/ai/providers/imagen.provider.ts)
  - [seedance.provider.ts](file:///c:/yedekler/SnapKobi/snapkobi-backend/src/ai/providers/seedance.provider.ts)
  *(Sadece Pollinations, Gemini ve Fal/Kaiber entegrasyonları kısmen uygulanmıştır).*

---

## 2. 🏗️ Clean Architecture & SOLID Uyuşmazlıkları

Tasarım belgesinde üzerine basılarak anlatılan Clean Architecture kurallarının neredeyse tamamı gerçek kodda ihlal edilmiştir:

### A. Tip Güvenli Entity Yerine `Map<String, dynamic>` Kullanımı
- **Uyuşmazlık:** Dokümanda tüm veri akışının `Generation` entity'si üzerinden `Result<Generation>` sarmalıyla yapılması gerektiği söylenirken, [generation_repository.dart](file:///c:/yedekler/SnapKobi/SnapKOBI/lib/domain/repositories/generation_repository.dart) ve impl dosyasında ham Map'ler (`Map<String, dynamic>`) dönülmektedir:
  ```dart
  Stream<Map<String, dynamic>> monitorGeneration(String id);
  Future<Map<String, dynamic>> getGenerationDetails(String id);
  ```
- **Sonuç:** UI ve Domain katmanları veri yapısına sıkı sıkıya (tightly-coupled) bağlanmış, Flutter'ın tip güvenliği (type-safety) avantajı yok edilmiştir.

### B. Riverpod State ve Notifier Yapısı İhlali
- **Uyuşmazlık (Dosya Düzeni):** Dokümana göre tüm global sağlayıcılar (Providers) [providers.dart](file:///c:/yedekler/SnapKobi/SnapKOBI/lib/core/di/providers.dart) içinde tanımlanmalıdır. Ancak `processingProvider` ve `historyProvider` bu dosyada yer almamaktadır; feature klasörlerinde lokal kalmışlardır.
- **Uyuşmazlık (Notifier Seçimi):** Doküman `StateNotifier` yerine modern ve güvenli olan `AsyncNotifier` (AsyncValue otomatik yönetimi için) kullanılmasını emrederken, [processing_provider.dart](file:///c:/yedekler/SnapKobi/SnapKOBI/lib/features/generation/processing/processing_provider.dart) içinde eski `StateNotifier` kullanılmış ve state yönetimi manuel `ProcessingState` sarmalıyla yapılmıştır.

### C. Pipeline Orchestrator Mimari Farkı
- **Uyuşmazlık:** Dokümanda `PipelineOrchestrator` sınıfının SOLID prensiplerine uygun olarak `ImageProcessor`, `VideoProcessor` ve `CaptionProcessor` interface'lerini Dependency Injection (PrismaClient ile beraber) yoluyla alıp çalıştıracağı belirtilmiştir.
- **Gerçek:** [pipeline.orchestrator.ts](file:///c:/yedekler/SnapKobi/snapkobi-backend/src/ai/pipeline/pipeline.orchestrator.ts) dosyası tek bir bağımsız fonksiyondan (`runGenerationPipeline`) oluşmaktadır. Soyutlama (abstraction) yerine doğrudan Fal/Kaiber, Gemini ve Pollinations entegrasyonlarına sıkı sıkıya bağlanmıştır.

---

## 3. 🚦 Broken UI & State Akış Hataları (Çalışmayan Akışlar)

Kullanıcının uygulamada üretim yapmasını ve sonuçları görmesini tamamen engelleyen kritik mantık hataları bulunuyor:

### A. State Çakışması ve Senkronizasyon Kaybı (`homeProvider` vs `createProvider`)
- **Hata:** Projede iki adet birebir aynı işi yapan provider bulunmaktadır:
  1. `lib/features/home/home_provider.dart` (`homeProvider` -> `HomeState`)
  2. `lib/features/create/create_provider.dart` (`createProvider` -> `CreateState`)
- **Kopukluk:** 
  - `HomeScreen` tüm görsel seçimlerini ve platform değişikliklerini `homeProvider` üzerine yazar.
  - Ancak `ProcessingScreen` (üretim ekranı) `initState` anında verileri gidip `createProvider` üzerinden okumaya çalışır:
    ```dart
    final create = ref.read(createProvider);
    final path = create.selectedImagePath; // Bu her zaman NULL gelecektir!
    ```
  - Bu yüzden `ProcessingScreen` görsel yolunu hiçbir zaman yakalayamaz ve gerçek üretimi (`startRealGeneration`) asla tetikleyemez!

### B. HomeScreen "Ölü Kod" (Dead Code) Durumu
- **Hata:** `HomeScreen` sınıfı (`lib/features/home/home_screen.dart`) tasarlanmış olmasına rağmen, uygulamanın ana iskeleti olan [MainScaffold](file:///c:/yedekler/SnapKobi/SnapKOBI/lib/shared/widgets/layout/main_scaffold.dart) içinde rota veya tab olarak **yer almamaktadır.**
- **Detay:** Uygulamanın 0. indexteki ana tabı `DiscoverScreen`'dir. Üretim ise FAB (Artı butonu) aracılığıyla doğrudan `CreateScreen`'e yönlendirilerek yapılır. Dolayısıyla `HomeScreen` ve onun `homeProvider`'ı tamamen kullanılmayan ölü koddur.

### C. HomeScreen SubmitButton Tetiklenmiyor
- **Hata:** Eğer bir şekilde `HomeScreen` aktif olsaydı bile, `SubmitButton`'ın `onTap` callback'i `() {}` (boş fonksiyon) olarak verilmiştir:
  ```dart
  SubmitButton(isEnabled: hasImg, onTap: () {}), // HomeScreen:L95
  ```
  Bu sebeple butona tıklamak hiçbir sayfaya yönlendirmez veya işlem başlatmaz. (Not: `CreateScreen` üzerinde bu buton düzgünce `/processing` rotasına yönlendirmektedir).

---

## 4. 🔒 Güvenlik & Altyapı Hataları (Kritik Açıklar)

Canlı ortamda (Production) felakete yol açabilecek seviyede altyapısal ve güvenlik uyuşmazlıkları tespit edilmiştir:

### A. Gizli Olması Gereken storage Bucket'ının Public Yapılması ve Mismatch
- **Doküman Kuralı (Bölüm 7.4):** Yüklenen ve üretilen tüm medyalar private olmalıdır. Erişim yalnızca 24 saat geçerli **Signed URL** aracılığıyla sağlanmalıdır. Bucket adları: `uploads` (private), `results` (private), `brand-kits` (private) olmalıdır.
- **Gerçek Kod (Hata):** [storage.helper.ts](file:///c:/yedekler/SnapKobi/snapkobi-backend/src/ai/providers/storage.helper.ts) içerisinde tek bir public storage bucket'ı oluşturulup kullanılmaktadır:
  ```typescript
  await supabase.storage.createBucket('generations', { public: true });
  ```
  Ve dosyalara doğrudan `getPublicUrl` ile kalıcı public bağlantılar verilmektedir. Bu durum tüm kullanıcı görsellerini ve AI sonuçlarını internete açık hale getirerek ciddi bir gizlilik ihlali oluşturur.
- **Flutter Uyuşmazlığı:** Flutter tarafındaki [supabase_storage_datasource.dart](file:///c:/yedekler/SnapKobi/SnapKOBI/lib/data/datasources/remote/supabase_storage_datasource.dart) da dokümandaki `uploads` bucket'ı yerine backend ile uyumlu olması için `'generations'` bucket'ına yükleme yapmaktadır.

### B. Backend Supabase Client Güvenlik Kusuru (`service_role` vs `anon`)
- **Doküman Kuralı:** Backend, RLS (Row Level Security) kurallarını aşabilmek için `service_role` gizli anahtarını (asla Flutter'a sızdırılmamalıdır) kullanmalıdır.
- **Gerçek Kod (Kritik Uyuşmazlık):** [supabase.ts](file:///c:/yedekler/SnapKobi/snapkobi-backend/src/config/supabase.ts) içinde backend istemcisi hatalı olarak `env.SUPABASE_ANON_KEY` (anonim anahtar) ile başlatılmıştır:
  ```typescript
  export const supabase = createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY, ...);
  ```
  Bu durum backend'in diğer kullanıcı verilerine erişmesini ve yetkili PostgreSQL işlemlerini yapmasını engeller, veritabanında RLS hatalarına sebep olur.

### C. Supabase & Prisma Veritabanı Migrations Eksikliği
- **Doküman Kuralı:** Migrations `supabase/migrations/` altında saklanır ve Prisma şemasından üretilerek db push ile uygulanır.
- **Gerçek:** Hem `supabase/migrations/` klasörü hem de backend `prisma` klasörü altı tamamen boştur (yalnızca `.gitkeep` ve bir iki SQL scripti vardır). Gerçek SQL migration dosyaları oluşturulmamış ve Supabase şeması hazırlanmamıştır.

### D. Ücretsiz/Sınırsız Kredi Sızıntısı (Lazy Provisioning Leak)
- **Uyuşmazlık:** Backend auth middleware'inde ([auth.middleware.ts](file:///c:/yedekler/SnapKobi/snapkobi-backend/src/middleware/auth.middleware.ts)) veritabanında bulunmayan yeni bir kullanıcı ilk kez istek attığında lazy provisioning ile otomatik olarak **Pro** plana atanıp kendisine **999.999** kredi tanımlanmaktadır:
  ```typescript
  planType: 'pro',
  creditsLeft: 999999,
  ```
  Bu durum dokümandaki ücretsiz kullanıcılara 5, pro kullanıcılara 60 kredi limit kurallarıyla tamamen çelişmektedir. Muhtemelen test amaçlı eklenmiş ama unutulmuştur.

---

## 5. 📊 Özet Değerlendirme Tablosu

| Konu Başlığı | Tasarlanan (app_architect.md) | Gerçekleşen (Kod Tabanı) | Durum |
| :--- | :--- | :--- | :--- |
| **Model/Entity Tipleri** | `Result<Generation>` ve tip güvenli sınıflar | Ham `Map<String, dynamic>` tipleri | ❌ Uyuşmazlık |
| **Riverpod Notifier** | `AsyncNotifier` (Otomatik AsyncValue yönetimi) | `StateNotifier` + manuel simülasyon | ❌ Uyuşmazlık |
| **Storage Bucket Gizliliği** | `uploads` ve `results` (Private + Signed URL) | `generations` (Public + getPublicUrl) | ⚠️ Güvenlik Riski |
| **Backend Supabase Yetkisi**| `SUPABASE_SERVICE_ROLE_KEY` ile tam yetki | `SUPABASE_ANON_KEY` ile kısıtlı yetki | ❌ Hata |
| **Uygulama Akış Bütünlüğü** | Tek bir akış üzerinden üretim tetikleme | İki ayrı provider (`home` & `create`) arası kopukluk | ❌ Çalışmıyor |
| **Kullanıcı Kredi Başlangıcı** | Ücretsiz plan için 5 kredi limiti | Lazy provisioning ile 999.999 Pro kredisi | ❌ Çelişki |
| **Database Migrations** | `supabase/migrations` altında sürüm kontrolü | Klasör boş, yerel veritabanı şeması yok | ❌ Eksik |
