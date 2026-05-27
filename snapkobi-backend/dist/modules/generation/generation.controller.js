"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createGenerationHandler = createGenerationHandler;
exports.getGenerationsHandler = getGenerationsHandler;
exports.getGenerationByIdHandler = getGenerationByIdHandler;
const database_1 = require("../../config/database");
const generation_schema_1 = require("./generation.schema");
const pipeline_orchestrator_1 = require("../../ai/pipeline/pipeline.orchestrator");
async function createGenerationHandler(request, reply) {
    try {
        const userId = request.user?.id;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const result = generation_schema_1.createGenerationSchema.safeParse(request.body);
        if (!result.success) {
            return reply.status(400).send({
                error: 'Bad Request',
                message: 'Validation failed',
                details: result.error.format(),
            });
        }
        // Get user to check credits
        const user = await database_1.prisma.appUser.findUnique({
            where: { id: userId },
        });
        if (!user) {
            return reply.status(404).send({ error: 'Not Found', message: 'User not found' });
        }
        if (user.creditsLeft <= 0) {
            return reply.status(403).send({ error: 'Forbidden', message: 'Insufficient credits' });
        }
        const { originalImagePath, originalImageSize, sector, platform, options } = result.data;
        // Deduct credit and create generation record
        const [_, generation] = await database_1.prisma.$transaction([
            database_1.prisma.appUser.update({
                where: { id: userId },
                data: { creditsLeft: { decrement: 1 } },
            }),
            database_1.prisma.generation.create({
                data: {
                    userId,
                    originalImagePath,
                    originalImageSize: originalImageSize ?? null,
                    sector,
                    platform,
                    options: options,
                },
            }),
        ]);
        // Run the generation pipeline asynchronously in the background
        setImmediate(() => {
            (0, pipeline_orchestrator_1.runGenerationPipeline)(generation.id).catch((err) => {
                console.error(`💥 Background generation execution failed for ID ${generation.id}:`, err);
            });
        });
        return reply.status(201).send(generation);
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
async function getGenerationsHandler(request, reply) {
    try {
        const userId = request.user?.id;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const generations = await database_1.prisma.generation.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
        return reply.send(generations);
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
async function getGenerationByIdHandler(request, reply) {
    try {
        const userId = request.user?.id;
        const { id } = request.params;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const generation = await database_1.prisma.generation.findFirst({
            where: { id, userId },
        });
        if (!generation) {
            return reply.status(404).send({ error: 'Not Found', message: 'Generation record not found' });
        }
        return reply.send(generation);
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
