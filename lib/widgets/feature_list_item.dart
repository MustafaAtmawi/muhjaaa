import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart'; // Assuming you updated AppColors

class FeatureListItem extends StatelessWidget {
  final String text;
  final Color iconBackgroundColor;

  const FeatureListItem({
    super.key,
    required this.text,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Aligns icon and text better if text wraps
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: AppColors.white, size: 14),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: AppColors.darkGreyText, // Using AppColors
              height: 1.4, // Line height
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
