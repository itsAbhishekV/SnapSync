import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapsync/core/exports.dart';
import 'package:snapsync/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://budxtodgnauruarfggps.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ1ZHh0b2RnbmF1cnVhcmZnZ3BzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjcyNzQ0MjMsImV4cCI6MjA0Mjg1MDQyM30.B3eQjH_LzED6hR2aDe-oAGJ_OiXR1BwbxMsWZ32PxlU',
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routes,
      theme: theme,
      title: 'SnapSync',
    );
  }
}
