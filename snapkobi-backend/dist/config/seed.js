"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.seedAiConfigs = seedAiConfigs;
const database_1 = require("./database");
const constants_1 = require("./constants");
async function seedAiConfigs() {
    try {
        for (const config of constants_1.DEFAULT_AI_CONFIGS) {
            await database_1.prisma.aiConfig.upsert({
                where: { taskType: config.taskType },
                update: {},
                create: {
                    taskType: config.taskType,
                    activeModel: config.activeModel,
                    apiUrl: config.apiUrl,
                },
            });
        }
        console.log('✅ Default AI configurations seeded/verified');
    }
    catch (error) {
        console.error('❌ Failed to seed default AI configurations:', error);
    }
}
