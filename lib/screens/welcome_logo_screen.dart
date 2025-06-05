import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/utils/app_colors.dart'; // Assuming your AppColors are here

class WelcomeLogoScreen extends StatelessWidget {
  const WelcomeLogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Muhja Logo
              SvgPicture.asset(
                'assets/images/Muhja_Logo.svg', // Path to your logo
                height: screenHeight * 0.25, // Adjust size as needed
                // You can adjust width or use BoxFit if your SVG has specific aspect ratio needs
                // width: screenWidth * 0.6,
                // fit: BoxFit.contain,
              ),
              const SizedBox(height: 32), // Space between logo and text
              // Welcome Text
              const Text(
                "مرحبا بك في عالم مهجة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo', // Ensure 'Cairo' font is used
                  fontSize: 24, // Adjust font size as needed
                  fontWeight: FontWeight.bold,
                  color: AppColors
                      .darkGreyText, // Or another color from your AppColors
                ),
              ),
              // If you need any other elements later, they can be added here.
              // For now, it's just the logo and this text as requested.
            ],
          ),
        ),
      ),
    );
  }
}
