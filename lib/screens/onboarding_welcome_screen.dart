import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/utils/app_colors.dart'; // Ensure this path is correct

class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.screenBackground, // Or AppColors.white
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 2), // Pushes content down a bit
              // Muhja Logo
              SvgPicture.asset(
                'assets/images/Muhja_logo.svg', // VERIFY THIS PATH
                height:
                    screenHeight *
                    0.30, // Adjust size as seen in image_278c13.png
              ),
              const SizedBox(height: 24),

              // **** REPLACE THIS PLACEHOLDER with your actual illustration ****
              // Example: Image.asset('assets/images/mother_baby_illustration.png', height: screenHeight * 0.30)

              // **** END OF ILLUSTRATION PLACEHOLDER ****
              const SizedBox(height: 32),

              // Welcome Text 1
              const Text(
                "مرحباً بك في مُهجة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 26, // Prominent size
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreyText, // As per AppColors
                ),
              ),
              const SizedBox(height: 12),

              // Welcome Text 2
              const Text(
                "مساحة آمنة وحنونة...\nلأن أمومتك تستحق الدعم والاهتمام",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  color: AppColors
                      .mutedBlueGrey, // Softer color for secondary text
                  height: 1.5, // Line height for readability
                ),
              ),
              const Spacer(flex: 3), // Pushes button towards bottom
              // Action Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  minimumSize: const Size(
                    double.infinity,
                    56,
                  ), // Full width, standard height
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ), // Consistent border radius
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  // Navigate to the next screen
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection
                      .rtl, // Ensures text is to the right of icon in the Row
                  children: [
                    Text(
                      "ابدئي بخطوتك الأولى",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w600, // Bold or SemiBold
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    // The arrow in the image points left (←)
                    // In an LTR Row, Icons.arrow_back points left.
                    // Since the button's Row textDirection is RTL,
                    // an icon that points "forward" in RTL flow would be Icons.arrow_forward.
                    // However, to match the visual exactly (TEXT ←), and the text is already RTL:
                    // If Row is LTR (default child of button): [Text, SizedBox, Icon(Icons.arrow_back)]
                    // If Row is RTL: [Icon(Icons.arrow_forward), SizedBox, Text]
                    // The design has the arrow to the left of the text visually.
                    // Let's use default LTR for Row content and place icon after text.
                    Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ],
                ),
              ),
              const Spacer(flex: 1), // Some padding at the very bottom
            ],
          ),
        ),
      ),
    );
  }
}
