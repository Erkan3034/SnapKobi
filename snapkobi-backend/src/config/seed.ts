import { prisma } from './database';
import { DEFAULT_AI_CONFIGS } from './constants';

export async function seedAiConfigs() {
  try {
    for (const config of DEFAULT_AI_CONFIGS) {
      await prisma.aiConfig.upsert({
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
  } catch (error) {
    console.error('❌ Failed to seed default AI configurations:', error);
  }
}
