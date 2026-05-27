import { createClient } from '@supabase/supabase-js';
import { env } from './env';
import ws from 'ws';

export const supabase = createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY || env.SUPABASE_ANON_KEY, {
  auth: {
    persistSession: false,
    autoRefreshToken: false,
  },
  realtime: {
    transport: ws as any,
  },
});

