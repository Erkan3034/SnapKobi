"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateBrandKitSchema = void 0;
const zod_1 = require("zod");
exports.updateBrandKitSchema = zod_1.z.object({
    primaryColor: zod_1.z.string().regex(/^#([0-9a-fA-F]{3}){1,2}$/, 'Invalid primary hex color').nullable().optional(),
    secondaryColor: zod_1.z.string().regex(/^#([0-9a-fA-F]{3}){1,2}$/, 'Invalid secondary hex color').nullable().optional(),
    logoPath: zod_1.z.string().nullable().optional(),
    preferredStyle: zod_1.z.string().nullable().optional(),
    toneOfVoice: zod_1.z.string().nullable().optional(),
});
