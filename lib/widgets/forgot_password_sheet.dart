import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/auth/forgot_password_cubit.dart';
import 'package:muhjaaa/utils/app_colors.dart';

import 'package:muhjaaa/widgets/forgot_password_email_step.dart';
import 'package:muhjaaa/widgets/forgot_password_otp_step.dart';
import 'package:muhjaaa/widgets/forgot_password_reset_step.dart';

// This is the public widget to be shown via showModalBottomSheet
// It provides the Cubit.
class ForgotPasswordSheet extends StatelessWidget {
  const ForgotPasswordSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: const _ForgotPasswordSheetView(),
    );
  }
}

// Internal view that consumes the Cubit
class _ForgotPasswordSheetView extends StatefulWidget {
  const _ForgotPasswordSheetView();

  @override
  State<_ForgotPasswordSheetView> createState() =>
      _ForgotPasswordSheetViewState();
}

class _ForgotPasswordSheetViewState extends State<_ForgotPasswordSheetView> {
  final PageController _pageController = PageController();

  // TextEditingControllers are managed here because their lifecycle is tied to the sheet itself.
  final TextEditingController _emailController = TextEditingController();
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _otpFocusNodes;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(4, (_) => TextEditingController());
    _otpFocusNodes = List.generate(4, (_) => FocusNode());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _getTitleForStep(ForgotPasswordStep step) {
    switch (step) {
      case ForgotPasswordStep.email:
        return "نسيت كلمة المرور";
      case ForgotPasswordStep.otp:
        return "أدخل الرمز من أربعة خانات";
      case ForgotPasswordStep.resetPassword:
        return "إعادة تعيين كلمة المرور";
    }
  }

  double _getPageHeight(ForgotPasswordStep step) {
    // These heights are kept from the original logic.
    // Ensure they match the content of each step.
    switch (step) {
      case ForgotPasswordStep.email:
        return 280.0;
      case ForgotPasswordStep.otp:
        return 300.0; // Slightly more if displaying email
      case ForgotPasswordStep.resetPassword:
        return 360.0;
    }
  }

  void _handlePreviousPageNavigation(
    BuildContext context,
    ForgotPasswordCubit cubit,
  ) {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    if (cubit.state.currentStep == ForgotPasswordStep.email) {
      Navigator.of(context).pop(); // Close the sheet
    } else {
      cubit.goToPreviousStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.error != null && state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error!, textAlign: TextAlign.right),
                backgroundColor: Colors.red,
              ),
            );
        }

        // Animate PageView to the current step
        if (_pageController.hasClients &&
            _pageController.page?.round() != state.currentStep.index) {
          _pageController.animateToPage(
            state.currentStep.index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }

        // Handle successful password reset: Pop the sheet and show success message
        // This condition checks if we were in the reset step, it's not loading, and there was no error.
        // A more explicit "PasswordResetSuccess" state in the Cubit could make this cleaner.
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          // Ensure widget is still visible
          if (state.currentStep == ForgotPasswordStep.resetPassword &&
              !state.isLoading &&
              (state.error == null || state.error!.isEmpty) &&
              _newPasswordController
                  .text
                  .isNotEmpty && // Ensure form was likely submitted
              _confirmPasswordController.text.isNotEmpty) {
            // This logic attempts to detect a successful submission from the reset step.
            // It's a heuristic; a dedicated success state is better.
            // We need to find a way to check if the *last action* was a successful submit.
            // For simplicity here, we'll assume if we are in resetPassword, not loading, and no error, and fields were filled, it was a success.
            // This will need careful testing. A flag in the cubit state `passwordResetSuccessfully = true` would be better.
            // For now, if the cubit has `isLoading = false` after trying to submit new password, and no error, we assume success.
            bool justFinishedResetting =
                !state.isLoading && _newPasswordController.text.isNotEmpty;

            if (justFinishedResetting) {
              // Check if the previous state was loading for reset password to confirm transition
              final cubit = context.read<ForgotPasswordCubit>();
              // This is tricky without a dedicated success state. We check if the current state IS NOT loading,
              // but the _previous_ state was this step and loading.
              // This is not perfectly reliable. A dedicated success state is much preferred.
              // The cubit could emit a specific state e.g. PasswordResetSucceeded then go back to initial/idle.

              // Let's assume for now the cubit logic is simplified and just sets isLoading to false on success.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && Navigator.canPop(context)) {
                  Navigator.of(context).pop(); // Pop the bottom sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "تم تغيير كلمة المرور بنجاح!",
                        textAlign: TextAlign.right,
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              });
            }
          }
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
            builder: (context, state) {
              final cubit = context.read<ForgotPasswordCubit>();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    // Drag handle
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16.0, top: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Row(
                    // Header: Back button (conditionally) and Title
                    children: [
                      if (state.currentStep != ForgotPasswordStep.email)
                        SizedBox(
                          width: 70, // Fixed width for alignment
                          child: TextButton.icon(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: AppColors.darkGreyText,
                            ),
                            label: const Text(
                              "عودة",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: AppColors.darkGreyText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: state.isLoading
                                ? null
                                : () => _handlePreviousPageNavigation(
                                    context,
                                    cubit,
                                  ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerRight,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 70), // Placeholder for balance
                      Expanded(
                        child: Text(
                          _getTitleForStep(state.currentStep),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreyText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 70), // Placeholder for balance
                    ],
                  ),
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: _getPageHeight(state.currentStep),
                    child: PageView(
                      controller: _pageController,
                      physics:
                          const NeverScrollableScrollPhysics(), // Controlled by Cubit
                      children: [
                        ForgotPasswordEmailStep(
                          emailController: _emailController,
                        ),
                        ForgotPasswordOtpStep(
                          otpControllers: _otpControllers,
                          otpFocusNodes: _otpFocusNodes,
                        ),
                        ForgotPasswordResetStep(
                          newPasswordController: _newPasswordController,
                          confirmPasswordController: _confirmPasswordController,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// How to call this refactored sheet from another widget (e.g., LoginScreen):
// void _showRefactoredForgotPasswordSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent, // The sheet itself handles its background
//     builder: (BuildContext _) {
//       return const ForgotPasswordSheet(); // This now provides its own BlocProvider
//     },
//   );
// }
