import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class PlanSelectionCard extends StatelessWidget {
  final String title;
  final String pricePerPeriod;
  final String totalPriceInfo; // e.g., "₪150/سنوياً"
  final String? discountInfo; // e.g., "بدلاً من 180"
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
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Aligns content to the right in RTL
          children: [
            // Potentially an icon or radio button here in the future to the right (start)
            // For now, direct text content
            Expanded(
              // To allow text to take available space and wrap if necessary
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 0,
                ), // Original code had right:20, adjust if needed
                // If content is only text, this padding might not be necessary
                // or should be handled based on overall card content alignment
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Aligns text to the right in RTL
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize:
                            13, // As per original code for "إشتراك سنوي/شهري"
                        color: AppColors.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pricePerPeriod,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13, // As per original code
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreyText,
                      ),
                    ),
                    if (discountInfo != null) // Handle optional discount text
                      RichText(
                        textAlign: TextAlign.start, // Aligns to right in RTL
                        text: TextSpan(
                          style: const TextStyle(
                            // Default style for RichText
                            fontFamily: 'Cairo',
                            fontSize:
                                13, // Adjusted for consistency, original was 16px for this specific RichText
                            fontWeight: FontWeight.w600, // SemiBold
                            color: AppColors.mutedBlueGrey,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: "$totalPriceInfo "),
                            TextSpan(
                              text: "بدلاً من ",
                              style: const TextStyle(
                                color: AppColors.primaryRed,
                              ),
                            ),
                            TextSpan(text: discountInfo),
                          ],
                        ),
                      )
                    else
                      Text(
                        // Fallback if no discount info, just show total price
                        totalPriceInfo,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mutedBlueGrey,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Optional: A radio button or check icon on the left (end) side
            // if (isSelected) Icon(Icons.check_circle, color: AppColors.primaryRed)
            // else Icon(Icons.radio_button_unchecked, color: AppColors.lightGrey),
          ],
        ),
      ),
    );
  }
}
