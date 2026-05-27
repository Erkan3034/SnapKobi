"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getBrandKitHandler = getBrandKitHandler;
exports.updateBrandKitHandler = updateBrandKitHandler;
const database_1 = require("../../config/database");
const brand_kit_schema_1 = require("./brand-kit.schema");
async function getBrandKitHandler(request, reply) {
    try {
        const userId = request.user?.id;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const brandKit = await database_1.prisma.brandKit.findUnique({
            where: { userId },
        });
        if (!brandKit) {
            // Return empty default state instead of 404 so UI doesn't crash on new profiles
            return reply.send({
                primaryColor: null,
                secondaryColor: null,
                logoPath: null,
                preferredStyle: null,
                toneOfVoice: null,
            });
        }
        return reply.send(brandKit);
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
async function updateBrandKitHandler(request, reply) {
    try {
        const userId = request.user?.id;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const result = brand_kit_schema_1.updateBrandKitSchema.safeParse(request.body);
        if (!result.success) {
            return reply.status(400).send({
                error: 'Bad Request',
                message: 'Validation failed',
                details: result.error.format(),
            });
        }
        const brandKit = await database_1.prisma.brandKit.upsert({
            where: { userId },
            update: result.data,
            create: {
                userId,
                ...result.data,
            },
        });
        return reply.send(brandKit);
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
