# SnapKOBİ — UI/UX Design Specification

---

## 0. Bu Dosyayı Nasıl Kullanacaksınız

Bu doküman, **Google Stitch** (stitch.google) üzerinde SnapKOBİ uygulamasının tüm ekranlarını tasarlamak için hazırlanmıştır. Her ekran bölümü bağımsız bir Stitch prompt'u olarak kullanılabilir. Ekranları sırayla işleyin; her promptun başına şu global bağlamı ekleyin:

```
App: SnapKOBİ — AI destekli ürün içerik üretici, Türk esnafı için.
Platform: Flutter mobil (iOS + Android), Material Design 3.
Tema: Menekşe (#6C3FC5) + Koyu Menekşe (#3A1A6A) + Beyaz (#FFFFFF) + Açık Gri (#F5F3FF).
Tipografi: Google Fonts — Nunito (başlıklar, yuvarlak, sıcak), Rubik (gövde, okunaklı).
Kullanıcı kitlesi: 35–55 yaş arası Türk esnafı, düşük teknoloji yetkinliği, mobil öncelikli.
Tasarım tonu: Güven verici, sıcak, sade, yönlendirici — asla karmaşık veya soğuk değil.
```

---

## 1. Tasarım Sistemi (Design Tokens)

### 1.1 Renk Paleti

| Token | Hex | Kullanım |
|---|---|---|
| `primary` | `#6C3FC5` | Ana butonlar, seçili durumlar, vurgu |
| `primaryDark` | `#3A1A6A` | Header arka planı, koyu aksanlar |
| `primaryLight` | `#EDE7FF` | Buton arka planı (secondary), kart vurgusu |
| `surface` | `#FFFFFF` | Kart ve sayfa arka planı |
| `background` | `#F5F3FF` | Sayfa genel arka planı (hafif mor ton) |
| `onPrimary` | `#FFFFFF` | Primary buton üzeri metin |
| `onSurface` | `#1A1A2E` | Ana metin |
| `onSurfaceVariant` | `#5A5A7A` | İkincil metin, placeholder |
| `success` | `#22C55E` | İşlem tamamlandı, başarı |
| `warning` | `#F59E0B` | İşlem devam ediyor |
| `error` | `#EF4444` | Hata durumları |
| `divider` | `#E8E4F5` | Ayırıcı çizgiler |

### 1.2 Tipografi Hiyerarşisi

| Stil | Font | Boyut | Ağırlık | Kullanım |
|---|---|---|---|---|
| `displayLarge` | Nunito | 32sp | Bold (700) | Onboarding başlıkları |
| `displayMedium` | Nunito | 26sp | Bold (700) | Ekran başlıkları |
| `headlineMedium` | Nunito | 20sp | SemiBold (600) | Bölüm başlıkları |
| `titleLarge` | Nunito | 18sp | SemiBold (600) | Kart başlıkları |
| `bodyLarge` | Rubik | 16sp | Regular (400) | Ana içerik metni |
| `bodyMedium` | Rubik | 14sp | Regular (400) | Açıklamalar |
| `labelLarge` | Rubik | 15sp | Medium (500) | Buton metni |
| `labelSmall` | Rubik | 11sp | Medium (500) | Chip, badge |

### 1.3 Spacing & Radius

```
spacing-xs:   4dp
spacing-sm:   8dp
spacing-md:   16dp
spacing-lg:   24dp
spacing-xl:   32dp
spacing-xxl:  48dp

radius-sm:    8dp   (small chips, badges)
radius-md:    12dp  (input fields)
radius-lg:    16dp  (cards)
radius-xl:    24dp  (bottom sheets, modals)
radius-full:  999dp (pills, FAB)
```

### 1.4 Elevation & Shadow

```
card-shadow:    0dp 2dp 8dp rgba(108,63,197,0.08)
modal-shadow:   0dp 8dp 32dp rgba(108,63,197,0.16)
button-shadow:  0dp 4dp 12dp rgba(108,63,197,0.30)
```

### 1.5 İkon Seti

**Material Symbols Rounded** kullanın (filled varyant). Öne çıkan ikonlar:

- `photo_camera` — Fotoğraf çek
- `photo_library` — Galeriden seç
- `auto_fix_high` — AI işleme
- `videocam` — Video
- `text_fields` — Metin
- `share` — Paylaş
- `download` — İndir
- `history` — Geçmiş
- `workspace_premium` — Premium plan
- `storefront` — Mağaza / esnaf profili
- `check_circle` — Başarı
- `hourglass_top` — İşlem devam ediyor

---

## 2. Ekranlar — Stitch Promptları

---

