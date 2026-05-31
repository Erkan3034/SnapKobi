"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.aiConfigRoutes = aiConfigRoutes;
const auth_middleware_1 = require("../../middleware/auth.middleware");
const ai_config_controller_1 = require("./ai-config.controller");
async function aiConfigRoutes(fastify) {
    // Apply JWT authentication preHandler hook to all ai-config routes
    fastify.addHook('preHandler', auth_middleware_1.authenticate);
    fastify.addHook('preHandler', auth_middleware_1.requireAdmin);
    fastify.get('/', ai_config_controller_1.getConfigsHandler);
    fastify.get('/:taskType', ai_config_controller_1.getConfigByTaskHandler);
    fastify.put('/:taskType', ai_config_controller_1.updateConfigHandler);
}
