"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateProfileSchema = void 0;
const zod_1 = require("zod");
const client_1 = require("@prisma/client");
exports.updateProfileSchema = zod_1.z.object({
    displayName: zod_1.z.string().min(1).optional(),
    avatarUrl: zod_1.z.string().url().nullable().optional(),
    sector: zod_1.z.nativeEnum(client_1.SectorType).optional(),
    language: zod_1.z.nativeEnum(client_1.Language).optional(),
});