### Ekran 1: Splash Screen

**Stitch Prompt:**
```
Flutter splash screen for SnapKOBİ app.
Background: deep purple gradient from #3A1A6A (top) to #6C3FC5 (bottom), full screen.
Center layout, vertically stacked:
- App logo: rounded white square (80x80dp, radius 20dp) with a stylized camera+sparkle icon in purple (#6C3FC5). Add subtle white glow effect.
- Below logo (24dp gap): "SnapKOBİ" text in Nunito Bold 32sp, white color.
- Below name (8dp gap): "Esnafın AI İçerik Asistanı" in Rubik Regular 15sp, white at 70% opacity.
- Bottom area: linear progress indicator in white at 30% opacity, 240dp wide.
- Very bottom: "snapkobi.com" in Rubik 12sp, white at 50% opacity.
No status bar visible, immersive mode. Smooth fade-in animation on all elements.
```

---

### Ekran 2: Onboarding — Hoş Geldiniz (Sayfa 1/3)

**Stitch Prompt:**
```
Flutter onboarding screen, page 1 of 3 for SnapKOBİ app.
Full screen, background color #F5F3FF.

Top area (40% of screen): Large rounded rectangle card (#6C3FC5, radius 32dp, full width, no horizontal margin) containing an illustration. The illustration shows: a smartphone taking a photo of a simple product (a shoe), then a magic sparkle arrow pointing right, then the same shoe on a clean white studio background — a before/after concept. Illustration style: flat, friendly, colorful. White elements on purple card.

Bottom area (60% of screen):
- Page indicator dots: 3 dots, first dot is filled purple (#6C3FC5, 24dp wide pill), others are light grey (8dp circles). Centered horizontally.
- 12dp gap
- Title: "Ürününü Çek, Gerisini Biz Hallederiz" in Nunito Bold 26sp, color #1A1A2E, centered, max 2 lines.
- 12dp gap
- Body text: "Telefon kameranla çektiğin sıradan fotoğrafı profesyonel satış görseline dönüştürüyoruz. Fotoğrafçı gerekmez, teknik bilgi gerekmez." in Rubik Regular 15sp, color #5A5A7A, centered, 32dp horizontal padding.
- Spacer (flex)
- Full-width primary button (horizontal margin 24dp, height 56dp, radius 16dp, background #6C3FC5, drop shadow): "Başlayalım →" in Rubik Medium 16sp white.
- 12dp gap
- Text button: "Zaten hesabım var, giriş yap" in Rubik Medium 14sp, color #6C3FC5.
- Bottom safe area padding.
```

---

### Ekran 3: Onboarding — Sektör Seçimi (Sayfa 2/3)

**Stitch Prompt:**
```
Flutter onboarding screen, page 2 of 3: sector selection for SnapKOBİ.
Background color #F5F3FF.

Top bar: back arrow icon (left), page indicator dots centered (second dot active/filled purple), skip text right.

Title section (top, 32dp padding):
- "Hangi Sektördesiniz?" Nunito Bold 24sp, #1A1A2E
- Subtitle: "Size özel AI ayarları için sektörünüzü seçin" Rubik 14sp #5A5A7A

Grid layout (2 columns, 16dp gap, 24dp horizontal padding):
6 sector selection cards, each card:
- Rounded rectangle, 100% column width, height 110dp, radius 16dp
- Default state: white background, #E8E4F5 border (1dp), card shadow
- Selected state: #EDE7FF background, #6C3FC5 border (2dp), purple checkmark badge top-right
- Card content: large emoji icon centered top (40dp), sector name Nunito SemiBold 15sp #1A1A2E centered bottom

Cards (emoji + label):
1. 🍔 Gıda & Yiyecek
2. 👗 Tekstil & Moda
3. 💍 Takı & Aksesuar
4. 📱 Elektronik
5. 🌿 Kozmetik & Bakım
6. 📦 Diğer

Below grid (24dp gap): "Birden fazla seçebilirsiniz" Rubik 12sp #5A5A7A italic, centered.

Bottom: Full-width primary button "Devam Et →" (disabled/grey until at least 1 selected, then #6C3FC5 active). Height 56dp, radius 16dp, 24dp margins.
```

---

### Ekran 4: Onboarding — Hesap Oluştur (Sayfa 3/3)

