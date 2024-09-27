import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapsync/features/exports.dart';
import 'package:snapsync/models/snap_model.dart';

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

  SnapController({required this.snapRepository})
      : super(const AsyncValue.loading()) {
    _getSnaps();
  }

  Future<void> _getSnaps() async {
    state = await AsyncValue.guard(() async {
      final snaps = await snapRepository.getSnaps();
      return snaps;
    });
  }
}
