import { FastifyRequest, FastifyReply } from 'fastify';
import { supabase } from '../config/supabase';
import { prisma } from '../config/database';

declare module 'fastify' {
  interface FastifyRequest {
    user?: {
      id: string;
      email?: string;
      role: 'user' | 'admin';
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
    const creditRules = await prisma.appSetting.findUnique({ where: { key: 'credit_rules' } });
    const freeCredits = Number((creditRules?.value as any)?.plans?.free ?? 5);
    const appUser = await prisma.appUser.upsert({
      where: { id: user.id },
      update: {},
      create: {
        id: user.id,
        email: user.email!,
        displayName: user.user_metadata?.full_name || user.email?.split('@')[0] || 'User',
        avatarUrl: user.user_metadata?.avatar_url || null,
        planType: 'free',
        creditsLeft: freeCredits,
      },
    });

    request.user = {
      id: appUser.id,
      email: appUser.email,
      role: appUser.role,
    };
  } catch (err: any) {
    return reply.status(401).send({ error: 'Unauthorized: ' + err.message });
  }
}

export async function requireAdmin(request: FastifyRequest, reply: FastifyReply) {
  if (request.user?.role !== 'admin') {
    return reply.status(403).send({ error: 'Forbidden: Admin access required' });
  }
}
