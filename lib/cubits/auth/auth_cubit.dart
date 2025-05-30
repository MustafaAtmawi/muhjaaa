import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muhjaaa/models/user_model.dart';
import 'package:muhjaaa/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial());

  // Call this when the app starts to check if user is already logged in
  // For now, we'll assume unauthenticated initially.
  // In a real app, you'd check for a stored token.
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    // Simulate checking stored token
    await Future.delayed(const Duration(milliseconds: 500));
    // If you had a method like _authRepository.getCurrentUser()
    // final result = await _authRepository.getCurrentUser();
    // result.fold(
    //   (failure) => emit(Unauthenticated()),
    //   (user) => emit(Authenticated(user)),
    // );
    emit(Unauthenticated()); // Default to unauthenticated for now
  }

  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    final result = await _authRepository.login(username, password);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> signup({
    required String username,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    emit(AuthLoading());
    final result = await _authRepository.signup(
      username: username,
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(Authenticated(user)), // Automatically log in after signup
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(Unauthenticated());
  }
}
