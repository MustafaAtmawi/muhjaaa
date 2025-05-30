import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class FeatureListItem extends StatelessWidget {
  final String text;
  final Color iconBackgroundColor;

  const FeatureListItem({
    super.key, // Use super.key
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
          // If iconBackgroundColor is a const, this Icon can be const.
          // For safety, assuming iconBackgroundColor might not always be const from call site.
          child: const Icon(Icons.check, color: AppColors.white, size: 14),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
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
