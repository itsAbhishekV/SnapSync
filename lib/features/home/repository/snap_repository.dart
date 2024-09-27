import 'dart:io';

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

  RealtimeChannel get snapChannel {
    return _supabaseClient.channel('public:memories');
  }

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

  Future<void> createSnap({
    required String title,
    required File file,
  }) async {
    final profileId = _supabaseClient.auth.currentSession?.user.id;
    final imageId = file.path.split('/').last;

    if (profileId == null) {
      throw Exception('Failed to create snap $profileId $imageId');
    }

    await _supabaseClient.from('memories').insert({
      'title': title,
      'image_id': imageId,
      'profile_id': profileId,
    });

    await _supabaseClient.storage.from('memories').upload(
          '$profileId/$imageId',
          file,
        );
  }

  Future<void> updateSnap({
    required int id,
    required String title,
  }) async {
    final profileId = _supabaseClient.auth.currentSession?.user.id;

    if (profileId == null) {
      throw Exception('Failed to update snap $profileId');
    }

    try {
      await _supabaseClient
          .from('memories')
          .update({
            'title': title,
          })
          .eq('id', id)
          .eq('profile_id', profileId);
    } catch (e) {
      throw Exception('Failed to update snap $profileId $id');
    }
  }

  Future<void> deleteSnap(SnapModel snap) async {}
}
