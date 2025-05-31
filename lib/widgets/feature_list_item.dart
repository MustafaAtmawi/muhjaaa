import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class FeatureListItem extends StatelessWidget {
  final String text;
  final Color iconBackgroundColor;

  const FeatureListItem({
    // Added const constructor
    super.key,
    required this.text,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: AppColors.white,
            size: 14,
          ), // Made Icon const
        ),
        const SizedBox(width: 12), // Made const
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              // Made const
              fontFamily: 'Cairo',
              fontSize: 14,
              color: AppColors.darkGreyText,
              height: 1.4,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
