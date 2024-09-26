import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final snapRepositoryProvider = Provider<SnapRepository>(
  (ref) {
    return SnapRepository();
  },
);

class SnapRepository {
  final _supabaseClient = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getSnaps() async {
    try {
      final response = await _supabaseClient
          .from('memories')
          .select('id, title, created_at, image_id, profiles (id, username)')
          .order('created_at');

      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      throw Exception(e.toString());
    }
  }
}
