import { FastifyRequest, FastifyReply } from 'fastify';
import { prisma } from '../../config/database';
import { updateBrandKitSchema } from './brand-kit.schema';

export async function getBrandKitHandler(request: FastifyRequest, reply: FastifyReply) {
  try {
    const userId = request.user?.id;
    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const brandKit = await prisma.brandKit.findUnique({
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
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}

export async function updateBrandKitHandler(request: FastifyRequest, reply: FastifyReply) {
  try {
    const userId = request.user?.id;
    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const result = updateBrandKitSchema.safeParse(request.body);
    if (!result.success) {
      return reply.status(400).send({
        error: 'Bad Request',
        message: 'Validation failed',
        details: result.error.format(),
      });
    }

    const brandKit = await prisma.brandKit.upsert({
      where: { userId },
      update: result.data,
      create: {
        userId,
        ...result.data,
      },
    });

    return reply.send(brandKit);
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}
