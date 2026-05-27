"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getProductsHandler = getProductsHandler;
exports.getProductByIdHandler = getProductByIdHandler;
exports.createProductHandler = createProductHandler;
exports.updateProductHandler = updateProductHandler;
exports.deleteProductHandler = deleteProductHandler;
const database_1 = require("../../config/database");
const product_schema_1 = require("./product.schema");
async function getProductsHandler(request, reply) {
    try {
        const userId = request.user?.id;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const products = await database_1.prisma.product.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
        return reply.send(products);
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
async function getProductByIdHandler(request, reply) {
    try {
        const userId = request.user?.id;
        const { id } = request.params;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const product = await database_1.prisma.product.findFirst({
            where: { id, userId },
        });
        if (!product) {
            return reply.status(404).send({ error: 'Not Found', message: 'Product not found' });
        }
        return reply.send(product);
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
async function createProductHandler(request, reply) {
    try {
        const userId = request.user?.id;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const result = product_schema_1.createProductSchema.safeParse(request.body);
        if (!result.success) {
            return reply.status(400).send({
                error: 'Bad Request',
                message: 'Validation failed',
                details: result.error.format(),
            });
        }
        const product = await database_1.prisma.product.create({
            data: {
                userId,
                ...result.data,
            },
        });
        return reply.status(201).send(product); // 201 Created
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
async function updateProductHandler(request, reply) {
    try {
        const userId = request.user?.id;
        const { id } = request.params;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const existing = await database_1.prisma.product.findFirst({
            where: { id, userId },
        });
        if (!existing) {
            return reply.status(404).send({ error: 'Not Found', message: 'Product not found' });
        }
        const result = product_schema_1.updateProductSchema.safeParse(request.body);
        if (!result.success) {
            return reply.status(400).send({
                error: 'Bad Request',
                message: 'Validation failed',
                details: result.error.format(),
            });
        }
        const updated = await database_1.prisma.product.update({
            where: { id },
            data: result.data,
        });
        return reply.send(updated);
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
async function deleteProductHandler(request, reply) {
    try {
        const userId = request.user?.id;
        const { id } = request.params;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const existing = await database_1.prisma.product.findFirst({
            where: { id, userId },
        });
        if (!existing) {
            return reply.status(404).send({ error: 'Not Found', message: 'Product not found' });
        }
        await database_1.prisma.product.delete({
            where: { id },
        });
        return reply.status(204).send();
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
