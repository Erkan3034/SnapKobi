import { FastifyRequest, FastifyReply } from 'fastify';
import { prisma } from '../../config/database';
import { updateAiConfigSchema } from './ai-config.schema';

export async function getConfigsHandler(request: FastifyRequest, reply: FastifyReply) {
  try {
    const configs = await prisma.aiConfig.findMany();
    // Mask sensitive keys
    const safeConfigs = configs.map(cfg => ({
      ...cfg,
      apiKey: cfg.apiKey ? '********' : null,
    }));
    return reply.send(safeConfigs);
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}

export async function getConfigByTaskHandler(
  request: FastifyRequest<{ Params: { taskType: string } }>,
  reply: FastifyReply
) {
  try {
    const { taskType } = request.params;
    const config = await prisma.aiConfig.findUnique({
      where: { taskType },
    });

    if (!config) {
      return reply.status(404).send({ error: 'Not Found', message: `AI Config for ${taskType} not found` });
    }

    return reply.send({
      ...config,
      apiKey: config.apiKey ? '********' : null,
    });
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}

export async function updateConfigHandler(
  request: FastifyRequest<{ Params: { taskType: string } }>,
  reply: FastifyReply
) {
  try {
    const { taskType } = request.params;

    // Validate body using Zod
    const result = updateAiConfigSchema.safeParse(request.body);
    if (!result.success) {
      return reply.status(400).send({
        error: 'Bad Request',
        message: 'Validation failed',
        details: result.error.format(),
      });
    }

    const { provider, activeModel, apiKey, apiUrl, settings } = result.data;

    // Build update data object
    const updateData: any = { provider, activeModel };
    if (apiKey !== undefined && apiKey !== '') updateData.apiKey = apiKey;
    if (apiUrl !== undefined) updateData.apiUrl = apiUrl;
    if (settings !== undefined) updateData.settings = settings;

    const updated = await prisma.aiConfig.upsert({
      where: { taskType },
      update: updateData,
      create: {
        taskType,
        provider,
        activeModel,
        apiKey: apiKey || null,
        apiUrl: apiUrl || null,
        settings: settings || {},
      },
    });

    return reply.send({
      ...updated,
      apiKey: updated.apiKey ? '********' : null,
    });
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}
