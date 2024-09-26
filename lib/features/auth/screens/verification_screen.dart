import 'package:flutter/material.dart';

class VerificationPathParams {
  final String email;
  final String password;
  final String username;

  VerificationPathParams({
    required this.email,
    required this.password,
    required this.username,
  });
}

class VerificationScreen extends StatelessWidget {
  static const routeName = '/verification';
  static const routePath = '/verification';

  final VerificationPathParams pathParams;

  const VerificationScreen({super.key, required this.pathParams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Account Verification',
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
