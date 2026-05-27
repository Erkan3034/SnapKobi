import { FastifyRequest, FastifyReply } from 'fastify';
import { prisma } from '../../config/database';
import { updateProfileSchema } from './users.schema';

export async function getMeHandler(request: FastifyRequest, reply: FastifyReply) {
  try {
    const userId = request.user?.id;
    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const user = await prisma.appUser.findUnique({
      where: { id: userId },
    });

    if (!user) {
      return reply.status(404).send({ error: 'Not Found', message: 'User profile not found' });
    }

    return reply.send(user);
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}

export async function updateMeHandler(request: FastifyRequest, reply: FastifyReply) {
  try {
    const userId = request.user?.id;
    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const result = updateProfileSchema.safeParse(request.body);
    if (!result.success) {
      return reply.status(400).send({
        error: 'Bad Request',
        message: 'Validation failed',
        details: result.error.format(),
      });
    }

    const updated = await prisma.appUser.update({
      where: { id: userId },
      data: result.data,
    });

    return reply.send(updated);
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}
