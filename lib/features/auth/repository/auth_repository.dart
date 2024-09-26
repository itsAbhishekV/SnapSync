import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

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
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AuthResponse> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final res = await _supabaseClient.auth.verifyOTP(
        type: OtpType.signup,
        email: email,
        token: code,
      );
      return res;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
