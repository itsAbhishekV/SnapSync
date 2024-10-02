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
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    final likesCount = ref.watch(likesProvider(widget.snap.id));
    final likes = likesCount.asData?.value;

    return GestureDetector(
      onTap: () {
        if (user == null || likesCount.isLoading) {
          return;
        } else {
          if (isLiked) {
            setState(() {
              isLiked = false;
            });
            ref
                .read(snapControllerProvider.notifier)
                .removeLike(widget.snap.id);
          } else {
            setState(() {
              isLiked = true;
            });
            ref.read(snapControllerProvider.notifier).likeSnap(widget.snap.id);
          }
        }
      },
      child: SizedBox(
        height: 22.0,
        width: likes == 0 ? 22.0 : 36.0,
        child: Row(
          children: [
            Icon(
              isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
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
