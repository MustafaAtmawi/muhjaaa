import 'package:flutter_bloc/flutter_bloc.dart'; // CHANGED IMPORT
import 'package:equatable/equatable.dart';
import 'package:muhjaaa/models/user_model.dart';
import 'package:muhjaaa/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(Unauthenticated());
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
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(Unauthenticated());
  }
}
