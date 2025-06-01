import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart'; // Assuming AppColors is in this path

class TermItem extends StatelessWidget {
  final String text;

  const TermItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0, left: 6.0),
            child: Text(
              "•",
              style: TextStyle(
                color: AppColors.primaryRed,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: AppColors.darkGreyText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
