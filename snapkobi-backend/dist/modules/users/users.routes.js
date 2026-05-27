"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.userRoutes = userRoutes;
const auth_middleware_1 = require("../../middleware/auth.middleware");
const users_controller_1 = require("./users.controller");
async function userRoutes(fastify) {
    fastify.addHook('preHandler', auth_middleware_1.authenticate);
    fastify.get('/me', users_controller_1.getMeHandler);
    fastify.put('/me', users_controller_1.updateMeHandler);
}
