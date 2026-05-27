import { FastifyInstance } from 'fastify';
import { authenticate } from '../../middleware/auth.middleware';
import { getBrandKitHandler, updateBrandKitHandler } from './brand-kit.controller';

export async function brandKitRoutes(fastify: FastifyInstance) {
  fastify.addHook('preHandler', authenticate);

  fastify.get('/', getBrandKitHandler);
  fastify.put('/', updateBrandKitHandler);
}
