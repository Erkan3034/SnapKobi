import { FastifyRequest, FastifyReply } from 'fastify';
import { supabase } from '../config/supabase';
import { prisma } from '../config/database';

declare module 'fastify' {
  interface FastifyRequest {
    user?: {
      id: string;
      email?: string;
    };
  }
}

export async function authenticate(request: FastifyRequest, reply: FastifyReply) {
  try {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return reply.status(401).send({ error: 'Unauthorized: Missing or invalid token' });
    }

    const token = authHeader.substring(7);
    const { data: { user }, error } = await supabase.auth.getUser(token);

    if (error || !user) {
      return reply.status(401).send({ error: 'Unauthorized: Invalid token session' });
    }

    // Lazy provisioning: If user is not in AppUser table, create them with Free credits (5 credits)
    const appUser = await prisma.appUser.upsert({
      where: { id: user.id },
      update: {},
      create: {
        id: user.id,
        email: user.email!,
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
  } catch (err: any) {
    return reply.status(401).send({ error: 'Unauthorized: ' + err.message });
  }
}
