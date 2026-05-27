"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateProductSchema = exports.createProductSchema = void 0;
const zod_1 = require("zod");
const client_1 = require("@prisma/client");
exports.createProductSchema = zod_1.z.object({
    name: zod_1.z.string().min(1, 'Product name is required'),
    price: zod_1.z.number().nonnegative('Price must be a non-negative number').nullable().optional(),
    currency: zod_1.z.string().default('TRY'),
    sector: zod_1.z.nativeEnum(client_1.SectorType),
    description: zod_1.z.string().nullable().optional(),
    tags: zod_1.z.array(zod_1.z.string()).default([]),
    thumbnailPath: zod_1.z.string().nullable().optional(),
});
exports.updateProductSchema = exports.createProductSchema.partial();
