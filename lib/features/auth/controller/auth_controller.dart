import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapsync/features/exports.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {
    return AuthController(
      ref.watch(
        authRepositoryProvider,
      ),
    );
  },
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(false);

  Future<void> signUp(
      {required String email,
      required String password,
      required String username}) async {
    state = true;
    try {
      await _authRepository.signUp(
          email: email, password: password, username: username);
      state = false;
    } on AuthException catch (e) {
      state = false;
      throw AuthException(e.message);
    } catch (e) {
      state = false;
      throw Exception(e.toString());
    }
  }

  Future<void> loginWithPasscode(
      {required String email, required String passcode}) async {
    state = true;
    try {
      await _authRepository.loginWithPasscode(email: email, passcode: passcode);
      state = false;
    } on AuthException catch (e) {
      state = false;
      throw AuthException(e.message);
    } catch (e) {
      state = true;
      throw Exception(e.toString());
    }
  }
}
