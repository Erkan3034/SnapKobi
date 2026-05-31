import { prisma } from './database';
import { DEFAULT_AI_CONFIGS, DEFAULT_APP_SETTINGS } from './constants';

export async function seedAiConfigs() {
  try {
    for (const config of DEFAULT_AI_CONFIGS) {
      await prisma.aiConfig.upsert({
        where: { taskType: config.taskType },
        update: {},
        create: {
          taskType: config.taskType,
          provider: config.provider,
          activeModel: config.activeModel,
          apiUrl: config.apiUrl,
        },
      });
    }
    for (const setting of DEFAULT_APP_SETTINGS) {
      await prisma.appSetting.upsert({
        where: { key: setting.key },
        update: {},
        create: setting,
      });
    }
    console.log('✅ Default AI configurations seeded/verified');
  } catch (error) {
    console.error('❌ Failed to seed default AI configurations:', error);
  }
}
