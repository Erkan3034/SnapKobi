"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getMeHandler = getMeHandler;
exports.updateMeHandler = updateMeHandler;
const database_1 = require("../../config/database");
const users_schema_1 = require("./users.schema");
async function getMeHandler(request, reply) {
    try {
        const userId = request.user?.id;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const user = await database_1.prisma.appUser.findUnique({
            where: { id: userId },
        });
        if (!user) {
            return reply.status(404).send({ error: 'Not Found', message: 'User profile not found' });
        }
        return reply.send(user);
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
async function updateMeHandler(request, reply) {
    try {
        const userId = request.user?.id;
        if (!userId) {
            return reply.status(401).send({ error: 'Unauthorized' });
        }
        const result = users_schema_1.updateProfileSchema.safeParse(request.body);
        if (!result.success) {
            return reply.status(400).send({
                error: 'Bad Request',
                message: 'Validation failed',
                details: result.error.format(),
            });
        }
        const updated = await database_1.prisma.appUser.update({
            where: { id: userId },
            data: result.data,
        });
        return reply.send(updated);
    }
    catch (error) {
        return reply.status(500).send({ error: 'Internal Server Error', message: error.message });
    }
}
