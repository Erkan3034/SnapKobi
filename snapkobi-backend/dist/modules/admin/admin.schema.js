"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.settingSchema = exports.creditRulesSchema = exports.templateSchema = void 0;
const zod_1 = require("zod");
const optionalUrl = zod_1.z.string().url().nullable().optional();
exports.templateSchema = zod_1.z.object({
    name: zod_1.z.string().min(1),
    slug: zod_1.z.string().min(1).regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/),
    description: zod_1.z.string().nullable().optional(),
    thumbnailUrl: optionalUrl,
    category: zod_1.z.string().min(1),
    isActive: zod_1.z.boolean().default(true),
    isFeatured: zod_1.z.boolean().default(false),
    sortOrder: zod_1.z.number().int().default(0),
    displayWeek: zod_1.z.coerce.date().nullable().optional(),
    backgroundSystemPrompt: zod_1.z.string().nullable().optional(),
    videoSystemPrompt: zod_1.z.string().nullable().optional(),
    captionSystemPrompt: zod_1.z.string().nullable().optional(),
    captionUserPromptSuffix: zod_1.z.string().nullable().optional(),
    applicablePlatforms: zod_1.z.array(zod_1.z.string()).default([]),
    defaultBackgroundStyle: zod_1.z.string().default('studio_white'),
});
exports.creditRulesSchema = zod_1.z.object({
    plans: zod_1.z.object({
        free: zod_1.z.number().int().nonnegative(),
        starter: zod_1.z.number().int().nonnegative(),
        pro: zod_1.z.number().int().nonnegative(),
    }),
    costs: zod_1.z.object({
        image: zod_1.z.number().int().nonnegative(),
        video: zod_1.z.number().int().nonnegative(),
        caption: zod_1.z.number().int().nonnegative(),
    }),
});
exports.settingSchema = zod_1.z.object({
    value: exports.creditRulesSchema,
});
