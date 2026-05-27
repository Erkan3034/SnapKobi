"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createGenerationSchema = void 0;
const zod_1 = require("zod");
const client_1 = require("@prisma/client");
exports.createGenerationSchema = zod_1.z.object({
    originalImagePath: zod_1.z.string().min(1, 'Original image path is required'),
    originalImageSize: zod_1.z.number().int().nonnegative().optional(),
    sector: zod_1.z.nativeEnum(client_1.SectorType),
    platform: zod_1.z.nativeEnum(client_1.PlatformType),
    options: zod_1.z.record(zod_1.z.any()).default({}),
});
