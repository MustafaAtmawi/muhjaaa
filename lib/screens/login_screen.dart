import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure this import is present
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/screens/signup_screen.dart';
import 'package:muhjaaa/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Form is valid
      // TODO: Call context.read<AuthCubit>().login(...);
      print("Login form is valid. Placeholder for API call.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors
          .screenBackground, // Assuming you want the light off-white background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SvgPicture.asset(
                    // Using SVG for logo
                    'assets/images/Muhja_logo.svg',
                    height:
                        MediaQuery.of(context).size.height *
                        0.25, // Adjusted from 0.25 for better balance
                  ),
                  const SizedBox(height: 10), // Adjusted spacing
                  const Text(
                    "تسجيل الدخول",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: AppColors.darkGreyText,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    controller: _usernameController,
                    labelText: "اسم المستخدم",
                    prefixIcon: SvgPicture.asset(
                      // Consistent icon with Signup
                      'assets/icons/Message.svg',
                      width: 25,
                      height: 25,
                      colorFilter: const ColorFilter.mode(
                        AppColors.darkGreyText,
                        BlendMode.srcIn,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'الرجاء إدخال اسم المستخدم';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: "كلمة المرور",
                    obscureText: true,
                    prefixIcon: SvgPicture.asset(
                      'assets/icons/Lock-icon.svg',
                      width: 30,
                      height: 30,
                      colorFilter: const ColorFilter.mode(
                        AppColors.darkGreyText,
                        BlendMode.srcIn,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'الرجاء إدخال كلمة المرور';
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        /* TODO: Implement forgot password logic */
                      },
                      child: const Text(
                        "نسيت كلمة المرور؟",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.0,
                          color: AppColors.forgetPassword,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      "التسجيل",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Divider(
                          color: AppColors.lightGrey,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Or Continue with",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14.0,
                            color: AppColors.lightGrey,
                            fontWeight: FontWeight.normal,
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
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          /* TODO: Google login */
                        },
                        child: SvgPicture.asset(
                          'assets/icons/Google.svg',
                          width: 55,
                          height: 55,
                        ),
                      ),
                      const SizedBox(width: 25),
                      InkWell(
                        onTap: () {
                          /* TODO: Facebook login */
                        },
                        child: SvgPicture.asset(
                          'assets/icons/Facebook.svg',
                          width: 55,
                          height: 55,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    ),
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
                            text: "مستخدم جديد؟ ",
                            style: TextStyle(color: AppColors.mutedBlueGrey),
                          ),
                          TextSpan(
                            text: "سجل الآن",
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
      ),
    );
  }
}
