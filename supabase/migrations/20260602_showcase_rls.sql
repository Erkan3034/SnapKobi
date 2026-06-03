-- Showcase tablolari (trends, community_posts) ve admin_templates icin RLS.
-- Tablolar `prisma db push` ile olusturulur (enum tipleri Prisma yonetir);
-- bu migration yalnizca RLS politikalari + anon/authenticated GRANT ekler.
-- Flutter bu tablolari anon key ile DOGRUDAN okur, bu yuzden public read sart.

-- ─── TRENDS ──────────────────────────────────────────────────────────────────
alter table public.trends enable row level security;

drop policy if exists "trends_public_read" on public.trends;
create policy "trends_public_read"
  on public.trends for select
  using (is_active = true);

drop policy if exists "trends_service_all" on public.trends;
create policy "trends_service_all"
  on public.trends for all
  using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');

grant select on public.trends to anon, authenticated;

-- ─── COMMUNITY_POSTS ─────────────────────────────────────────────────────────
alter table public.community_posts enable row level security;

drop policy if exists "community_public_read" on public.community_posts;
create policy "community_public_read"
  on public.community_posts for select
  using (is_active = true);

drop policy if exists "community_service_all" on public.community_posts;
create policy "community_service_all"
  on public.community_posts for all
  using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');

grant select on public.community_posts to anon, authenticated;

-- ─── ADMIN_TEMPLATES (Flutter dogrudan sorguluyor) ───────────────────────────
alter table public.admin_templates enable row level security;

drop policy if exists "admin_templates_public_read" on public.admin_templates;
create policy "admin_templates_public_read"
  on public.admin_templates for select
  using (is_active = true);

drop policy if exists "admin_templates_service_all" on public.admin_templates;
create policy "admin_templates_service_all"
  on public.admin_templates for all
  using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');

grant select on public.admin_templates to anon, authenticated;
