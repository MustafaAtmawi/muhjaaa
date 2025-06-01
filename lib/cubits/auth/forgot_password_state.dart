part of 'forgot_password_cubit.dart';

enum ForgotPasswordStep { email, otp, resetPassword }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStep currentStep;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool
  isLoading; // For async operations like submitting email/otp/password
  final String? error;
  final String email; // To pass email to OTP step message if needed

  const ForgotPasswordState({
    this.currentStep = ForgotPasswordStep.email,
    this.isNewPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isLoading = false,
    this.error,
    this.email = '',
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStep? currentStep,
    bool? isNewPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? email,
  }) {
    return ForgotPasswordState(
      currentStep: currentStep ?? this.currentStep,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    isNewPasswordVisible,
    isConfirmPasswordVisible,
    isLoading,
    error,
    email,
  ];
}
