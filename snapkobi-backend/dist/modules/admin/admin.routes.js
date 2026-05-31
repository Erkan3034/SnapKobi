"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.adminRoutes = adminRoutes;
const auth_middleware_1 = require("../../middleware/auth.middleware");
const admin_controller_1 = require("./admin.controller");
async function adminRoutes(fastify) {
    fastify.addHook('preHandler', auth_middleware_1.authenticate);
    fastify.addHook('preHandler', auth_middleware_1.requireAdmin);
    fastify.get('/bootstrap', admin_controller_1.getBootstrapHandler);
    fastify.post('/templates', admin_controller_1.createTemplateHandler);
    fastify.put('/templates/:id', admin_controller_1.updateTemplateHandler);
    fastify.delete('/templates/:id', admin_controller_1.deleteTemplateHandler);
    fastify.put('/settings/credit-rules', admin_controller_1.updateCreditRulesHandler);
}
