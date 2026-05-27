import { FastifyRequest, FastifyReply } from 'fastify';
import { prisma } from '../../config/database';
import { createProductSchema, updateProductSchema } from './product.schema';

export async function getProductsHandler(request: FastifyRequest, reply: FastifyReply) {
  try {
    const userId = request.user?.id;
    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const products = await prisma.product.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });

    return reply.send(products);
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}

export async function getProductByIdHandler(
  request: FastifyRequest<{ Params: { id: string } }>,
  reply: FastifyReply
) {
  try {
    const userId = request.user?.id;
    const { id } = request.params;

    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const product = await prisma.product.findFirst({
      where: { id, userId },
    });

    if (!product) {
      return reply.status(404).send({ error: 'Not Found', message: 'Product not found' });
    }

    return reply.send(product);
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}

export async function createProductHandler(request: FastifyRequest, reply: FastifyReply) {
  try {
    const userId = request.user?.id;
    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const result = createProductSchema.safeParse(request.body);
    if (!result.success) {
      return reply.status(400).send({
        error: 'Bad Request',
        message: 'Validation failed',
        details: result.error.format(),
      });
    }

    const product = await prisma.product.create({
      data: {
        userId,
        ...result.data,
      },
    });

    return reply.status(201).send(product); // 201 Created
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}

export async function updateProductHandler(
  request: FastifyRequest<{ Params: { id: string } }>,
  reply: FastifyReply
) {
  try {
    const userId = request.user?.id;
    const { id } = request.params;

    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const existing = await prisma.product.findFirst({
      where: { id, userId },
    });

    if (!existing) {
      return reply.status(404).send({ error: 'Not Found', message: 'Product not found' });
    }

    const result = updateProductSchema.safeParse(request.body);
    if (!result.success) {
      return reply.status(400).send({
        error: 'Bad Request',
        message: 'Validation failed',
        details: result.error.format(),
      });
    }

    const updated = await prisma.product.update({
      where: { id },
      data: result.data,
    });

    return reply.send(updated);
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}

export async function deleteProductHandler(
  request: FastifyRequest<{ Params: { id: string } }>,
  reply: FastifyReply
) {
  try {
    const userId = request.user?.id;
    const { id } = request.params;

    if (!userId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const existing = await prisma.product.findFirst({
      where: { id, userId },
    });

    if (!existing) {
      return reply.status(404).send({ error: 'Not Found', message: 'Product not found' });
    }

    await prisma.product.delete({
      where: { id },
    });

    return reply.status(204).send();
  } catch (error: any) {
    return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
  }
}
