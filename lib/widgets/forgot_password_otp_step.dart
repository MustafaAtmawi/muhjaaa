import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/auth/forgot_password_cubit.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class ForgotPasswordOtpStep extends StatefulWidget {
  final List<TextEditingController> otpControllers;
  final List<FocusNode> otpFocusNodes;

  const ForgotPasswordOtpStep({
    super.key,
    required this.otpControllers,
    required this.otpFocusNodes,
  });

  @override
  State<ForgotPasswordOtpStep> createState() => _ForgotPasswordOtpStepState();
}

class _ForgotPasswordOtpStepState extends State<ForgotPasswordOtpStep> {
  Widget _buildOtpInputCell(BuildContext context, int index) {
    // Ensure FocusNodes are correctly initialized and disposed by the parent managing them
    // (ForgotPasswordSheet in this refactor)
    return SizedBox(
      width: 55,
      height: 55,
      child: TextFormField(
        controller: widget.otpControllers[index],
        focusNode: widget.otpFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          color: AppColors.primaryRed,
        ),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromRGBO(
                157,
                189,
                187,
                0.3,
              ), // AppColors.lightGrey.withOpacity(0.3)
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromRGBO(
                157,
                189,
                187,
                0.3,
              ), // AppColors.lightGrey.withOpacity(0.3)
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryRed,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: AppColors.white,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            widget.otpFocusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            if (widget.otpControllers[index].text.isEmpty) {
              // Check if current field is now empty
              widget.otpFocusNodes[index - 1].requestFocus();
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    final cubitState = context.watch<ForgotPasswordCubit>().state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "أدخل الرمز المكون من أربعة خانات الذي تم إرساله الى بريدك الإلكتروني${cubitState.email.isNotEmpty ? ' (${cubitState.email})' : ''}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: AppColors.darkGreyText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => _buildOtpInputCell(context, index),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: cubitState.isLoading
                ? null
                : () {
                    final otp = widget.otpControllers
                        .map((controller) => controller.text)
                        .join();
                    if (otp.length == 4) {
                      cubit.submitOtp(otp);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "الرجاء إدخال الرمز كاملاً",
                            textAlign: TextAlign.right,
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            child:
                cubitState.isLoading &&
                    cubitState.currentStep == ForgotPasswordStep.otp
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text("استمرار"),
          ),
        ],
      ),
    );
  }
}
