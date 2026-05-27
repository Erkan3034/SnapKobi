"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getConfigsHandler = getConfigsHandler;
exports.getConfigByTaskHandler = getConfigByTaskHandler;
exports.updateConfigHandler = updateConfigHandler;
const database_1 = require("../../config/database");
const ai_config_schema_1 = require("./ai-config.schema");
async function getConfigsHandler(request, reply) {
    try {
        const configs = await database_1.prisma.aiConfig.findMany();
        // Mask sensitive keys
        const safeConfigs = configs.map(cfg => ({
            ...cfg,
            apiKey: cfg.apiKey ? '********' : null,
        }));
        return reply.send(safeConfigs);
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
async function getConfigByTaskHandler(request, reply) {
    try {
        const { taskType } = request.params;
        const config = await database_1.prisma.aiConfig.findUnique({
            where: { taskType },
        });
        if (!config) {
            return reply.status(404).send({ error: 'Not Found', message: `AI Config for ${taskType} not found` });
        }
        return reply.send({
            ...config,
            apiKey: config.apiKey ? '********' : null,
        });
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
async function updateConfigHandler(request, reply) {
    try {
        const { taskType } = request.params;
        // Validate body using Zod
        const result = ai_config_schema_1.updateAiConfigSchema.safeParse(request.body);
        if (!result.success) {
            return reply.status(400).send({
                error: 'Bad Request',
                message: 'Validation failed',
                details: result.error.format(),
            });
        }
        const { activeModel, apiKey, apiUrl } = result.data;
        // Build update data object
        const updateData = { activeModel };
        if (apiKey !== undefined)
            updateData.apiKey = apiKey;
        if (apiUrl !== undefined)
            updateData.apiUrl = apiUrl;
        const updated = await database_1.prisma.aiConfig.upsert({
            where: { taskType },
            update: updateData,
            create: {
                taskType,
                activeModel,
                apiKey: apiKey || null,
                apiUrl: apiUrl || null,
            },
        });
        return reply.send({
            ...updated,
            apiKey: updated.apiKey ? '********' : null,
        });
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
