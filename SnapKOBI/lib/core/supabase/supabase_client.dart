import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class SupabaseClientProvider {
	static SupabaseClient get client => Supabase.instance.client;
}
