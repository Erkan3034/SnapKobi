import fastify from 'fastify';
import cors from '@fastify/cors';
import rateLimit from '@fastify/rate-limit';
import { aiConfigRoutes } from './modules/ai-config/ai-config.routes';
import { userRoutes } from './modules/users/users.routes';
import { brandKitRoutes } from './modules/brand-kit/brand-kit.routes';
import { productRoutes } from './modules/product/product.routes';
import { generationRoutes } from './modules/generation/generation.routes';
import { adminRoutes } from './modules/admin/admin.routes';
import { env } from './config/env';

const app = fastify({
  logger: {
    level: process.env.NODE_ENV === 'development' ? 'info' : 'warn',
  },
});

// Register CORS
app.register(cors, {
  origin: '*', // Adjust for production security if needed
});

// Register Rate Limiting
app.register(rateLimit, {
  max: 100,
  timeWindow: '1 minute',
});

// Global Error Handler
app.setErrorHandler((error, request, reply) => {
  app.log.error(error);
  
  if (error.statusCode) {
    return reply.status(error.statusCode).send({
      error: error.name,
      message: error.message,
    });
  }

  return reply.status(500).send({
    error: 'InternalServerError',
    message: 'An unexpected error occurred on the server',
  });
});

// Health check endpoint
app.get('/health', async () => {
  return { status: 'healthy', timestamp: new Date().toISOString() };
});

// Public browser configuration. The anon key is intentionally safe for clients;
// service-role and provider secrets must never be exposed here.
app.get('/v1/public-config', async (_request, reply) => {
  reply.header('Cache-Control', 'no-store');
  return {
    supabaseUrl: env.SUPABASE_URL,
    supabaseAnonKey: env.SUPABASE_ANON_KEY,
  };
});

// Register Modules
app.register(aiConfigRoutes, { prefix: '/v1/ai-configs' });
app.register(userRoutes, { prefix: '/v1/users' });
app.register(brandKitRoutes, { prefix: '/v1/brand-kit' });
app.register(productRoutes, { prefix: '/v1/products' });
app.register(generationRoutes, { prefix: '/v1/generations' });
app.register(adminRoutes, { prefix: '/v1/admin' });

// Not: AI config seed'i artik sunucu listen ettikten SONRA (index.ts'de) arka planda
// calisir. onReady icinde await edilmesi remote pooler gecikmesinde Fastify plugin
// timeout'una takilip sunucunun hic listen etmemesine yol aciyordu.

export default app;
