import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapsync/features/exports.dart';
import 'package:snapsync/models/snap_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final likesProvider = StreamProvider.family<int, int>((ref, snapId) {
  return ref.watch(snapControllerProvider.notifier).getLikes(snapId);
});

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
    initSnapChannel();
  }

  Future<void> getSnaps() async {
    state = await AsyncValue.guard(() async {
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
            await getSnaps();
          },
        )
        .subscribe();
  }

  Stream<int> getLikes(int snapId) {
    return snapRepository.likes.map((likes) {
      return likes.where((like) => like['memory_id'] == snapId).length;
    });
  }

  Future<void> likeSnap(int snapId) async {
    try {
      await snapRepository.likeSnap(snapId);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> removeLike(int snapId) async {
    try {
      await snapRepository.removeLike(snapId);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createSnap({
    required String title,
    required File file,
  }) async {
    try {
      state = AsyncValue.data(state.value ?? []);

      await snapRepository.createSnap(title: title, file: file);
      await getSnaps();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateSnap({
    required int id,
    required String title,
  }) async {
    try {
      await snapRepository.updateSnap(id: id, title: title);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteSnap(SnapModel snap) async {
    try {
      state = AsyncValue.data(
        (state.value ?? []).where((s) => s.id != snap.id).toList(),
      );

      await snapRepository.deleteSnap(snap);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
