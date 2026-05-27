import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseGenerationDatasource {
  final SupabaseClient _client;

  const SupabaseGenerationDatasource(this._client);

  Stream<List<Map<String, dynamic>>> listenToGeneration(String id) {
    return _client
        .from('generations')
        .stream(primaryKey: ['id'])
        .eq('id', id);
  }
}
