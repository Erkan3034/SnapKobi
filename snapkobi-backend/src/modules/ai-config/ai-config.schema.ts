import { z } from 'zod';

export const updateAiConfigSchema = z.object({
  activeModel: z.string().min(1, 'Active model name is required'),
  apiKey: z.string().nullable().optional(),
  apiUrl: z.string().url('Invalid API URL').nullable().optional(),
});

export type UpdateAiConfigInput = z.infer<typeof updateAiConfigSchema>;
