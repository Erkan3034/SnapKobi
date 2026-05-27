"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.brandKitRoutes = brandKitRoutes;
const auth_middleware_1 = require("../../middleware/auth.middleware");
const brand_kit_controller_1 = require("./brand-kit.controller");
async function brandKitRoutes(fastify) {
    fastify.addHook('preHandler', auth_middleware_1.authenticate);
    fastify.get('/', brand_kit_controller_1.getBrandKitHandler);
    fastify.put('/', brand_kit_controller_1.updateBrandKitHandler);
}
