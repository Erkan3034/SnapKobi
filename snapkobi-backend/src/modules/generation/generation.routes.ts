import { FastifyInstance } from 'fastify';
import { authenticate } from '../../middleware/auth.middleware';
import {
  createGenerationHandler,
  getGenerationByIdHandler,
  getGenerationsHandler,
} from './generation.controller';

export async function generationRoutes(fastify: FastifyInstance) {
  fastify.addHook('preHandler', authenticate);

  fastify.post('/', createGenerationHandler);
  fastify.get('/', getGenerationsHandler);
  fastify.get('/:id', getGenerationByIdHandler);
}