**Stitch Prompt:**
```
Flutter onboarding screen, page 3 of 3: account creation for SnapKOBİ.
Background #F5F3FF. Keyboard-aware scrollable layout.

Top: back arrow, page indicator (3rd dot active), no skip.

Header (32dp top padding, 24dp horizontal):
- "Hesabınızı Oluşturun" Nunito Bold 24sp #1A1A2E
- "Ücretsiz başlayın, istediğiniz zaman yükseltin" Rubik 14sp #5A5A7A

Social login buttons (24dp gap from header, 24dp horizontal padding):
- "Google ile Devam Et" — white button, full width, height 52dp, radius 12dp, 1dp grey border, Google colored 'G' icon left, Rubik Medium 15sp #1A1A2E
- 12dp gap
- "Apple ile Devam Et" — black button, same size, Apple white icon left, white text

Divider: "veya e-posta ile" — horizontal lines both sides, Rubik 13sp #5A5A7A center

Form fields (16dp gap between):
- "Ad Soyad" text field: white bg, #E8E4F5 border, radius 12dp, height 56dp, person icon prefix, Rubik 15sp placeholder #5A5A7A
- "E-posta" text field: same style, email icon prefix
- "Telefon" text field: same style, Turkish flag emoji + "+90" prefix chip, phone icon

Terms text: "Devam ederek Kullanım Koşulları ve Gizlilik Politikası'nı kabul etmiş olursunuz." Rubik 12sp #5A5A7A centered, tappable links underlined in #6C3FC5.

Bottom: Full-width "Ücretsiz Hesap Aç 🎉" button, #6C3FC5, 56dp height, radius 16dp, button shadow. 24dp horizontal margin.
```

---

### Ekran 5: Ana Ekran — Home Dashboard (Boş Durum)

**Stitch Prompt:**
```
Flutter home screen for SnapKOBİ, empty/initial state.
Background #F5F3FF.

Top AppBar (no elevation, background #F5F3FF):
- Left: "SnapKOBİ" logo text Nunito Bold 20sp #3A1A6A + small sparkle icon
- Right: circular avatar with user initials (purple background, white text, 36dp), and notification bell icon

Usage banner card (24dp horizontal margin, 12dp top margin):
- White card, radius 16dp, card shadow
- Left side: "Bu Ay" label Rubik 12sp #5A5A7A, below it "3 / 10" Nunito Bold 22sp #3A1A6A, below "Ücretsiz Kredi" Rubik 12sp #5A5A7A
- Right side: circular progress ring (70% filled, purple), with "7 kaldı" label inside
- Bottom of card: thin linear progress bar (purple fill, 30% full), "Pro'ya geçerek sınırsız kullanın →" Rubik 12sp #6C3FC5 tap hint

Main upload area (24dp horizontal margin, 20dp top margin):
- Large dashed border rectangle, radius 24dp, height 220dp, #6C3FC5 dashed border (2dp, dash pattern), background white with very subtle purple tint
- Center content: camera icon 48dp in #6C3FC5, below "Ürün Fotoğrafı Ekle" Nunito SemiBold 18sp #1A1A2E, below "Galeriden seç veya kamera ile çek" Rubik 14sp #5A5A7A

Two action buttons below upload area (24dp horizontal margin, 16dp gap between, side by side):
- "📷 Kamera" — outlined button, half width, height 48dp, radius 12dp, #6C3FC5 border and text
- "🖼️ Galeri" — filled button, half width, same size, #6C3FC5 background white text

Section: "Platform Seçin" (24dp horizontal, 20dp top):
- Label Nunito SemiBold 16sp #1A1A2E
- Horizontal scrollable row of platform chips (8dp gap):
  * "📸 Instagram" — selected, filled #6C3FC5 pill, white text Rubik 13sp
  * "🛍️ Trendyol" — unselected, white pill, #6C3FC5 border
  * "💬 WhatsApp" — unselected same style
  * "🌐 Web Sitesi" — unselected same style

Bottom: "AI İşlemini Başlat ✨" — full width FAB-style button 56dp height, radius 16dp, #6C3FC5 fill, white Rubik Medium 16sp, button shadow. Disabled state (grey) until photo selected. 24dp margins, 16dp bottom.

Bottom navigation bar: 4 items — Ana Sayfa (active, filled icon + label), Geçmiş, Planlar, Ayarlar.
```

---

### Ekran 6: Ana Ekran — Fotoğraf Seçilmiş Durum

