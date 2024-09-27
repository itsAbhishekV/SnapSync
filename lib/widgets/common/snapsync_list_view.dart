import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:snapsync/features/exports.dart';
import 'package:snapsync/widgets/common/snapsync_item_view.dart';

class SnapSyncListView extends ConsumerStatefulWidget {
  const SnapSyncListView({super.key});

  @override
  ConsumerState<SnapSyncListView> createState() => _SnapSyncListViewState();
}

class _SnapSyncListViewState extends ConsumerState<SnapSyncListView> {
  @override
  Widget build(BuildContext context) {
    final snapsState = ref.watch(snapControllerProvider);

    return snapsState.when(
      data: (snaps) {
        return snaps.isEmpty
            ? const Center(
                child: Text(
                  'No snaps found',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              )
            : MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                itemCount: snaps.length,
                itemBuilder: (context, index) {
                  final snap = snaps[index];
                  return SnapSyncItemView(
                    snap: snap,
                  );
                },
              );
      },
      error: (error, stackTrace) {
        // print(error);
        // print(stackTrace);
        return Text(error.toString());
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            strokeWidth: 1.2,
          ),
        );
      },
    );
  }
}
