import { z } from 'zod';

export const updateAiConfigSchema = z.object({
  provider: z.string().min(1, 'Provider name is required'),
  activeModel: z.string().min(1, 'Active model name is required'),
  apiKey: z.string().nullable().optional(),
  apiUrl: z.string().url('Invalid API URL').nullable().optional(),
  settings: z.record(z.any()).optional(),
});

export type UpdateAiConfigInput = z.infer<typeof updateAiConfigSchema>;
