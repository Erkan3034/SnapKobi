"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generationRoutes = generationRoutes;
const auth_middleware_1 = require("../../middleware/auth.middleware");
const generation_controller_1 = require("./generation.controller");
async function generationRoutes(fastify) {
    fastify.addHook('preHandler', auth_middleware_1.authenticate);
    fastify.post('/', generation_controller_1.createGenerationHandler);
    fastify.get('/', generation_controller_1.getGenerationsHandler);
    fastify.get('/:id', generation_controller_1.getGenerationByIdHandler);
}
