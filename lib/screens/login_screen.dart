import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc for AuthCubit
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/cubits/auth/auth_cubit.dart'; // Import AuthCubit and AuthState
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/screens/signup_screen.dart';
import 'package:muhjaaa/widgets/custom_text_form_field.dart';
import 'package:muhjaaa/widgets/forgot_password_sheet.dart'; // Updated import if you moved it

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    // Pass context for Bloc access
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      // Call AuthCubit to login
      context.read<AuthCubit>().login(username, password);
    }
  }

  void _showForgotPasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext _) {
        // Use _ if context of builder isn't needed
        return const ForgotPasswordSheet(); // Assuming this provides its own BlocProvider
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigate to the main screen after successful login
            // Replace '/chat_list' with your actual main screen route if different
            // The Navigator.of(context).pushNamedAndRemoveUntil is often preferred here
            // to clear the auth stack.
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/chat_list',
              (Route<dynamic> route) => false,
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message, textAlign: TextAlign.right),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0, // Added some vertical padding
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Adjusted from center
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/images/Muhja_logo.svg', // Ensure asset exists
                        height:
                            MediaQuery.of(context).size.height *
                            0.22, // Adjusted size
                      ),
                      const SizedBox(height: 25), // Increased spacing
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
                        labelText: "اسم المستخدم أو البريد الإلكتروني",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: SvgPicture.asset(
                            'assets/icons/Message.svg', // Ensure asset exists
                            width: 22,
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
                          // Basic email validation (optional, can be more robust)
                          // if (value.contains('@') && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          //   return 'الرجاء إدخال بريد إلكتروني صحيح';
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormField(
                        controller: _passwordController,
                        labelText: "كلمة المرور",
                        obscureText: !_isPasswordVisible,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: SvgPicture.asset(
                            'assets/icons/Lock-icon.svg', // Ensure asset exists
                            width: 22,
                            height: 22,
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
                        alignment: Alignment
                            .centerLeft, // For RTL, this is the visual right
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () => _showForgotPasswordSheet(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                          ),
                          child: const Text(
                            "نسيت كلمة المرور؟",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14.0,
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Reduced space before button
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _handleLogin(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
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
                                "تسجيل الدخول",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: 25),
                      const Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: AppColors.lightGrey,
                              thickness: 0.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "أو سجل الدخول بواسطة",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13.0,
                                color: AppColors
                                    .darkGreyText70, // Using defined AppColor
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Expanded(
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
                            onTap: isLoading
                                ? null
                                : () {
                                    // TODO: Implement Google login
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Google login (Placeholder)",
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    );
                                  },
                            child: SvgPicture.asset(
                              'assets/icons/Google.svg',
                              width: 50,
                              height: 50,
                            ), // Ensure asset
                          ),
                          const SizedBox(width: 25),
                          InkWell(
                            onTap: isLoading
                                ? null
                                : () {
                                    // TODO: Implement Facebook login
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Facebook login (Placeholder)",
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    );
                                  },
                            child: SvgPicture.asset(
                              'assets/icons/Facebook.svg',
                              width: 50,
                              height: 50,
                            ), // Ensure asset
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => Navigator.push(
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
                                text: "ليس لديك حساب؟ ",
                                style: TextStyle(color: AppColors.darkGreyText),
                              ), // Adjusted color for better contrast
                              TextSpan(
                                text: "سجل الآن",
                                style: TextStyle(color: AppColors.primaryRed),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Padding at the bottom
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
