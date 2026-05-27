import { FastifyInstance } from 'fastify';
import { authenticate } from '../../middleware/auth.middleware';
import {
  createProductHandler,
  deleteProductHandler,
  getProductByIdHandler,
  getProductsHandler,
  updateProductHandler,
} from './product.controller';

export async function productRoutes(fastify: FastifyInstance) {
  fastify.addHook('preHandler', authenticate);

  fastify.get('/', getProductsHandler);
  fastify.get('/:id', getProductByIdHandler);
  fastify.post('/', createProductHandler);
  fastify.put('/:id', updateProductHandler);
  fastify.delete('/:id', deleteProductHandler);
}
