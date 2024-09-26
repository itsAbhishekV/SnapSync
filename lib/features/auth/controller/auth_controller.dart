import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapsync/features/exports.dart';

enum AuthState { idle, loading, success, error }

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      ref.watch(
        authRepositoryProvider,
      ),
    );
  },
);

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(AuthState.idle);

  Future<void> signUp(
      {required String email,
      required String password,
      required String username}) async {
    state = AuthState.loading;
    try {
      await _authRepository.signUp(
          email: email, password: password, username: username);
      state = AuthState.success;
    } catch (e) {
      state = AuthState.error;
      throw Exception(e.toString());
    }
  }

  Future<void> loginWithPasscode(
      {required String email, required String passcode}) async {
    state = AuthState.loading;
    try {
      await _authRepository.loginWithPasscode(email: email, passcode: passcode);
      state = AuthState.success;
    } catch (e) {
      state = AuthState.error;
      throw Exception(e.toString());
    }
  }
}
