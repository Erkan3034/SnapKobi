"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const app_1 = __importDefault(require("./app"));
const env_1 = require("./config/env");
const start = async () => {
    try {
        const port = env_1.env.PORT;
        const host = '0.0.0.0';
        await app_1.default.listen({ port, host });
        console.log(`🚀 Server listening on http://${host}:${port}`);
    }
    catch (err) {
        app_1.default.log.error(err);
        process.exit(1);
    }
};
start();
