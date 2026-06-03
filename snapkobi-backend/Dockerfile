# ─── SnapKOBİ Backend — Railway / Docker imajı ────────────────────────────────
FROM node:20-slim

WORKDIR /app

# Native bagimliliklar icin sistem kutuphaneleri:
#  - libgomp1  → onnxruntime-node (@imgly/background-removal-node) icin sart
#  - ca-certificates → HTTPS (Supabase, AI saglayicilari)
RUN apt-get update \
  && apt-get install -y --no-install-recommends libgomp1 ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Once sadece manifest'leri kopyala (katman cache'i icin)
COPY package*.json ./

# Tum bagimliliklar (tsc + prisma CLI build icin gerekli → dev dahil)
RUN npm ci

# Prisma client uret (DB baglantisi gerektirmez)
COPY prisma ./prisma
RUN npx prisma generate

# Kaynak + derleme
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

ENV NODE_ENV=production
# Railway $PORT'u runtime'da enjekte eder; kod env.PORT'u okur (varsayilan 3000).
EXPOSE 3000

CMD ["node", "dist/index.js"]
