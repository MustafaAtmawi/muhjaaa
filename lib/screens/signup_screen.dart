import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/cubits/auth/auth_cubit.dart';
import 'package:muhjaaa/screens/chat_list_screen.dart';
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
      context.read<AuthCubit>().signup(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ChatListScreen()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, textAlign: TextAlign.right),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          bool isLoading = state is AuthLoading;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SvgPicture.asset(
                    'assets/images/Muhja_logo.svg',
                    height: MediaQuery.of(context).size.height * 0.23,
                  ),
                  const SizedBox(height: 10),
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
                              prefixIcon: Padding(
                                // Added padding
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/Person.svg',
                                  width: 20,
                                  height: 20,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.darkGreyText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال اسم المستخدم';
                                }
                                if (value.length < 3) {
                                  return 'يجب أن لا يقل عن ٣ أحرف';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormField(
                              controller: _emailController,
                              labelText: 'البريد الالكتروني',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Padding(
                                // Added padding
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Icon(
                                  Icons.email_outlined,
                                  color: AppColors.darkGreyText,
                                  size: 22,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال البريد الإلكتروني';
                                }
                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'الرجاء إدخال بريد إلكتروني صحيح';
                                }
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
                                    prefixIcon: Padding(
                                      // Added padding
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/Person.svg',
                                        width: 20,
                                        height: 20,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.darkGreyText,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال الاسم الأول';
                                      }
                                      if (value.length < 2) {
                                        return 'يجب أن لا يقل عن حرفين';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextFormField(
                                    controller: _lastNameController,
                                    labelText: 'اسم العائلة',
                                    prefixIcon: Padding(
                                      // Added padding
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/Person.svg',
                                        width: 20,
                                        height: 20,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.darkGreyText,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال اسم العائلة';
                                      }
                                      if (value.length < 2) {
                                        return 'يجب أن لا يقل عن حرفين';
                                      }
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
                              prefixIcon: Padding(
                                // Added padding
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/Lock-icon.svg',
                                  width: 20,
                                  height: 20,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.darkGreyText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.darkGreyText,
                                  size: 22,
                                ),
                                onPressed: () => setState(
                                  () =>
                                      _isPasswordVisible = !_isPasswordVisible,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال كلمة المرور';
                                }
                                if (value.length < 6) {
                                  return 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _handleSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Text(
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
                                    color: AppColors.darkGreyText,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'أو أكمل بواسطة',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: AppColors.darkGreyText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: AppColors.darkGreyText,
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
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          // print("Google signup tapped");
                                        },
                                  child: SvgPicture.asset(
                                    'assets/icons/Google.svg',
                                    width: 55,
                                    height: 55,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                InkWell(
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          // print("Facebook signup tapped");
                                        },
                                  child: SvgPicture.asset(
                                    'assets/icons/Facebook.svg',
                                    width: 55,
                                    height: 55,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
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
                                      style: TextStyle(
                                        color: AppColors.primaryRed,
                                      ),
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
          );
        },
      ),
    );
  }
}
