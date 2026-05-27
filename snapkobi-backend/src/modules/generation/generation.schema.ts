import { z } from 'zod';
import { SectorType, PlatformType } from '@prisma/client';

export const createGenerationSchema = z.object({
  originalImagePath: z.string().min(1, 'Original image path is required'),
  originalImageSize: z.number().int().nonnegative().optional(),
  sector: z.nativeEnum(SectorType),
  platform: z.nativeEnum(PlatformType),
  options: z.record(z.any()).default({}),
});

export type CreateGenerationInput = z.infer<typeof createGenerationSchema>;
