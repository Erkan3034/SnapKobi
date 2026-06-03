-- ════════════════════════════════════════════════════════════════════════════
-- SnapKOBİ — Showcase kurulumu (TEK DOSYA)
-- Supabase Dashboard → SQL Editor'e yapıştır → Run.
-- Idempotent: tekrar çalıştırmak güvenli (IF NOT EXISTS / ON CONFLICT / guard).
-- enum tipleri "SectorType" ve "PlatformType" Prisma tarafindan zaten olusturuldu
-- (generations tablosu bunlari kullaniyor).
-- ════════════════════════════════════════════════════════════════════════════

-- ─── 1. ADMIN_TEMPLATES yeni kolonlar ────────────────────────────────────────
alter table public.admin_templates add column if not exists usage_count integer not null default 0;
alter table public.admin_templates add column if not exists is_premium  boolean not null default false;

-- ─── 2. TRENDS tablosu ───────────────────────────────────────────────────────
create table if not exists public.trends (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  image_url   text not null,
  before_url  text not null,
  usage_count integer not null default 0,
  category    text not null,
  popularity  integer not null default 0,
  sector      "SectorType" not null,
  platform    "PlatformType" not null,
  caption     text not null default '',
  hashtags    text[] not null default '{}',
  scenes      text[] not null default '{}',
  is_active   boolean not null default true,
  sort_order  integer not null default 0,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index if not exists trends_active_sort_idx on public.trends (is_active, sort_order);

-- ─── 3. COMMUNITY_POSTS tablosu ──────────────────────────────────────────────
create table if not exists public.community_posts (
  id             uuid primary key default gen_random_uuid(),
  user_name      text not null,
  avatar_url     text,
  before_url     text not null,
  after_url      text not null,
  platform       "PlatformType" not null,
  category       text not null default 'other',
  likes_count    integer not null default 0,
  comments_count integer not null default 0,
  is_active      boolean not null default true,
  sort_order     integer not null default 0,
  created_at     timestamptz not null default now()
);
create index if not exists community_active_created_idx on public.community_posts (is_active, created_at desc);

-- ─── 4. RLS + GRANT (Flutter anon key ile DOGRUDAN okuyor) ───────────────────
alter table public.trends           enable row level security;
alter table public.community_posts  enable row level security;
alter table public.admin_templates  enable row level security;

drop policy if exists "trends_public_read" on public.trends;
create policy "trends_public_read" on public.trends for select using (is_active = true);
drop policy if exists "trends_service_all" on public.trends;
create policy "trends_service_all" on public.trends for all using (auth.role() = 'service_role') with check (auth.role() = 'service_role');

drop policy if exists "community_public_read" on public.community_posts;
create policy "community_public_read" on public.community_posts for select using (is_active = true);
drop policy if exists "community_service_all" on public.community_posts;
create policy "community_service_all" on public.community_posts for all using (auth.role() = 'service_role') with check (auth.role() = 'service_role');

drop policy if exists "admin_templates_public_read" on public.admin_templates;
create policy "admin_templates_public_read" on public.admin_templates for select using (is_active = true);
drop policy if exists "admin_templates_service_all" on public.admin_templates;
create policy "admin_templates_service_all" on public.admin_templates for all using (auth.role() = 'service_role') with check (auth.role() = 'service_role');

grant select on public.trends, public.community_posts, public.admin_templates to anon, authenticated;

-- ─── 5. SEED — 5'er gercek kayit ─────────────────────────────────────────────

-- admin_templates (slug unique → ON CONFLICT)
insert into public.admin_templates
  (name, slug, description, thumbnail_url, category, usage_count, is_active, is_featured, is_premium, sort_order, applicable_platforms, default_background_style, background_system_prompt, caption_system_prompt)
values
  ('Stüdyo Beyaz', 'studio-beyaz', 'Temiz beyaz stüdyo zemini, profesyonel ürün vitrini için ideal.', 'https://images.unsplash.com/photo-1596265376427-4688ee0f616f?w=400&q=80', 'product', 2340, true, true, false, 1, array['instagram','trendyol','hepsiburada','web'], 'studio_white', 'Place the product on a seamless pure white studio background with soft, even diffused lighting and a subtle contact shadow. Keep the product centered and sharp.', 'Profesyonel, güven veren, kısa ve net bir Türkçe satış metni yaz. Ürünün öne çıkan özelliğini vurgula.'),
  ('Doğa Yeşili', 'doga-yesili', 'Doğal yeşil ortam, organik ve sürdürülebilir ürünler için.', 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400&q=80', 'product', 1120, true, false, false, 2, array['instagram','web'], 'nature_green', 'Place the product in a fresh natural green setting with soft daylight, blurred foliage in the background, conveying an organic and eco-friendly feel.', 'Doğal, samimi ve sıcak bir Türkçe metin yaz. Organik ve sürdürülebilir tonu vurgula.'),
  ('Lüks Mermer', 'luks-mermer', 'Şık mermer yüzey ve loş ışıklarla premium sunum.', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=400&q=80', 'fashion', 760, true, true, true, 3, array['instagram','trendyol'], 'luxury_marble', 'Place the product on an elegant marble surface with dramatic, moody directional lighting and reflections, conveying a premium and luxurious mood.', 'Zarif, prestijli ve şık bir Türkçe metin yaz. Lüks algısını öne çıkar.'),
  ('Yemek Masası', 'yemek-masasi', 'Sıcak ahşap masa ve iştah açıcı doğal ışık, gıda ürünleri için.', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80', 'food', 540, true, false, false, 4, array['instagram','trendyol','whatsapp'], 'food_table', 'Place the food product on a warm wooden table with appetizing natural side lighting and complementary props, conveying freshness and taste.', 'İştah açıcı, sıcak ve davetkâr bir Türkçe metin yaz. Lezzeti ve tazeliği vurgula.'),
  ('Neon Cyber', 'neon-cyber', 'Dinamik pembe-mavi neon ışıklar, teknoloji ürünleri için.', 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=400&q=80', 'tech', 870, true, true, true, 5, array['instagram','tiktok','web'], 'neon_cyber', 'Place the product in a dynamic neon-lit scene with pink and blue cyberpunk lighting, glossy reflective surface, conveying a modern high-tech mood.', 'Dinamik, modern ve dikkat çekici bir Türkçe metin yaz. Teknolojik üstünlüğü vurgula.')
on conflict (slug) do nothing;

-- trends (yalnizca bos tabloda)
do $$
begin
  if not exists (select 1 from public.trends) then
    insert into public.trends
      (title, image_url, before_url, usage_count, category, popularity, sector, platform, caption, hashtags, scenes, is_active, sort_order)
    values
      ('Spor Ayakkabı', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80', 'https://images.unsplash.com/photo-1485738422979-f5c462d49f74?w=400&q=80', 1247, 'Tekstil', 94, 'textile', 'instagram',
       'Yeni sezonun en göz alıcı modelleri SnapKOBİ ile hazır! ❤️ Hem şık hem rahat bu modelle tarzını konuştur. Stoklar bitmeden hemen incele. 👟✨',
       array['#TrendSneaker','#Moda2024','#SnapKOBİ','#AyakkabıModası','#TarzınıYansıt'],
       array['https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=200&q=80','https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?w=200&q=80','https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=200&q=80'], true, 1),
      ('Akıllı Saat', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80', 'https://images.unsplash.com/photo-1546868871-af0de0ae72be?w=400&q=80', 856, 'Elektronik', 91, 'electronics', 'trendyol',
       'Günün her anında şıklığı yakala! ⌚ En trend tasarımlarla zamanı tarzınla yönet. Sınırlı stoklarla hemen sepetine ekle. ✨',
       array['#TrendWatch','#AkıllıSaat','#SnapKOBİ','#Teknoloji','#TarzınıYansıt'],
       array['https://images.unsplash.com/photo-1596265376427-4688ee0f616f?w=200&q=80','https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=200&q=80'], true, 2),
      ('Deri El Çantası', 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&q=80', 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&q=80', 634, 'Tekstil', 89, 'textile', 'instagram',
       'Zarafet ve şıklık bir arada! 👜 Kombinlerinin en şık tamamlayıcısı olacak deri el çantası şimdi stoklarda. Kaçırma! ❤️',
       array['#TrendBag','#DeriÇanta','#SnapKOBİ','#Moda','#TarzınıYansıt'],
       array['https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=200&q=80','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=200&q=80'], true, 3),
      ('Doğal Sabun', 'https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec?w=400&q=80', 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&q=80', 512, 'Kozmetik', 87, 'beauty', 'instagram',
       'Cildine doğanın dokunuşu! 🌿 El yapımı doğal sabunlarımızla her gün tazelen. %100 doğal içerik, sınırlı üretim. ✨',
       array['#DoğalSabun','#ElYapımı','#SnapKOBİ','#Kozmetik','#DoğalBakım'],
       array['https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=200&q=80','https://images.unsplash.com/photo-1596265376427-4688ee0f616f?w=200&q=80'], true, 4),
      ('El Yapımı Takı', 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400&q=80', 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400&q=80', 421, 'Takı', 85, 'jewelry', 'instagram',
       'Her parça bir hikâye anlatıyor! 💍 El emeği göz nuru özel tasarım takılarımızla farkını ortaya koy. Sınırlı sayıda! ✨',
       array['#ElYapımıTakı','#ÖzelTasarım','#SnapKOBİ','#Takı','#TarzınıYansıt'],
       array['https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=200&q=80','https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=200&q=80'], true, 5);
  end if;
end $$;

-- community_posts (yalnizca bos tabloda)
do $$
begin
  if not exists (select 1 from public.community_posts) then
    insert into public.community_posts
      (user_name, avatar_url, before_url, after_url, platform, category, likes_count, comments_count, is_active, sort_order)
    values
      ('ayakkabi_dunyasi', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=80&q=80', 'https://images.unsplash.com/photo-1485738422979-f5c462d49f74?w=400&q=80', 'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=400&q=80', 'instagram', 'fashion', 242, 18, true, 1),
      ('tech_store_tr', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&q=80', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80', 'https://images.unsplash.com/photo-1546868871-af0de0ae72be?w=400&q=80', 'trendyol', 'tech', 1200, 56, true, 2),
      ('butik_moda', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&q=80', 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&q=80', 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&q=80', 'instagram', 'fashion', 840, 31, true, 3),
      ('kozmetik_dunyam', 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=80&q=80', 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&q=80', 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=400&q=80', 'instagram', 'beauty', 620, 24, true, 4),
      ('lezzet_sofrasi', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=80&q=80', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&q=80', 'trendyol', 'food', 450, 12, true, 5);
  end if;
end $$;

-- ─── 6. Dogrulama ────────────────────────────────────────────────────────────
-- select count(*) from public.trends;            -- 5 beklenir
-- select count(*) from public.community_posts;   -- 5 beklenir
-- select count(*) from public.admin_templates;   -- 5 beklenir
