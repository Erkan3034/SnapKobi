-- ═══════════════════════════════════════════════════════════════════════════
-- SnapKOBİ — background_themes (Create ekrani arka plan temalari)
-- Idempotent: tekrar calistirilabilir. Supabase SQL Editor'de calistir.
-- id, AI pipeline'in bekledigi stil anahtaridir (studio, nature, luxury...).
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. Tablo ────────────────────────────────────────────────────────────────
create table if not exists public.background_themes (
  id          text primary key,
  label       text not null,
  image_url   text not null,
  is_active   boolean not null default true,
  sort_order  integer not null default 0,
  created_at  timestamptz not null default now()
);

-- ─── 2. RLS + GRANT (public read) ────────────────────────────────────────────
alter table public.background_themes enable row level security;

drop policy if exists "bg_themes_public_read" on public.background_themes;
create policy "bg_themes_public_read" on public.background_themes
  for select using (is_active = true);

drop policy if exists "bg_themes_service_all" on public.background_themes;
create policy "bg_themes_service_all" on public.background_themes
  for all using (auth.role() = 'service_role') with check (auth.role() = 'service_role');

grant select on public.background_themes to anon, authenticated;

-- ─── 3. Seed (8 tema) — upsert ───────────────────────────────────────────────
insert into public.background_themes (id, label, image_url, is_active, sort_order) values
  ('studio',     'Stüdyo',     'https://images.unsplash.com/photo-1596265376427-4688ee0f616f?w=150&q=80', true, 1),
  ('outdoor',    'Outdoor',    'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=150&q=80', true, 2),
  ('home',       'Ev',         'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=150&q=80', true, 3),
  ('nature',     'Doğa',       'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=150&q=80', true, 4),
  ('minimalist', 'Minimalist', 'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?w=150&q=80', true, 5),
  ('luxury',     'Lüks',       'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=150&q=80', true, 6),
  ('neon',       'Neon',       'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=150&q=80', true, 7),
  ('gradient',   'Gradient',   'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=150&q=80', true, 8)
on conflict (id) do update
  set label = excluded.label,
      image_url = excluded.image_url,
      is_active = excluded.is_active,
      sort_order = excluded.sort_order;

-- ─── 4. Dogrulama ──────────────────────────────────────────────────────────
-- select count(*) from public.background_themes;  -- 8 beklenir
