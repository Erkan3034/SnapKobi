"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateAiConfigSchema = void 0;
const zod_1 = require("zod");
exports.updateAiConfigSchema = zod_1.z.object({
    activeModel: zod_1.z.string().min(1, 'Active model name is required'),
    apiKey: zod_1.z.string().nullable().optional(),
    apiUrl: zod_1.z.string().url('Invalid API URL').nullable().optional(),
});
