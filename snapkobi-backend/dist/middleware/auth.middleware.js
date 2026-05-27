"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.authenticate = authenticate;
const supabase_1 = require("../config/supabase");
const database_1 = require("../config/database");
async function authenticate(request, reply) {
    try {
        const authHeader = request.headers.authorization;
        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return reply.status(401).send({ error: 'Unauthorized: Missing or invalid token' });
        }
        const token = authHeader.substring(7);
        const { data: { user }, error } = await supabase_1.supabase.auth.getUser(token);
        if (error || !user) {
            return reply.status(401).send({ error: 'Unauthorized: Invalid token session' });
        }
        // Lazy provisioning: If user is not in AppUser table, create them with Free credits (5 credits)
        const appUser = await database_1.prisma.appUser.upsert({
            where: { id: user.id },
            update: {},
            create: {
                id: user.id,
                email: user.email,
                displayName: user.user_metadata?.full_name || user.email?.split('@')[0] || 'User',
                avatarUrl: user.user_metadata?.avatar_url || null,
                planType: 'free',
                creditsLeft: 5,
            },
        });
        request.user = {
            id: appUser.id,
            email: appUser.email,
        };
    }
    catch (err) {
        return reply.status(401).send({ error: 'Unauthorized: ' + err.message });
    }
}
