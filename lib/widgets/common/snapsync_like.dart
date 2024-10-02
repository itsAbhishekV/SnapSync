import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:snapsync/features/exports.dart';
import 'package:snapsync/models/exports.dart';

class SnapSyncLike extends ConsumerStatefulWidget {
  const SnapSyncLike({super.key, required this.snap});

  final SnapModel snap;

  @override
  ConsumerState<SnapSyncLike> createState() => _SnapSyncLikeState();
}

class _SnapSyncLikeState extends ConsumerState<SnapSyncLike> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    final likeInfo = ref.watch(likesProvider(widget.snap));
    final info = likeInfo.asData?.value;
    final likes = info?.count ?? 0;

    return GestureDetector(
      onTap: () {
        if (user == null || likeInfo.isLoading) {
          return;
        } else {
          final backend = ref.read(snapControllerProvider.notifier);
          if (info?.isLiked == true) {
            backend.removeLike(widget.snap.id);
          } else {
            backend.likeSnap(widget.snap.id);
          }
        }
      },
      child: SizedBox(
        height: 22.0,
        width: likes == 0 ? 22.0 : 36.0,
        child: Row(
          children: [
            Icon(
              info?.isLiked == true
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              color: Colors.redAccent,
              size: 22.0,
            ),
            if (likes != 0) ...[
              const Gap(6.0),
              Flexible(
                child: Text(
                  '$likes',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
