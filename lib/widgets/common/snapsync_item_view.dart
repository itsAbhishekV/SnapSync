import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapsync/features/exports.dart';
import 'package:snapsync/models/exports.dart';

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
    final storageUrl = ref.watch(snapRepositoryProvider).storageUrl;
    final user = ref.watch(authControllerProvider).user;
    final imageUrl =
        '$storageUrl/object/public/memories/${widget.snap.profile.id}/${widget.snap.imageId}';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                  Colors.deepPurple[800]!, // Darker purple
                  Colors.blue[800]!, // Darker blue
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap.profile.username,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.snap.title,
                        style: const TextStyle(
                          fontSize: 16.0,
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
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800], // Placeholder color
                    height: 200.0,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                        size: 40.0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
