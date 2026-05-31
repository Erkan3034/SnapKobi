import { z } from 'zod';

const optionalUrl = z.string().url().nullable().optional();

export const templateSchema = z.object({
  name: z.string().min(1),
  slug: z.string().min(1).regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/),
  description: z.string().nullable().optional(),
  thumbnailUrl: optionalUrl,
  category: z.string().min(1),
  isActive: z.boolean().default(true),
  isFeatured: z.boolean().default(false),
  sortOrder: z.number().int().default(0),
  displayWeek: z.coerce.date().nullable().optional(),
  backgroundSystemPrompt: z.string().nullable().optional(),
  videoSystemPrompt: z.string().nullable().optional(),
  captionSystemPrompt: z.string().nullable().optional(),
  captionUserPromptSuffix: z.string().nullable().optional(),
  applicablePlatforms: z.array(z.string()).default([]),
  defaultBackgroundStyle: z.string().default('studio_white'),
});

export const creditRulesSchema = z.object({
  plans: z.object({
    free: z.number().int().nonnegative(),
    starter: z.number().int().nonnegative(),
    pro: z.number().int().nonnegative(),
  }),
  costs: z.object({
    image: z.number().int().nonnegative(),
    video: z.number().int().nonnegative(),
    caption: z.number().int().nonnegative(),
  }),
});

export const settingSchema = z.object({
  value: creditRulesSchema,
});
