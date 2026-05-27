import { FastifyInstance } from 'fastify';
import { authenticate } from '../../middleware/auth.middleware';
import { getMeHandler, updateMeHandler } from './users.controller';

export async function userRoutes(fastify: FastifyInstance) {
  fastify.addHook('preHandler', authenticate);

  fastify.get('/me', getMeHandler);
  fastify.put('/me', updateMeHandler);
}