**Stitch Prompt:**
```
Flutter home screen for SnapKOBİ, photo selected state.
Same layout as empty state but photo upload area changes:

Upload area becomes a photo preview card (24dp margins, radius 24dp, height 260dp):
- Shows actual product photo preview (example: a casual sneaker on dirty background), fills card with object-fit cover, rounded corners
- Top-right overlay: white circular button with X icon (remove photo), 36dp, subtle shadow
- Bottom overlay: frosted glass strip (blur effect, semi-transparent dark) showing "Spor Ayakkabı.jpg • 2.4 MB" in Rubik 13sp white

Platform selection row same as before (Instagram selected).

Below platform row, new "Sahne Seçimi" section (24dp horizontal, 16dp top):
- Label: "Arka Plan Teması" Nunito SemiBold 16sp #1A1A2E
- Horizontal scrollable scene thumbnails (72dp x 72dp, radius 12dp, 8dp gap, 1 selected with purple border):
  * "🏢 Stüdyo" (white background preview) — selected
  * "☀️ Outdoor" (park preview)
  * "🏠 Ev" (cozy interior preview)
  * "🍃 Doğa" (nature background)
  * "+ Özel" (plus icon, #F5F3FF bg)

"AI İşlemini Başlat ✨" button now ACTIVE (full purple, glowing shadow effect, pulsing subtle animation indicating readiness).

Bottom nav same.
```

---

### Ekran 7: İşlem Ekranı — AI Loading State

**Stitch Prompt:**
```
Flutter processing/loading screen for SnapKOBİ.
Full screen, background: gradient from #3A1A6A (top 40%) to #F5F3FF (bottom 60%).

Top section (purple zone):
- Back/close icon top-left (white)
- "İşleminiz Hazırlanıyor" Nunito Bold 22sp white, centered, 24dp top padding after icon
- "Telefonu kapatabilirsiniz, bildirim göndereceğiz" Rubik 14sp white at 70% opacity, centered

Center illustration area:
- Large animated circular loader: 
  * Outer ring: dashed purple/white rotating slowly
  * Inner card: shows the original product photo thumbnail (80x80dp rounded square) with sparkle particles animating out from it (CSS-like starburst animation effect)
  * Progress percentage "67%" Nunito Bold 32sp white centered below

Step progress tracker (white card, radius 20dp, 24dp horizontal margin, centered vertically in purple zone):
3 steps shown as a vertical list inside the card:
- ✅ "Görsel Analiz Edildi" — green checkmark, Rubik 14sp #1A1A2E, completed style
- ⏳ "Arka Plan Değiştiriliyor..." — purple spinner, Rubik 14sp #6C3FC5 bold, active style with shimmer
- ⭕ "Metin Üretiliyor" — grey, Rubik 14sp #5A5A7A, pending style

Bottom white section:
- "Tahmini Süre: ~45 saniye" Rubik 13sp #5A5A7A centered
- 16dp gap
- Outlined button "Arka Planda Çalışsın" full width 48dp, radius 12dp, #6C3FC5 border and text, white bg
- 8dp gap  
- Text: "İşlem tamamlandığında bildirim alacaksınız 🔔" Rubik 12sp #5A5A7A centered
```

---

### Ekran 8: Sonuç Ekranı — Result Screen

**Stitch Prompt:**
```
Flutter result screen for SnapKOBİ showing AI-processed content.
Background #F5F3FF.

Top AppBar: "Sonuçlarınız Hazır! 🎉" Nunito Bold 20sp #3A1A6A. Right: share icon.

Success banner (24dp horizontal, 12dp top): 
- Green (#22C55E) rounded card, height 48dp, radius 12dp
- Checkmark icon + "İşlem 52 saniyede tamamlandı" Rubik Medium 14sp white

Image comparison card (24dp margins, radius 20dp, white, card shadow):
- Card title row: "Görsel Karşılaştırma" Nunito SemiBold 15sp #1A1A2E left, "Kaydet 💾" text button #6C3FC5 right
- 12dp gap
- Side by side images (equal width, height 160dp, radius 12dp):
  Left: original (dirty background sneaker) with "Önce" label chip (grey, top-left overlay)
  Right: processed (clean white studio sneaker) with "Sonra" label chip (purple, top-left overlay)
- Below right image: quality stars ⭐⭐⭐⭐⭐ "Yüksek Kalite" Rubik 12sp #22C55E

Video card (24dp margins, radius 20dp, white, card shadow, 16dp top margin):
- Header: "Tanıtım Videosu" Nunito SemiBold 15sp + video duration chip "0:05" grey right
- Video thumbnail (full width, height 180dp, radius 12dp): shows sneaker mid-animation frame, large white play button centered with purple circle background
- Below: action row: "▶️ Oynat" outlined button + "⬇️ İndir" filled #6C3FC5 button, equal width, 48dp height

Text/caption card (24dp margins, radius 20dp, white, card shadow, 16dp top):
- Header row: "Instagram Metni" Nunito SemiBold 15sp + platform chip "📸 Instagram" purple small pill
- Generated Turkish caption in Rubik 14sp #1A1A2E: "Yeni sezon spor ayakkabılarımız stoklarda! 👟✨ Hem şık hem konforlu tasarımıyla günlük kullanıma mükemmel uyum sağlıyor. Sınırlı stok — hemen DM at! #spor #ayakkabı #yenisezon #moda"
- Hashtag pills below in a wrap layout: each hashtag as small #F5F3FF chip with #6C3FC5 text
- Action row: "📋 Kopyala" + "✏️ Düzenle" outlined buttons side by side

Bottom sticky bar (white, top shadow):
"Tümünü Paylaş" full-width primary button 56dp, #6C3FC5, radius 16dp. Below it: share platform icons row (Instagram, WhatsApp, Trendyol icons, 32dp each, 16dp gap).
```

