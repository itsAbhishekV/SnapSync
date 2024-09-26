import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapsync/features/exports.dart';

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

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    state = true;
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        username: username,
      );
      state = false;
    } catch (e) {
      state = false;
      throw Exception(e.toString());
    } finally {
      state = false;
    }
  }

  Future<void> verifyCode({
    required String email,
    required String code,
  }) async {
    state = true;
    try {
      await _authRepository.verifyCode(
        email: email,
        code: code,
      );
      state = false;
    } catch (e) {
      state = false;
      throw Exception(e.toString());
    } finally {
      state = false;
    }
  }
}
