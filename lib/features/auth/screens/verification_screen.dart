import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  static const routeName = '/verification';
  static const routePath = '/verification';

  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Verification',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
      ),
      body: const Center(
        child: Text('Verification'),
      ),
    );
  }
}