---

### Ekran 9: Geçmiş Ekranı — History Screen

**Stitch Prompt:**
```
Flutter history/gallery screen for SnapKOBİ.
Background #F5F3FF.

Top AppBar: "Geçmişim" Nunito Bold 22sp #3A1A6A. Right: filter icon.

Filter chips row (horizontal scroll, 24dp left padding, 8dp gap):
- "Tümü" — selected, purple pill
- "Bu Hafta" — unselected white pill
- "Görseller" — unselected
- "Videolar" — unselected
- "Instagram" — unselected

Content: 2-column grid (24dp margins, 12dp gap between):
Each history card (radius 16dp, white background, card shadow):
- Thumbnail: processed product image, full width, height 120dp, radius 12dp top only
- Below image (12dp padding):
  * Product name in Nunito SemiBold 14sp #1A1A2E, 1 line truncated
  * Platform chip (tiny: "📸 IG" or "🛍️ TR") + date "3 gün önce" Rubik 11sp #5A5A7A
  * Row: "📤 Paylaş" ghost button + "⚡ Yeniden İşle" text button

Show 6 cards in grid (2 rows × 3 won't fit, show 2×3 = different layouts):
Make it 2 columns, 3 rows = 6 cards. Example products: sneaker, a watch, a bag, a food plate, a jacket, a ring.

Empty state variant (show as commented/optional): 
Centered illustration: empty box icon 80dp #E8E4F5, "Henüz işlem yok" Nunito SemiBold 18sp #1A1A2E, "İlk ürününüzü ekleyin!" Rubik 14sp #5A5A7A, then primary CTA button "Ürün Ekle →".

Bottom nav: Geçmiş tab active.
```

---

### Ekran 10: Abonelik / Plan Ekranı

**Stitch Prompt:**
```
Flutter subscription/pricing screen for SnapKOBİ.
Background #F5F3FF.

Top: back arrow + "Planınızı Seçin" Nunito Bold 22sp #3A1A6A centered.

Current plan banner (24dp margins, 12dp top):
White card, radius 16dp: "Şu an: Ücretsiz Plan • 7 krediniz kaldı" Rubik 14sp #5A5A7A. Green dot indicator.

Toggle switch row centered: "Aylık" ← toggle → "Yıllık %20 İndirim" (pill badge "FIRSATI KAÇIRMA" in orange/red if yearly selected).

Plan cards (24dp margins, 16dp gap):

Card 1 — Ücretsiz (current):
White card, radius 20dp, 1dp #E8E4F5 border.
- "Ücretsiz" Nunito Bold 20sp #1A1A2E
- "0 ₺ / ay" Nunito Bold 26sp #3A1A6A
- Features list (checkmark icons, Rubik 14sp #1A1A2E): "10 görsel/ay ✓", "Temel arka plan ✓", "Instagram metni ✓", "Video üretimi ✗ (grey cross)", "Öncelikli işlem ✗"
- "Mevcut Plan" grey outlined button disabled

Card 2 — Başlangıç (MOST POPULAR):
Purple card (#6C3FC5 background), radius 20dp, "EN POPÜLER" badge top-right (white pill, purple text Rubik Bold 11sp).
- "Başlangıç" Nunito Bold 20sp white
- "99 ₺ / ay" Nunito Bold 30sp white (strike-through "124 ₺" if yearly toggle on)
- Features list (white checkmarks, Rubik 14sp white): "100 görsel/ay ✓", "Tüm arka plan temaları ✓", "5 sn tanıtım videosu ✓", "Tüm platform metinleri ✓", "Öncelikli işlem ✓"
- "Başla — 7 Gün Ücretsiz" white button, full width 52dp radius 12dp, #6C3FC5 text, white bg, shadow

Card 3 — Pro:
White card with subtle purple gradient overlay (5% opacity), radius 20dp, gold/amber "PRO" badge.
- "Pro" Nunito Bold 20sp #1A1A2E
- "299 ₺ / ay" Nunito Bold 26sp #3A1A6A
- Features: everything in Başlangıç + "Sınırsız görsel ✓", "4K kalite ✓", "API erişimi ✓", "Öncelikli destek ✓"
- "Pro'ya Geç" #6C3FC5 outlined button full width 52dp

Payment note at bottom: lock icon + "iyzico güvenli ödeme • İstediğiniz zaman iptal" Rubik 12sp #5A5A7A centered.
```

