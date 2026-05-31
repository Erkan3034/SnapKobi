import { FastifyInstance } from 'fastify';
import { authenticate, requireAdmin } from '../../middleware/auth.middleware';
import {
  createTemplateHandler,
  deleteTemplateHandler,
  getBootstrapHandler,
  updateCreditRulesHandler,
  updateTemplateHandler,
} from './admin.controller';

export async function adminRoutes(fastify: FastifyInstance) {
  fastify.addHook('preHandler', authenticate);
  fastify.addHook('preHandler', requireAdmin);

  fastify.get('/bootstrap', getBootstrapHandler);
  fastify.post('/templates', createTemplateHandler);
  fastify.put('/templates/:id', updateTemplateHandler);
  fastify.delete('/templates/:id', deleteTemplateHandler);
  fastify.put('/settings/credit-rules', updateCreditRulesHandler);
}
