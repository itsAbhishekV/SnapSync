import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapsync/models/snap_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final snapRepositoryProvider = Provider<SnapRepository>(
  (ref) {
    return SnapRepository();
  },
);

class SnapRepository {
  final _supabaseClient = Supabase.instance.client;

  String get storageUrl => _supabaseClient.storage.url;

  Future<List<SnapModel>> getSnaps() async {
    try {
      final response = await _supabaseClient
          .from('memories')
          .select('id, title, created_at, image_id, profiles (id, username)')
          .order('created_at');

      return response.map((json) => SnapModel.fromJson(json)).toList();
    } catch (e) {
      // print('Error fetching snaps: $e');
      // print(stackTrace);
      throw Exception('Failed to fetch snaps');
    }
  }
}
