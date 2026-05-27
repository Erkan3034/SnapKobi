import { z } from 'zod';

export const updateBrandKitSchema = z.object({
  primaryColor: z.string().regex(/^#([0-9a-fA-F]{3}){1,2}$/, 'Invalid primary hex color').nullable().optional(),
  secondaryColor: z.string().regex(/^#([0-9a-fA-F]{3}){1,2}$/, 'Invalid secondary hex color').nullable().optional(),
  logoPath: z.string().nullable().optional(),
  preferredStyle: z.string().nullable().optional(),
  toneOfVoice: z.string().nullable().optional(),
});

export type UpdateBrandKitInput = z.infer<typeof updateBrandKitSchema>;
