import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure this import is present
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/custom_text_form_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      // Form is valid
      // TODO: Call context.read<AuthCubit>().signup(...);
      print("Signup form is valid. Placeholder for API call.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors
          .screenBackground, // Assuming you want the light off-white background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SvgPicture.asset(
                // Using SVG for logo
                'assets/images/Muhja_logo.svg',
                height:
                    MediaQuery.of(context).size.height *
                    0.15, // Adjusted from 0.25 for better balance
              ),
              const SizedBox(height: 10), // Adjusted spacing
              const Text(
                'التسجيل',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreyText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: _usernameController,
                          labelText: 'اسم المستخدم',
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/Group.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.lightGrey,
                              BlendMode.srcIn,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'الرجاء إدخال اسم المستخدم';
                            if (value.length < 3)
                              return 'يجب أن لا يقل عن ٣ أحرف'; // Corrected message
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: _emailController,
                          labelText: 'البريد الالكتروني',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: AppColors.lightGrey,
                            size: 22,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'الرجاء إدخال البريد الإلكتروني';
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                              return 'الرجاء إدخال بريد إلكتروني صحيح';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: _firstNameController,
                                labelText: 'الاسم الأول',
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.lightGrey,
                                  size: 22,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'الرجاء إدخال الاسم الأول';
                                  if (value.length < 3)
                                    return 'يجب أن لا يقل عن ٣ أحرف'; // Corrected message
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextFormField(
                                controller: _lastNameController,
                                labelText: 'اسم العائلة',
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.lightGrey,
                                  size: 22,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'الرجاء إدخال اسم العائلة';
                                  if (value.length < 3)
                                    return 'يجب أن لا يقل عن ٣ أحرف'; // Corrected message
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: _passwordController,
                          labelText: 'كلمة المرور',
                          obscureText: !_isPasswordVisible,
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/Lock-icon.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.lightGrey,
                              BlendMode.srcIn,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.lightGrey,
                              size: 22,
                            ),
                            onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'الرجاء إدخال كلمة المرور';
                            if (value.length < 6)
                              return 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
                            if (!RegExp(r'(?=.*[A-Z])').hasMatch(value))
                              return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';
                            if (!RegExp(
                              r'(?=.*[!@#\$%^&*(),.?":{}|<>])',
                            ).hasMatch(value))
                              return 'يجب أن تحتوي كلمة المرور على رمز واحد على الأقل';
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _handleSignup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'التسجيل',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: AppColors.lightGrey,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Or Continue with',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: AppColors.lightGrey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: AppColors.lightGrey,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                /* TODO: Google signup */
                              },
                              child: SvgPicture.asset(
                                'assets/icons/Google.svg',
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 25),
                            InkWell(
                              onTap: () {
                                /* TODO: Facebook signup */
                              },
                              child: SvgPicture.asset(
                                'assets/icons/Facebook.svg',
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "لديك حساب؟ ",
                                  style: TextStyle(
                                    color: AppColors.mutedBlueGrey,
                                  ),
                                ),
                                TextSpan(
                                  text: "سجل الدخول",
                                  style: TextStyle(color: AppColors.primaryRed),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
