"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.redis = void 0;
const ioredis_1 = __importDefault(require("ioredis"));
const env_1 = require("./env");
const redisUrl = env_1.env.UPSTASH_REDIS_URL || 'redis://127.0.0.1:6379';
exports.redis = new ioredis_1.default(redisUrl, {
    maxRetriesPerRequest: null,
    lazyConnect: true, // Don't block app start if Redis is down
});
exports.redis.on('error', (err) => {
    console.warn('⚠️ Redis connection error:', err.message);
});
exports.redis.on('connect', () => {
    console.log('🔌 Redis connected successfully');
});
