import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  // In a real app, these would interact with an AuthRepository
  // final AuthRepository _authRepository;
  // ForgotPasswordCubit(this._authRepository) : super(const ForgotPasswordState());

  void submitEmail(String email) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, email: email, clearError: true));
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    // Example:
    // final result = await _authRepository.sendPasswordResetEmail(email);
    // result.fold(
    //   (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
    //   (_) => emit(state.copyWith(currentStep: ForgotPasswordStep.otp, isLoading: false)),
    // );
    print("Cubit: Sending OTP to $email"); // Placeholder
    emit(state.copyWith(currentStep: ForgotPasswordStep.otp, isLoading: false));
  }

  void submitOtp(String otp) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, clearError: true));
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    print("Cubit: Verifying OTP $otp"); // Placeholder
    // Example:
    // final result = await _authRepository.verifyOtp(state.email, otp);
    // result.fold(
    //   (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
    //   (_) => emit(state.copyWith(currentStep: ForgotPasswordStep.resetPassword, isLoading: false)),
    // );
    emit(
      state.copyWith(
        currentStep: ForgotPasswordStep.resetPassword,
        isLoading: false,
      ),
    );
  }

  void submitNewPassword(String newPassword, String confirmPassword) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, clearError: true));
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    print("Cubit: Resetting password to $newPassword"); // Placeholder
    // Example:
    // final result = await _authRepository.resetPassword(state.email, tempOtpToken, newPassword);
    // result.fold(
    //   (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
    //   (_) {
    //     emit(state.copyWith(isLoading: false)); // Or a specific success state
    //     // Navigation or success message typically handled by listener in UI
    //   },
    // );
    emit(state.copyWith(isLoading: false)); // Assuming success for now
  }

  void goToPreviousStep() {
    if (state.isLoading) return;
    switch (state.currentStep) {
      case ForgotPasswordStep.otp:
        emit(
          state.copyWith(
            currentStep: ForgotPasswordStep.email,
            clearError: true,
          ),
        );
        break;
      case ForgotPasswordStep.resetPassword:
        emit(
          state.copyWith(currentStep: ForgotPasswordStep.otp, clearError: true),
        );
        break;
      case ForgotPasswordStep.email:
        // This case implies closing the sheet, which should be handled by the view's back logic.
        break;
    }
  }

  void toggleNewPasswordVisibility() {
    if (state.isLoading) return;
    emit(state.copyWith(isNewPasswordVisible: !state.isNewPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    if (state.isLoading) return;
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }
}
