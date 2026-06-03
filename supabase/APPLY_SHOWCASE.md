# Showcase tabloları — uygulama runbook'u

`trends` + `community_posts` tablolarını, RLS'i ve seed'i remote Supabase'e uygulamak için
aşağıdaki adımları **sırayla** çalıştır. Hedef DB `.env` içindeki `DATABASE_URL` (remote, eu-central-1).

```bash
# 1) Şema senkronu — trends + community_posts tabloları, admin_templates yeni kolonları (usage_count, is_premium)
cd snapkobi-backend
npx prisma db push          # mevcut tablolara dokunmaz, yalnızca ekleme yapar
npx prisma generate

# 2) RLS politikaları + GRANT (anon/authenticated public read)
#    Supabase SQL Editor'e yapıştır VEYA psql ile:
psql "$DIRECT_DATABASE_URL" -f ../supabase/migrations/20260602_showcase_rls.sql

# 3) Seed — 5 şablon + 5 trend + 5 topluluk gönderisi (idempotent)
psql "$DIRECT_DATABASE_URL" -f ../supabase/seed.sql
```

## Doğrulama
- Supabase Table Editor: `trends` (5 satır), `community_posts` (5 satır), `admin_templates` (5 satır)
- Flutter: Discover/Library/Community ekranları gerçek veriyi göstermeli (boş değil)
- RLS testi: anon key ile `select * from trends where is_active=true` çalışmalı

## Sonraki adım (opsiyonel)
Admin panelinden (snapkobi-admin) trend/community yönetmek için backend'e
`admin.routes.ts` + controller'a trends/community CRUD eklenmeli — şu an yalnızca templates yönetiliyor.
