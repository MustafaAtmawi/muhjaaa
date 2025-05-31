import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/custom_text_form_field.dart';

class ForgotPasswordSheetWidget extends StatefulWidget {
  const ForgotPasswordSheetWidget({super.key});

  @override
  State<ForgotPasswordSheetWidget> createState() =>
      _ForgotPasswordSheetWidgetState();
}

class _ForgotPasswordSheetWidgetState extends State<ForgotPasswordSheetWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();

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

  void _nextPage() {
    FocusScope.of(context).unfocus(); // Dismiss keyboard before page change
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  String _getTitleForPage(int page) {
    switch (page) {
      case 0:
        return "نسيت كلمة المرور"; // Forget password
      case 1:
        return "أدخل الرمز من أربعة خانات"; // Enter the 4-digit code
      case 2:
        return "إعادة تعيين كلمة المرور"; // Reset password
      default:
        return "";
    }
  }

  double _getPageHeight() {
    // Adjusted heights based on content of each step
    // Test these values on different screen sizes
    switch (_currentPage) {
      case 0: // Email step
        return 280.0; // Approximate height for subtitle, 1 field, 1 button
      case 1: // OTP step
        return 280.0; // Approximate height for subtitle, OTP fields, 1 button
      case 2: // Reset Password step
        return 360.0; // Approximate height for subtitle, 2 fields, 1 button (was overflowing)
      default:
        return 280.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16.0, top: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Row(
              children: [
                if (_currentPage >
                    0) // "Back" button appears on the visual right (start in RTL)
                  SizedBox(
                    width: 70, // Give it some defined width
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
                      onPressed: _previousPage,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  )
                else
                  const SizedBox(
                    width: 70,
                  ), // Placeholder to balance title when no back button

                Expanded(
                  child: Text(
                    _getTitleForPage(_currentPage),
                    textAlign: TextAlign
                        .center, // Center title if back button exists or not
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreyText,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                ), // Invisible placeholder to help center title when back button is present
                // Or make it Opacity(opacity:0.0, child: same BackButton) for perfect balance
              ],
            ),
            const SizedBox(height: 20), // Spacing after header
            AnimatedContainer(
              // Animate height changes between pages
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _getPageHeight(),
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildEmailStep(),
                  _buildOtpStep(),
                  _buildResetPasswordStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailStep() {
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
              textAlign: TextAlign.center, // Center align as per screenshot
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: AppColors.darkGreyText,
                height: 1.5,
              ), // Matched style
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              controller: _emailController,
              hintText:
                  "أدخل بريدك الإلكتروني", // Use hintText to match screenshot
              // No prefixIcon as per screenshot image_d08f2c.png
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.right, // Text input aligned right
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
              onPressed: () {
                if (_emailFormKey.currentState!.validate()) {
                  print("Sending OTP to: ${_emailController.text}");
                  _nextPage();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ), // Adjusted padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ), // Consistent border radius
                textStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text("استمرار"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpInputCell(int index) {
    return SizedBox(
      width: 55, // Adjusted width from screenshot
      height: 55, // Adjusted height
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        maxLength: 1,
        style: const TextStyle(
          // Color for the input digits
          fontSize: 24,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          color: AppColors.primaryRed, // Digits color changed to red
        ),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
          ), // Adjusted for vertical centering
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded border
            borderSide: BorderSide(
              color: AppColors.lightGrey.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.lightGrey.withOpacity(0.3),
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
            _otpFocusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            // Auto-delete and move focus back (optional, can be tricky)
            if (_otpControllers[index].text.isEmpty) {
              // Check if current field is now empty
              _otpFocusNodes[index - 1].requestFocus();
            }
          }
        },
      ),
    );
  }

  Widget _buildOtpStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "أدخل الرمز المكون من أربعة خانات الذي تم إرساله الى بريدك الإلكتروني",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: AppColors.darkGreyText,
              height: 1.5,
            ), // Matched style
          ),
          const SizedBox(height: 24),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Spaced out OTP fields
              children: List.generate(4, (index) => _buildOtpInputCell(index)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final otp = _otpControllers
                  .map((controller) => controller.text)
                  .join();
              if (otp.length == 4) {
                print("Verifying OTP: $otp");
                _nextPage();
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
            child: const Text("استمرار"),
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordStep() {
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
              ), // Matched style
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              controller: _newPasswordController,
              hintText: "كلمة المرور الجديدة", // Using hintText
              obscureText: !_isNewPasswordVisible,
              textAlign: TextAlign.right,
              prefixIcon: Padding(
                // Icon on the right (start for RTL)
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SvgPicture.asset(
                  'assets/icons/Lock-icon.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    AppColors.lightGrey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: IconButton(
                // Icon on the left (end for RTL)
                icon: Icon(
                  _isNewPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.lightGrey,
                  size: 22,
                ),
                onPressed: () => setState(
                  () => _isNewPasswordVisible = !_isNewPasswordVisible,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'الرجاء إدخال كلمة المرور الجديدة';
                if (value.length < 6)
                  return 'يجب أن لا تقل كلمة المرور عن 6 أحرف';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _confirmPasswordController,
              hintText: "أعد إدخال كلمة المرور", // Using hintText
              obscureText: !_isConfirmPasswordVisible,
              textAlign: TextAlign.right,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SvgPicture.asset(
                  'assets/icons/Lock-icon.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    AppColors.lightGrey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.lightGrey,
                  size: 22,
                ),
                onPressed: () => setState(
                  () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'الرجاء إعادة إدخال كلمة المرور';
                if (value != _newPasswordController.text)
                  return 'كلمتا المرور غير متطابقتين';
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_resetPasswordFormKey.currentState!.validate()) {
                  print(
                    "Resetting password to: ${_newPasswordController.text}",
                  );
                  Navigator.of(context).pop();
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
              child: const Text("حدث كلمة المرور"),
            ),
          ],
        ),
      ),
    );
  }
}
