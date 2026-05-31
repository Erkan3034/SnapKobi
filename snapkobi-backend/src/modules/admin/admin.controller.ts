import { FastifyReply, FastifyRequest } from 'fastify';
import { prisma } from '../../config/database';
import { env } from '../../config/env';
import { creditRulesSchema, settingSchema, templateSchema } from './admin.schema';

function maskConfig<T extends { apiKey: string | null; provider: string }>(config: T) {
  return {
    ...config,
    apiKey: config.apiKey ? '********' : null,
    effectiveApiKeyConfigured: hasConfiguredKey(config),
  };
}

function hasConfiguredKey(config: { apiKey: string | null; provider: string }) {
  if (config.apiKey) return true;

  switch (config.provider.toLowerCase()) {
    case 'pollinations':
      return Boolean(env.POLLINATIONS_KEY);
    case 'fal':
    case 'fal.ai':
      return Boolean(env.FAL_KEY);
    case 'openai':
    case 'chatgpt':
    case 'gpt':
      return Boolean(env.OPENAI_API_KEY);
    case 'gemini':
      return Boolean(env.GOOGLE_AI_API_KEY);
    default:
      return false;
  }
}

export async function getBootstrapHandler(_request: FastifyRequest, reply: FastifyReply) {
  const [templates, aiConfigs, creditRules] = await Promise.all([
    prisma.adminTemplate.findMany({ orderBy: [{ isFeatured: 'desc' }, { sortOrder: 'asc' }] }),
    prisma.aiConfig.findMany({ orderBy: { taskType: 'asc' } }),
    prisma.appSetting.findUnique({ where: { key: 'credit_rules' } }),
  ]);

  return reply.send({
    templates,
    aiConfigs: aiConfigs.map(maskConfig),
    creditRules: creditRules?.value ?? null,
  });
}

export async function createTemplateHandler(request: FastifyRequest, reply: FastifyReply) {
  const parsed = templateSchema.safeParse(request.body);
  if (!parsed.success) {
    return reply.status(400).send({ error: 'Validation failed', details: parsed.error.format() });
  }

  return reply.status(201).send(await prisma.adminTemplate.create({ data: parsed.data }));
}

export async function updateTemplateHandler(
  request: FastifyRequest<{ Params: { id: string } }>,
  reply: FastifyReply
) {
  const parsed = templateSchema.partial().safeParse(request.body);
  if (!parsed.success) {
    return reply.status(400).send({ error: 'Validation failed', details: parsed.error.format() });
  }

  return reply.send(await prisma.adminTemplate.update({
    where: { id: request.params.id },
    data: parsed.data,
  }));
}

export async function deleteTemplateHandler(
  request: FastifyRequest<{ Params: { id: string } }>,
  reply: FastifyReply
) {
  await prisma.adminTemplate.delete({ where: { id: request.params.id } });
  return reply.status(204).send();
}

export async function updateCreditRulesHandler(request: FastifyRequest, reply: FastifyReply) {
  const parsed = settingSchema.safeParse(request.body);
  if (!parsed.success) {
    return reply.status(400).send({ error: 'Validation failed', details: parsed.error.format() });
  }

  const value = creditRulesSchema.parse(parsed.data.value);
  return reply.send(await prisma.appSetting.upsert({
    where: { key: 'credit_rules' },
    update: { value },
    create: { key: 'credit_rules', value },
  }));
}
