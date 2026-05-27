"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.productRoutes = productRoutes;
const auth_middleware_1 = require("../../middleware/auth.middleware");
const product_controller_1 = require("./product.controller");
async function productRoutes(fastify) {
    fastify.addHook('preHandler', auth_middleware_1.authenticate);
    fastify.get('/', product_controller_1.getProductsHandler);
    fastify.get('/:id', product_controller_1.getProductByIdHandler);
    fastify.post('/', product_controller_1.createProductHandler);
    fastify.put('/:id', product_controller_1.updateProductHandler);
    fastify.delete('/:id', product_controller_1.deleteProductHandler);
}
