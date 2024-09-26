import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapsync/features/exports.dart';

final snapControllerProvider = StateNotifierProvider<SnapController,
    AsyncValue<List<Map<String, dynamic>>>>(
  (ref) {
    return SnapController(
      snapRepository: ref.watch(snapRepositoryProvider),
    );
  },
);

class SnapController
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final SnapRepository snapRepository;

  SnapController({required this.snapRepository})
      : super(const AsyncValue.loading()) {
    getSnaps();
  }

  Future<void> getSnaps() async {
    try {
      state = const AsyncValue.loading();

      final snaps = await snapRepository.getSnaps();

      state = AsyncValue.data(snaps);
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        e.toString(),
        stackTrace,
      );
    }
  }
}
