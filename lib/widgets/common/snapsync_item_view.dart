import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:snapsync/core/exports.dart';
import 'package:snapsync/features/exports.dart';
import 'package:snapsync/models/exports.dart';
import 'package:snapsync/widgets/common/snapsync_item_form.dart';

class SnapSyncItemView extends ConsumerStatefulWidget {
  const SnapSyncItemView({super.key, required this.snap});

  final SnapModel snap;

  @override
  ConsumerState<SnapSyncItemView> createState() => _SnapSyncItemViewState();
}

class _SnapSyncItemViewState extends ConsumerState<SnapSyncItemView> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    final storageUrl = ref.watch(snapRepositoryProvider).storageUrl;
    final imageUrl =
        '$storageUrl/object/public/memories/${widget.snap.profile.id}/${widget.snap.imageId}?t=${DateTime.now().millisecondsSinceEpoch}';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (user != null && user.id == widget.snap.profile.id) {
            context.showBottomSheet(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SnapSyncItemForm(
                  snap: widget.snap,
                ),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10.0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header Section
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple[800]!,
                      Colors.blue[800]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap.profile.username,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.snap.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                        child: Icon(
                          isLiked
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: Colors.redAccent,
                          size: 22.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Image Section
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Shimmer Effect
                      SizedBox(
                        height: 110.0,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Actual Image
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
