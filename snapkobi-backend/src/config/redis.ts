import Redis from 'ioredis';
import { env } from './env';

const redisUrl = env.UPSTASH_REDIS_URL || 'redis://127.0.0.1:6379';

export const redis = new Redis(redisUrl, {
  maxRetriesPerRequest: null,
  lazyConnect: true, // Don't block app start if Redis is down
});

redis.on('error', (err) => {
  console.warn('⚠️ Redis connection error:', err.message);
});

redis.on('connect', () => {
  console.log('🔌 Redis connected successfully');
});
