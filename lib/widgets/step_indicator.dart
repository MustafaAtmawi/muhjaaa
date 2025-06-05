import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart'; // Assuming AppColors is in this path

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        bool isActive = index == currentStep;
        bool isCompleted = index < currentStep;

        Color color;
        if (isActive) {
          color = AppColors.primaryRed;
        } else if (isCompleted) {
          color = AppColors.primaryRed.withOpacity(0.7);
        } else {
          color = AppColors.lightGrey.withOpacity(0.5);
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: isActive ? 24.0 : 12.0, // Make active step wider
          height: 8.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }
}
