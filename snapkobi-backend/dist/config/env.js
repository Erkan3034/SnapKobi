"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.env = void 0;
const zod_1 = require("zod");
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
const envSchema = zod_1.z.object({
    DATABASE_URL: zod_1.z.string().min(1),
    DIRECT_DATABASE_URL: zod_1.z.string().min(1),
    SUPABASE_URL: zod_1.z.string().url(),
    SUPABASE_ANON_KEY: zod_1.z.string().min(1),
    SUPABASE_SERVICE_ROLE_KEY: zod_1.z.string().optional(),
    UPSTASH_REDIS_URL: zod_1.z.string().optional(),
    GOOGLE_AI_API_KEY: zod_1.z.string().optional(),
    ANTHROPIC_API_KEY: zod_1.z.string().optional(),
    FAL_KEY: zod_1.z.string().optional(),
    GEMINI_MODEL: zod_1.z.string().optional(),
    PORT: zod_1.z.coerce.number().default(3000),
    NODE_ENV: zod_1.z.enum(['development', 'staging', 'production']).default('development'),
});
const parsed = envSchema.safeParse(process.env);
if (!parsed.success) {
    console.error('❌ Invalid environment variables:', parsed.error.flatten().fieldErrors);
    process.exit(1);
}
exports.env = parsed.data;
