import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) {
    return AuthRepository();
  },
);

final class AuthRepository {
  final _supabaseClient = Supabase.instance.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final res = await _supabaseClient.auth
          .signUp(email: email, password: password, data: {
        'username': username,
      });
      return res;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AuthResponse> loginWithPasscode({
    required String email,
    required String passcode,
  }) async {
    try {
      final res = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: passcode,
      );
      return res;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
