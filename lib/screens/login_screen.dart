import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/screens/signup_screen.dart';
import 'package:muhjaaa/widgets/custom_text_form_field.dart';
import 'package:muhjaaa/widgets/forgot_password_sheet_widget.dart'; // Import the new widget

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Added for password visibility toggle

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
      print(
        "Login form is valid. Username: ${_usernameController.text}, Password: ${_passwordController.text}",
      );
      // Example: Navigate to ChatListScreen on successful login
      // Navigator.of(context).pushReplacementNamed('/chat_list');
    }
  }

  void _showForgotPasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Important for keyboard handling and custom height
      backgroundColor: Colors.transparent, // Make background transparent
      builder: (BuildContext context) {
        return const ForgotPasswordSheetWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
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
                    'assets/images/Muhja_logo.svg', // Ensure this asset exists
                    height:
                        MediaQuery.of(context).size.height *
                        0.25, // Adjusted size
                  ),
                  const SizedBox(height: 20),
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
                    labelText:
                        "اسم المستخدم أو البريد الإلكتروني", // Updated label
                    prefixIcon: Padding(
                      // Added padding for prefix icon
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SvgPicture.asset(
                        'assets/icons/Message.svg', // As per your assets
                        width: 22, // Adjusted size
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          AppColors.darkGreyText,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم المستخدم أو البريد الإلكتروني';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: "كلمة المرور",
                    obscureText: !_isPasswordVisible,
                    prefixIcon: Padding(
                      // Added padding for prefix icon
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SvgPicture.asset(
                        'assets/icons/Lock-icon.svg', // As per your assets
                        width: 22, // Adjusted size
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          AppColors.darkGreyText,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    suffixIcon: IconButton(
                      // Added suffix icon for visibility toggle
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.darkGreyText,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment:
                        Alignment.centerLeft, // For RTL, this will be top-right
                    child: TextButton(
                      onPressed: () {
                        _showForgotPasswordSheet(context);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      child: const Text(
                        "نسيت كلمة المرور؟",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.0,
                          color: AppColors
                              .primaryRed, // Changed color to primaryRed
                          fontWeight: FontWeight.w600, // Made it semi-bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Adjusted spacing
                  ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      textStyle: const TextStyle(
                        // Ensure text style for button text
                        fontFamily: 'Cairo',
                        fontSize: 18.0, // Adjusted size
                        fontWeight: FontWeight.bold, // Adjusted weight
                        color: AppColors.white,
                      ),
                    ),
                    child: const Text(
                      "تسجيل الدخول", // Changed from "التسجيل"
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25), // Adjusted spacing
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Divider(
                          color: AppColors.lightGrey,
                          thickness: 0.5, // Thinner divider
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "أو سجل الدخول بواسطة", // Changed text and style
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13.0,
                            color: AppColors.darkGreyText.withOpacity(0.7),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: AppColors.lightGrey,
                          thickness: 0.5,
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
                          // TODO: Google login
                          print("Google login tapped");
                        },
                        child: SvgPicture.asset(
                          'assets/icons/Google.svg', // As per your assets
                          width: 50, // Adjusted size
                          height: 50,
                        ),
                      ),
                      const SizedBox(width: 25),
                      InkWell(
                        onTap: () {
                          // TODO: Facebook login
                          print("Facebook login tapped");
                        },
                        child: SvgPicture.asset(
                          'assets/icons/Facebook.svg', // As per your assets
                          width: 50,
                          height: 50,
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
                          fontWeight: FontWeight.w600, // Semi-bold
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "ليس لديك حساب؟ ", // "Don't have an account?"
                            style: TextStyle(
                              color: AppColors.darkGreyText,
                            ), // Changed color
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
