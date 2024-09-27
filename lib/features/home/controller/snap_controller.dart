import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapsync/features/exports.dart';
import 'package:snapsync/models/snap_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final snapControllerProvider =
    StateNotifierProvider<SnapController, AsyncValue<List<SnapModel>>>(
  (ref) {
    return SnapController(
      snapRepository: ref.watch(snapRepositoryProvider),
    );
  },
);

class SnapController extends StateNotifier<AsyncValue<List<SnapModel>>> {
  final SnapRepository snapRepository;

  SnapController({
    required this.snapRepository,
  }) : super(const AsyncValue.loading()) {
    getSnaps();
  }

  Future<void> getSnaps() async {
    state = await AsyncValue.guard(() async {
      initSnapChannel();
      final snaps = await snapRepository.getSnaps();
      return snaps;
    });
  }

  void initSnapChannel() {
    final snapChannel = snapRepository.snapChannel;
    snapChannel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'memories',
          callback: (payload) async {
            state = await AsyncValue.guard(() async {
              final snaps = await snapRepository.getSnaps();
              return snaps;
            });
          },
        )
        .subscribe();
  }

  Future<void> createSnap({
    required String title,
    required File file,
  }) async {
    state = const AsyncValue.loading();
    try {
      await snapRepository.createSnap(title: title, file: file);
      getSnaps();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}
