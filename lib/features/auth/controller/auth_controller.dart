import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapsync/features/exports.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserState {
  final bool isLoading;
  final User? user;

  UserState({required this.isLoading, this.user});

  UserState copyWith({bool? isLoading, User? user}) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user,
    );
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, UserState>(
  (ref) {
    return AuthController(
      ref.watch(authRepositoryProvider),
    );
  },
);

class AuthController extends StateNotifier<UserState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository)
      : super(UserState(isLoading: false, user: null)) {
    _authRepository.authState.listen((AuthState event) {
      if (event.event == AuthChangeEvent.signedOut) {
        state = state.copyWith(user: null);
      } else if (event.event == AuthChangeEvent.signedIn) {
        state = state.copyWith(user: event.session?.user);
      }
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        username: username,
      );
      state = state.copyWith(isLoading: false);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false);
      throw AuthException(e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception(e.toString());
    }
  }

  Future<void> loginWithPasscode({
    required String email,
    required String passcode,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.loginWithPasscode(email: email, passcode: passcode);
      state = state.copyWith(isLoading: false);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false);
      throw AuthException(e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception(e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.signOut();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, user: null);
      throw Exception(e.toString());
    }
  }
}