---

### Ekran 11: Profil & Ayarlar Ekranı

**Stitch Prompt:**
```
Flutter settings/profile screen for SnapKOBİ.
Background #F5F3FF.

Top section (purple header, rounded bottom corners radius 32dp, padding 24dp):
Background gradient #3A1A6A to #6C3FC5.
- Large avatar circle (72dp, white border 3dp) with user initials or photo
- "Mehmet Yılmaz" Nunito Bold 20sp white
- "mehmet@example.com" Rubik 14sp white 70% opacity
- "📦 Başlangıç Plan • 87 kredi kaldı" — white pill badge Rubik 13sp

Settings list (white cards with radius 16dp, 24dp margins, 12dp gap):

Card 1 — Hesap Ayarları:
Grouped list items (48dp height each, dividers between):
- person icon + "Profil Bilgileri" + chevron right
- storefront icon + "Sektör Ayarları" + chevron right (shows current: "👗 Tekstil" chip)
- notifications icon + "Bildirimler" + toggle switch (on)

Card 2 — Abonelik:
- workspace_premium icon + "Başlangıç Plan" + "Yükselt →" text button in #6C3FC5
- credit_card icon + "Ödeme Geçmişi" + chevron
- autorenew icon + "Abonelik Yönetimi" + chevron

Card 3 — Uygulama:
- language icon + "Dil" + "Türkçe" grey chip right
- help icon + "Yardım & SSS" + chevron
- policy icon + "Gizlilik Politikası" + chevron
- star icon + "Uygulamayı Puanla" + chevron (external link icon)

Bottom (not in card):
- "Çıkış Yap" text button, Rubik Medium 15sp #EF4444, centered
- Version text: "SnapKOBİ v1.0.0 • snapkobi.com" Rubik 11sp #5A5A7A centered

Bottom nav: Ayarlar tab active.
```

---

### Ekran 12: Bottom Sheet — Platform Seçimi Detayı

**Stitch Prompt:**
```
Flutter modal bottom sheet for SnapKOBİ — platform and format selection.
Bottom sheet slides up from bottom. Background overlay dark. Sheet background white, top rounded corners radius 28dp. Max height 65% of screen.

Handle bar: 4dp × 40dp rounded pill, #E8E4F5, centered top 12dp.

Title: "Platform & Format Seçin" Nunito Bold 20sp #1A1A2E, 24dp top from handle, 24dp horizontal.

Subtitle: "Her platform için AI farklı format üretir" Rubik 14sp #5A5A7A, 8dp below title.

Platform list (scrollable, 16dp top margin, 24dp horizontal):
Each row is a selectable tile (72dp height, radius 16dp, 8dp gap):

Unselected style: white bg, #E8E4F5 border 1dp
Selected style: #EDE7FF bg, #6C3FC5 border 2dp, checkmark right

Tiles:
1. 📸 Instagram (selected)
   Sub: "Kare 1080×1080 • Emoji + Hashtag • 150 karakter"
   
2. 🛍️ Trendyol
   Sub: "Ürün fotoğrafı 1000×1000 • SEO başlık • 500 karakter açıklama"

3. 💬 WhatsApp Business
   Sub: "Landscape 1280×720 • Kısa satış metni • Fiyat bırakılan şablon"
   
4. 🌐 Web Sitesi / E-ticaret
   Sub: "Yatay banner 1200×628 • Uzun açıklama • Alt metin dahil"
   
5. 🎵 TikTok / Reels
   Sub: "Dikey 1080×1920 • Dikkat çekici kısa metin"

Bottom (sticky in sheet):
"Seçimi Onayla" full-width primary button 56dp radius 16dp #6C3FC5. 24dp margins. 24dp bottom padding.
```

---

### Ekran 13: Bildirim — Push Notification Tasarımı

**Stitch Prompt:**
```
iOS/Android push notification preview for SnapKOBİ.
Show notification in expanded state on a dark phone screen mockup.

Notification card:
- App icon: SnapKOBİ purple square icon with camera+sparkle
- App name: "SnapKOBİ" small grey
- Time: "az önce"
- Title (bold): "✨ Ürününüz Hazır!"
- Body: "Spor ayakkabı görseliniz işlendi. Profesyonel fotoğraf, video ve Instagram metni hazır — hemen paylaşın!"
- Below body: 2 action buttons: "Görüntüle" (filled purple style) | "Paylaş" (outlined)
- Thumbnail right: small processed product image preview 50×50dp

Show this notification on a realistic phone home screen background (blurred, dark wallpaper).
```

