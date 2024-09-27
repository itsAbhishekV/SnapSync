import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snapsync/core/exports.dart';
import 'package:snapsync/features/exports.dart';
import 'package:snapsync/widgets/exports.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/';
  static const routePath = '/';

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void logOut(BuildContext context, WidgetRef ref) {
    ref.watch(authControllerProvider.notifier).signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SnapSync',
          style: TextStyle(
            color: Colors.deepPurple,
          ),
        ),
        actions: [
          if (user == null)
            GestureDetector(
                onTap: () {
                  context.go(LoginScreen.routePath);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
          if (user != null)
            GestureDetector(
              onTap: () {
                logOut(context, ref);
                print('state $user');
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: SnapSyncListView(),
      ),
      floatingActionButton: user == null
          ? null
          : FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.deepPurple,
              onPressed: () {
                context.showBottomSheet(
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: SnapSyncItemForm(),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                size: 24.0,
                color: Colors.white,
              ),
            ),
    );
  }
}
