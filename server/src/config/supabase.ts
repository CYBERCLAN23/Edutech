import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { config } from './index';

let _supabase: SupabaseClient | null = null;

function getSupabase(): SupabaseClient {
  if (_supabase) return _supabase;

  if (!config.supabase.url) {
    throw new Error(
      'Supabase not configured. Create a .env file with SUPABASE_URL and SUPABASE_SERVICE_KEY. ' +
      'See .env.example for reference.'
    );
  }

  _supabase = createClient(config.supabase.url, config.supabase.serviceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
  return _supabase;
}

let _supabaseAnon: SupabaseClient | null = null;

export function getSupabaseAnon(): SupabaseClient {
  if (_supabaseAnon) return _supabaseAnon;

  if (!config.supabase.url) {
    throw new Error(
      'Supabase not configured. Create a .env file with SUPABASE_URL and SUPABASE_ANON_KEY. ' +
      'See .env.example for reference.'
    );
  }

  _supabaseAnon = createClient(config.supabase.url, config.supabase.anonKey);
  return _supabaseAnon;
}

export default getSupabase;
