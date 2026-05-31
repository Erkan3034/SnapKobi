"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fastify_1 = __importDefault(require("fastify"));
const cors_1 = __importDefault(require("@fastify/cors"));
const rate_limit_1 = __importDefault(require("@fastify/rate-limit"));
const ai_config_routes_1 = require("./modules/ai-config/ai-config.routes");
const users_routes_1 = require("./modules/users/users.routes");
const brand_kit_routes_1 = require("./modules/brand-kit/brand-kit.routes");
const product_routes_1 = require("./modules/product/product.routes");
const generation_routes_1 = require("./modules/generation/generation.routes");
const seed_1 = require("./config/seed");
const admin_routes_1 = require("./modules/admin/admin.routes");
const env_1 = require("./config/env");
const app = (0, fastify_1.default)({
    logger: {
        level: process.env.NODE_ENV === 'development' ? 'info' : 'warn',
    },
});
// Register CORS
app.register(cors_1.default, {
    origin: '*', // Adjust for production security if needed
});
// Register Rate Limiting
app.register(rate_limit_1.default, {
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
        supabaseUrl: env_1.env.SUPABASE_URL,
        supabaseAnonKey: env_1.env.SUPABASE_ANON_KEY,
    };
});
// Register Modules
app.register(ai_config_routes_1.aiConfigRoutes, { prefix: '/v1/ai-configs' });
app.register(users_routes_1.userRoutes, { prefix: '/v1/users' });
app.register(brand_kit_routes_1.brandKitRoutes, { prefix: '/v1/brand-kit' });
app.register(product_routes_1.productRoutes, { prefix: '/v1/products' });
app.register(generation_routes_1.generationRoutes, { prefix: '/v1/generations' });
app.register(admin_routes_1.adminRoutes, { prefix: '/v1/admin' });
// App ready hook to trigger DB seeding
app.addHook('onReady', async () => {
    await (0, seed_1.seedAiConfigs)();
});
exports.default = app;
