import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/auth/forgot_password_cubit.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/custom_text_form_field.dart';

class ForgotPasswordEmailStep extends StatefulWidget {
  final TextEditingController emailController;

  const ForgotPasswordEmailStep({super.key, required this.emailController});

  @override
  State<ForgotPasswordEmailStep> createState() =>
      _ForgotPasswordEmailStepState();
}

class _ForgotPasswordEmailStepState extends State<ForgotPasswordEmailStep> {
  final _emailFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    final cubitState = context.watch<ForgotPasswordCubit>().state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Form(
        key: _emailFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "أدخل بريدك الإلكتروني للحصول على رمز التحقق، سنرسل رمز مكون من 4 أرقام إلى بريدك الإلكتروني",
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
              controller: widget.emailController,
              hintText: "أدخل بريدك الإلكتروني",
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.right,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال البريد الإلكتروني';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'الرجاء إدخال بريد إلكتروني صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cubitState.isLoading
                  ? null
                  : () {
                      if (_emailFormKey.currentState!.validate()) {
                        cubit.submitEmail(widget.emailController.text.trim());
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
                      cubitState.currentStep == ForgotPasswordStep.email
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
      ),
    );
  }
}