---

## 3. Component Library — Tekrar Kullanılabilir Bileşenler

Bu bileşenler için Stitch'te ayrı ayrı prompt kullanın:

### 3.1 Primary Button Varyantları

```
Flutter button component showcase for SnapKOBİ design system.
Show all button states on white background, 24dp gaps between:
1. Primary filled: "İşlemi Başlat ✨" — #6C3FC5 bg, white text, 56dp height, radius 16dp, button shadow
2. Primary filled disabled: same but #C4B5E8 bg, white text, no shadow
3. Primary outlined: "İptal" — white bg, #6C3FC5 border 1.5dp, #6C3FC5 text, same size
4. Destructive: "Hesabı Sil" — #FEE2E2 bg, #EF4444 text, same size
5. Text button: "Daha Fazla Göster" — no bg, #6C3FC5 text Rubik Medium 15sp underline
6. Loading state: primary filled with CircularProgressIndicator (white, 20dp) replacing text
All buttons use Rubik Medium 15sp, full width within 320dp container.
```

### 3.2 Upload Area States

```
Flutter file upload widget component for SnapKOBİ showing 4 states in a 2×2 grid:
1. Empty/Default: dashed purple border, camera icon center, "Fotoğraf Ekle" text, "Galeriden seç veya kamera ile çek" subtext
2. Hover/Active (drag over): solid purple border, "Bırakın!" text, purple tinted background
3. Photo selected: product thumbnail fills area, X remove button top-right, filename chip bottom
4. Error: red dashed border, error icon, "Desteklenmeyen format. JPG, PNG kullanın." red text
Widget size: 320dp wide, 200dp height each, radius 20dp, spacing 16dp between.
```

### 3.3 Progress Indicator

```
Flutter custom step progress component for SnapKOBİ AI processing.
Vertical stepper, 320dp wide:
Step 1 (completed): green filled circle with check icon, "Görsel Yüklendi" Nunito SemiBold 15sp #1A1A2E, "2.4 MB • JPG" Rubik 13sp #5A5A7A. Green connecting line down.
Step 2 (active): purple filled circle with rotating spinner animation, "Arka Plan Değiştiriliyor" Nunito SemiBold 15sp #6C3FC5 bold, "Ortalama 15 saniye..." Rubik 13sp #6C3FC5. Shimmer effect on text. Purple dashed connecting line down.
Step 3 (pending): grey empty circle outline, "Metin Üretimi" Nunito SemiBold 15sp #9CA3AF, "Sırada bekliyor" Rubik 13sp #C4B5E8. Grey connecting line down.
Step 4 (pending): same style, "Video Oluşturma".
White card background, radius 20dp, 20dp padding.
```

### 3.4 Empty State

```
Flutter empty state illustration component for SnapKOBİ history screen.
Centered layout, 320dp wide:
- Illustration: friendly cartoon of a small box with sparkles and a dashed camera outline hovering above it. Colors: #EDE7FF bg shape, #6C3FC5 accents, #3A1A6A dark elements. Style: flat, friendly, rounded.
- 24dp gap
- "Henüz İşlem Yok" Nunito Bold 22sp #1A1A2E centered
- 8dp gap
- "İlk ürün fotoğrafınızı ekleyin, AI sihri başlasın!" Rubik Regular 15sp #5A5A7A centered, 40dp horizontal padding
- 24dp gap
- Primary button "İlk Ürünümü Ekle 📷" full width 56dp radius 16dp #6C3FC5
```

---

## 4. Animasyon & Geçiş Spesifikasyonları

Flutter implementasyonunda kullanılacak animasyon detayları:

| Animasyon | Süre | Easing | Notlar |
|---|---|---|---|
| Sayfa geçişi | 300ms | easeInOut | SharedAxisTransition (horizontal) |
| Card tap ripple | 200ms | decelerate | Material ripple, purple tint |
| Upload drop zone | 150ms | easeOut | Border rengi + bg rengi değişimi |
| Processing step | 400ms | elasticOut | Adım tamamlanma checkmark |
| Result reveal | 500ms | easeOut | FadeTransition + SlideTransition bottom-up |
| Snackbar | 250ms | easeInOut | Bottom slide up, 3s otomatik kapat |
| Bottom sheet | 350ms | easeOut | Slide up from bottom |
| FAB pulse | 1500ms | sinusoidal | Infinite, subtle scale 1.0→1.03→1.0, aktif durum |
| Splash logo | 600ms | elasticOut | Scale 0→1 + fade |

