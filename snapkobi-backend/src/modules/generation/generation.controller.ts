import { FastifyRequest, FastifyReply } from 'fastify';
import { prisma } from '../../config/database';
import { createGenerationSchema } from './generation.schema';
import { runGenerationPipeline } from '../../ai/pipeline/pipeline.orchestrator';

export async function createGenerationHandler(request: FastifyRequest, reply: FastifyReply) {
  try {
    const userId = request.user?.id;
    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const result = createGenerationSchema.safeParse(request.body);
    if (!result.success) {
      return reply.status(400).send({
        error: 'Bad Request',
        message: 'Validation failed',
        details: result.error.format(),
      });
    }

    // Get user to check credits
    const user = await prisma.appUser.findUnique({
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
    const [_, generation] = await prisma.$transaction([
      prisma.appUser.update({
        where: { id: userId },
        data: { creditsLeft: { decrement: 1 } },
      }),
      prisma.generation.create({
        data: {
          userId,
          originalImagePath,
          originalImageSize: originalImageSize ?? null,
          sector,
          platform,
          options: options as any,
        },
      }),
    ]);

    // Run the generation pipeline asynchronously in the background
    setImmediate(() => {
      runGenerationPipeline(generation.id).catch((err) => {
        console.error(`💥 Background generation execution failed for ID ${generation.id}:`, err);
      });
    });

    return reply.status(201).send(generation);
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}

export async function getGenerationsHandler(request: FastifyRequest, reply: FastifyReply) {
  try {
    const userId = request.user?.id;
    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const generations = await prisma.generation.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });

    return reply.send(generations);
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}

export async function getGenerationByIdHandler(
  request: FastifyRequest<{ Params: { id: string } }>,
  reply: FastifyReply
) {
  try {
    const userId = request.user?.id;
    const { id } = request.params;

    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const generation = await prisma.generation.findFirst({
      where: { id, userId },
    });

    if (!generation) {
      return reply.status(404).send({ error: 'Not Found', message: 'Generation record not found' });
    }

    return reply.send(generation);
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}
