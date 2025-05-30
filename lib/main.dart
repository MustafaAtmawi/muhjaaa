import 'package:flutter/material.dart';
import 'package:muhjaaa/screens/ai_mama_chat_screen.dart';
import 'package:muhjaaa/screens/chat_list_screen.dart';
import 'package:muhjaaa/screens/conversation_screen.dart';
import 'package:muhjaaa/screens/login_screen.dart'; // Will be created next
import 'package:muhjaaa/screens/signup_screen.dart';
import 'package:muhjaaa/screens/subscription_screen.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/plan_selection_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muhjaaa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryRed,
        scaffoldBackgroundColor: AppColors.screenBackground,
        fontFamily: 'Cairo',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.screenBackground,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.darkGreyText),
          titleTextStyle: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.darkGreyText,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        textTheme: const TextTheme(
          // Example: Define default body text style if needed
          bodyLarge: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.darkGreyText,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.darkGreyText,
          ),
          // Define other text styles as needed globally or use them locally in widgets
          displayLarge: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.darkGreyText,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.darkGreyText,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.darkGreyText,
          ),
        ),
        // Ensure input decoration themes match the design for text fields
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: AppColors.lightGrey,
            fontFamily: 'Cairo',
            fontSize: 16.0,
          ),
          //border: OutlineInputBorder( // Default border style
          //  borderRadius: BorderRadius.circular(12.0),
          //  borderSide: BorderSide(color: AppColors.lightGrey),
          //),
          //enabledBorder: OutlineInputBorder(
          //  borderRadius: BorderRadius.circular(12.0),
          //  borderSide: BorderSide(color: AppColors.lightGrey),
          //),
          //focusedBorder: OutlineInputBorder(
          //  borderRadius: BorderRadius.circular(12.0),
          //  borderSide: BorderSide(color: AppColors.primaryRed),
          //),
          // Other properties like contentPadding can be set here if consistent
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: AppColors.white,
            textStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w600 /*Cairo SemiBold*/,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 24.0,
            ), // Default padding
          ),
        ),
      ),
      // Forcing RTL for the entire application as it's Arabic-only
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const SignupScreen(), // This will be our first screen
    );
  }
}