---

## 5. Erişilebilirlik (Accessibility) Gereksinimleri

Tüm ekranlarda Flutter accessibility standartlarına uyulmalıdır:

- **Minimum dokunma alanı**: 48dp × 48dp (tüm butonlar ve ikonlar için)
- **Metin kontrast oranı**: Beyaz üzeri primary (#6C3FC5) = 4.6:1 ✓ (WCAG AA)
- **Semantics widget**: her tıklanabilir eleman için `Semantics(label: ...)` kullanılmalı
- **Dinamik font boyutu**: `MediaQuery.textScaleFactor` destekli (1.0–1.3 arası test edilmeli)
- **Klavye navigasyon**: tüm form alanları tab-order ile erişilebilir
- **Hata mesajları**: yalnızca renkle değil, ikon + metin ile bildirilmeli
- **Yükleme durumu**: `CircularProgressIndicator` ile birlikte `SemanticsProperties.liveRegion: true`

---

## 6. Dark Mode Varyantı (Opsiyonel v2)

Dark mode için token eşlemeleri:

| Light Token | Dark Değer |
|---|---|
| `background` → | `#0F0B1E` |
| `surface` → | `#1C1530` |
| `primary` → | `#9B72E8` (daha açık ton, kontrast için) |
| `onSurface` → | `#F0EBFF` |
| `onSurfaceVariant` → | `#A09ABD` |
| `divider` → | `#2A2245` |
| `card-shadow` → | `0dp 2dp 8dp rgba(0,0,0,0.4)` |

Stitch prompt başına eklenecek dark mode notu:
```
Dark mode variant. Use dark background #0F0B1E, card surfaces #1C1530, 
primary accent #9B72E8, text #F0EBFF. Maintain the same layout, 
only swap colors per dark mode token map.
```

---

## 7. Stitch Kullanım Akışı — Adım Adım

1. **stitch.google** adresine gidin ve yeni proje oluşturun.
2. Proje adı: `SnapKOBI-Flutter-Design`
3. Platform: `Mobile (Android/iOS)`
4. Her ekran için:
   a. "Add Screen" tıklayın
   b. Bu dokümandaki ilgili **Stitch Prompt** metnini yapıştırın
   c. Global bağlam prefix'ini (Bölüm 0'daki metin) prompt başına ekleyin
   d. Stitch çıktısını inceleyin → gerekirse prompt'u revize edin
5. Tüm ekranlar tamamlandıktan sonra: **Export to Flutter** seçeneği ile `.dart` dosyalarını indirin.
6. İndirilen widget dosyalarını `lib/features/` dizinine aktarın.
7. Design token'larını `lib/core/theme/app_theme.dart` dosyasına merkezi olarak ekleyin.

---

## 8. Flutter Tema Kodu (Referans)

Stitch çıktısını projeye entegre ederken kullanacağınız temel tema:

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary     = Color(0xFF6C3FC5);
  static const Color primaryDark = Color(0xFF3A1A6A);
  static const Color primaryLight= Color(0xFFEDE7FF);
  static const Color background  = Color(0xFFF5F3FF);
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color onSurface   = Color(0xFF1A1A2E);
  static const Color onVariant   = Color(0xFF5A5A7A);
  static const Color success     = Color(0xFF22C55E);
  static const Color warning     = Color(0xFFF59E0B);
  static const Color error       = Color(0xFFEF4444);
  static const Color divider     = Color(0xFFE8E4F5);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      background: background,
      surface: surface,
      error: error,
    ),
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      bodyLarge:   GoogleFonts.rubik(fontSize: 16, color: onSurface),
      bodyMedium:  GoogleFonts.rubik(fontSize: 14, color: onSurface),
      labelLarge:  GoogleFonts.rubik(fontSize: 15, fontWeight: FontWeight.w500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        shadowColor: primary.withOpacity(0.3),
        textStyle: GoogleFonts.rubik(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: primary.withOpacity(0.08),
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: primaryDark,
      ),
      iconTheme: const IconThemeData(color: primaryDark),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: onVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: primaryLight,
      selectedColor: primary,
      labelStyle: GoogleFonts.rubik(fontSize: 13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      hintStyle: GoogleFonts.rubik(color: onVariant, fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}
```

---

*SnapKOBİ Design Specification v1.0 — snapkobi.com*  
*Bu doküman Google Stitch ile Flutter tasarım üretimi için hazırlanmıştır.*
