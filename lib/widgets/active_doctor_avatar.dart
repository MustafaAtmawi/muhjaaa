import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class ActiveDoctorAvatar extends StatelessWidget {
  final VoidCallback? onTap;
  final String placeholderLetter;

  const ActiveDoctorAvatar({
    super.key, // Use super.key
    this.onTap,
    required this.placeholderLetter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.mutedBlueGrey.withOpacity(0.5),
                child: Text(
                  placeholderLetter,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.white,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.positiveGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.screenBackground,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
