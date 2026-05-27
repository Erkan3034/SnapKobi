import { FastifyInstance } from 'fastify';
import { authenticate } from '../../middleware/auth.middleware';
import {
  getConfigByTaskHandler,
  getConfigsHandler,
  updateConfigHandler,
} from './ai-config.controller';

export async function aiConfigRoutes(fastify: FastifyInstance) {
  // Apply JWT authentication preHandler hook to all ai-config routes
  fastify.addHook('preHandler', authenticate);

  fastify.get('/', getConfigsHandler);
  fastify.get('/:taskType', getConfigByTaskHandler);
  fastify.put('/:taskType', updateConfigHandler);
}
