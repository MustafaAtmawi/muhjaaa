import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryRed = Color(0xFFE7605A);
  static const Color primaryOrange = Color(0xFFf5b047);
  static const Color lightPink = Color(0xFFf1b7aa);
  static const Color mutedBlueGrey = Color(0xFF9AB5BD);
  static const Color lightGrey = Color(0xFF9DBDBB);
  static const Color screenBackground = Color(0xFFFFFFFF);
  static const Color darkGreyText = Color(0xFF646363); // RGB: 100, 99, 99
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color positiveGreen = Color(0xFF4CAF50);

  static const Color doctorChatItemBg = Color(0xFFFFF9F0);
  static const Color searchBarBg = Color(
    0xFFF0F0F0,
  ); // Also used for message input background
  static const Color forgetPassword = Color(0xFFE7605A);
  // static const Color messageInputBg = Color(0xFFEEF2F5); // searchBarBg is used instead
  static const Color messageInputHintText = Color(
    0xFF646363,
  ); // This is darkGreyText
  static const Color userMessageBg = Color(0xFFF5F5F5);

  static const Color aiMessageBubbleBg = Color(0xFFE0F7FA);

  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color chipBackground = Color(0xFFFEEBEA);
  static const Color chipText = primaryRed;
  static const Color unselectedButtonBorder = Color(0xFFE0E0E0);

  // New color for input bar icons (darkGreyText with 70% opacity)
  static const Color darkGreyText70 = Color.fromRGBO(100, 99, 99, 0.7);
}
