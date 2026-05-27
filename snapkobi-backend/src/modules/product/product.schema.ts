import { z } from 'zod';
import { SectorType } from '@prisma/client';

export const createProductSchema = z.object({
  name: z.string().min(1, 'Product name is required'),
  price: z.number().nonnegative('Price must be a non-negative number').nullable().optional(),
  currency: z.string().default('TRY'),
  sector: z.nativeEnum(SectorType),
  description: z.string().nullable().optional(),
  tags: z.array(z.string()).default([]),
  thumbnailPath: z.string().nullable().optional(),
});

export const updateProductSchema = createProductSchema.partial();

export type CreateProductInput = z.infer<typeof createProductSchema>;
export type UpdateProductInput = z.infer<typeof updateProductSchema>;
