"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.supabase = void 0;
const supabase_js_1 = require("@supabase/supabase-js");
const env_1 = require("./env");
const ws_1 = __importDefault(require("ws"));
exports.supabase = (0, supabase_js_1.createClient)(env_1.env.SUPABASE_URL, env_1.env.SUPABASE_SERVICE_ROLE_KEY || env_1.env.SUPABASE_ANON_KEY, {
    auth: {
        persistSession: false,
        autoRefreshToken: false,
    },
    realtime: {
        transport: ws_1.default,
    },
});
