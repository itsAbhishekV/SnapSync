import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  Future<T?> showBottomSheet<T>({
    required Widget child,
  }) async {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: this,
      builder: (_) => child,
    );
  }
}
