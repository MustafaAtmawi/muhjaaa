import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart'; // Assuming AppColors is in this path

class PlanSelectionCard extends StatelessWidget {
  final String title;
  final String pricePerPeriod;
  final String totalPriceInfo;
  final String? discountInfo;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanSelectionCard({
    super.key,
    required this.title,
    required this.pricePerPeriod,
    required this.totalPriceInfo,
    this.discountInfo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : Colors.transparent,
            width: 2,
          ),
          boxShadow: const [
            // Made const
            BoxShadow(
              color: Color.fromRGBO(
                0,
                0,
                0,
                0.1,
              ), // Colors.black.withOpacity(0.1)
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 0,
                ), // Kept as is, assuming LTR context for padding here
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pricePerPeriod,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreyText,
                      ),
                    ),
                    if (discountInfo !=
                        null) // If there's a discount, show the RichText
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedBlueGrey,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: "$totalPriceInfo "),
                            const TextSpan(
                              text: "بدلاً من ",
                              style: TextStyle(color: AppColors.primaryRed),
                            ),
                            TextSpan(text: discountInfo),
                          ],
                        ),
                      ),
                    // The 'else' block that previously showed totalPriceInfo for non-discounted plans is now removed.
                    // This ensures that if discountInfo is null (like for the monthly plan),
                    // only the title and pricePerPeriod are shown above, achieving the two-line display.
                  ],
                ),
              ),
            ),
            // Radio button or check icon can go here if needed for selection indication
            // For now, using border as per original logic.
          ],
        ),
      ),
    );
  }
}
