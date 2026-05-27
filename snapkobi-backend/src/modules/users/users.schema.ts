import { z } from 'zod';
import { SectorType, Language } from '@prisma/client';

export const updateProfileSchema = z.object({
  displayName: z.string().min(1).optional(),
  avatarUrl: z.string().url().nullable().optional(),
  sector: z.nativeEnum(SectorType).optional(),
  language: z.nativeEnum(Language).optional(),
});

export type UpdateProfileInput = z.infer<typeof updateProfileSchema>;
