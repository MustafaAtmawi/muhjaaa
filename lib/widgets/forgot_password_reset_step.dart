import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/cubits/auth/forgot_password_cubit.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/custom_text_form_field.dart';

class ForgotPasswordResetStep extends StatefulWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const ForgotPasswordResetStep({
    super.key,
    required this.newPasswordController,
    required this.confirmPasswordController,
  });

  @override
  State<ForgotPasswordResetStep> createState() =>
      _ForgotPasswordResetStepState();
}

class _ForgotPasswordResetStepState extends State<ForgotPasswordResetStep> {
  final _resetPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    final cubitState = context.watch<ForgotPasswordCubit>().state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
      child: Form(
        key: _resetPasswordFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "اختر كلمة سر جديدة لحسابك. لتتمكن من تسجيل الدخول للوصول إلى كافة الميزات",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: AppColors.darkGreyText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              controller: widget.newPasswordController,
              hintText: "كلمة المرور الجديدة",
              obscureText: !cubitState.isNewPasswordVisible,
              textAlign: TextAlign.right,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SvgPicture.asset(
                  'assets/icons/Lock-icon.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.lightGrey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  cubitState.isNewPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.lightGrey,
                  size: 22,
                ),
                onPressed: cubit.toggleNewPasswordVisibility,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال كلمة المرور الجديدة';
                }
                if (value.length < 6) {
                  return 'يجب أن لا تقل كلمة المرور عن 6 أحرف';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: widget.confirmPasswordController,
              hintText: "أعد إدخال كلمة المرور",
              obscureText: !cubitState.isConfirmPasswordVisible,
              textAlign: TextAlign.right,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SvgPicture.asset(
                  'assets/icons/Lock-icon.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.lightGrey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  cubitState.isConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.lightGrey,
                  size: 22,
                ),
                onPressed: cubit.toggleConfirmPasswordVisibility,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إعادة إدخال كلمة المرور';
                }
                if (value != widget.newPasswordController.text) {
                  return 'كلمتا المرور غير متطابقتين';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cubitState.isLoading
                  ? null
                  : () {
                      if (_resetPasswordFormKey.currentState!.validate()) {
                        cubit.submitNewPassword(
                          widget.newPasswordController.text,
                          widget.confirmPasswordController.text,
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
                      cubitState.currentStep == ForgotPasswordStep.resetPassword
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("حدث كلمة المرور"),
            ),
          ],
        ),
      ),
    );
  }
}
