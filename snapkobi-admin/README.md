# SnapKOBI Admin

Static admin panel for templates, runtime AI providers, API keys and credit rules.

## Run locally

Serve this directory with any static server, then open `index.html`:

```powershell
npx serve .
```

The backend URL must include `/v1`, for example `http://localhost:3000/v1`.
The panel loads the public `SUPABASE_URL` and `SUPABASE_ANON_KEY` values from
the backend runtime configuration endpoint. Keep those values in the backend
`.env` file. Service-role and AI provider secrets are never sent to the panel.

## First admin

After applying the Supabase migration, promote the owner account once:

```sql
UPDATE public.users SET role = 'admin' WHERE email = 'owner@example.com';
```

All panel API calls are protected by Supabase authentication and the backend
`requireAdmin` middleware. AI keys are masked in API responses.

## Recommended video configuration

Use Pollinations first:

```text
provider: pollinations
model: ltx-2
apiUrl: https://gen.pollinations.ai/video
```

The `ltx-2` model accepts an input image as its start frame. Configure a
Pollinations secret key in this panel. The backend uses `FAL_KEY` as a fallback
when Pollinations cannot produce a video.
