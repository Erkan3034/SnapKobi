import app from './app';
import { env } from './config/env';
import { seedAiConfigs } from './config/seed';

const start = async () => {
  try {
    const port = env.PORT;
    const host = '0.0.0.0';

    await app.listen({ port, host });
    console.log(`🚀 Server listening on http://${host}:${port}`);

    // Seed'i listen'den SONRA, arka planda calistir (idempotent). Bloklamaz; remote DB
    // yavas olsa bile sunucu hemen istek almaya hazir olur.
    seedAiConfigs().catch((err) => console.error('⚠️ AI config seed failed:', err));
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};

start();
