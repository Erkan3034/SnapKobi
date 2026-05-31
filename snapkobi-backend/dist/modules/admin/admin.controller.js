"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getBootstrapHandler = getBootstrapHandler;
exports.createTemplateHandler = createTemplateHandler;
exports.updateTemplateHandler = updateTemplateHandler;
exports.deleteTemplateHandler = deleteTemplateHandler;
exports.updateCreditRulesHandler = updateCreditRulesHandler;
const database_1 = require("../../config/database");
const env_1 = require("../../config/env");
const admin_schema_1 = require("./admin.schema");
function maskConfig(config) {
    return {
        ...config,
        apiKey: config.apiKey ? '********' : null,
        effectiveApiKeyConfigured: hasConfiguredKey(config),
    };
}
function hasConfiguredKey(config) {
    if (config.apiKey)
        return true;
    switch (config.provider.toLowerCase()) {
        case 'pollinations':
            return Boolean(env_1.env.POLLINATIONS_KEY);
        case 'fal':
        case 'fal.ai':
            return Boolean(env_1.env.FAL_KEY);
        case 'openai':
        case 'chatgpt':
        case 'gpt':
            return Boolean(env_1.env.OPENAI_API_KEY);
        case 'gemini':
            return Boolean(env_1.env.GOOGLE_AI_API_KEY);
        default:
            return false;
    }
}
async function getBootstrapHandler(_request, reply) {
    const [templates, aiConfigs, creditRules] = await Promise.all([
        database_1.prisma.adminTemplate.findMany({ orderBy: [{ isFeatured: 'desc' }, { sortOrder: 'asc' }] }),
        database_1.prisma.aiConfig.findMany({ orderBy: { taskType: 'asc' } }),
        database_1.prisma.appSetting.findUnique({ where: { key: 'credit_rules' } }),
    ]);
    return reply.send({
        templates,
        aiConfigs: aiConfigs.map(maskConfig),
        creditRules: creditRules?.value ?? null,
    });
}
async function createTemplateHandler(request, reply) {
    const parsed = admin_schema_1.templateSchema.safeParse(request.body);
    if (!parsed.success) {
        return reply.status(400).send({ error: 'Validation failed', details: parsed.error.format() });
    }
    return reply.status(201).send(await database_1.prisma.adminTemplate.create({ data: parsed.data }));
}
async function updateTemplateHandler(request, reply) {
    const parsed = admin_schema_1.templateSchema.partial().safeParse(request.body);
    if (!parsed.success) {
        return reply.status(400).send({ error: 'Validation failed', details: parsed.error.format() });
    }
    return reply.send(await database_1.prisma.adminTemplate.update({
        where: { id: request.params.id },
        data: parsed.data,
    }));
}
async function deleteTemplateHandler(request, reply) {
    await database_1.prisma.adminTemplate.delete({ where: { id: request.params.id } });
    return reply.status(204).send();
}
async function updateCreditRulesHandler(request, reply) {
    const parsed = admin_schema_1.settingSchema.safeParse(request.body);
    if (!parsed.success) {
        return reply.status(400).send({ error: 'Validation failed', details: parsed.error.format() });
    }
    const value = admin_schema_1.creditRulesSchema.parse(parsed.data.value);
    return reply.send(await database_1.prisma.appSetting.upsert({
        where: { key: 'credit_rules' },
        update: { value },
        create: { key: 'credit_rules', value },
    }));
}
