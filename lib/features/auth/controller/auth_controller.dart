import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapsync/features/exports.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) {
    return AuthController(
      ref.watch(authRepositoryProvider),
    );
  },
);

class AuthController extends StateNotifier<User?> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(null) {
    authStateListener();
  }

  Future<void> authStateListener() async {
    _authRepository.authState.listen(
      (AuthState event) {
        state = Supabase.instance.client.auth.currentUser;
        if (event.event == AuthChangeEvent.signedOut) {
          state = null;
        }
      },
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        username: username,
      );
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> loginWithPasscode({
    required String email,
    required String passcode,
  }) async {
    try {
      await _authRepository.loginWithPasscode(email: email, passcode: passcode);
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
