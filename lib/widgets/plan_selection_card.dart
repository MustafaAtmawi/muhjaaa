import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

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
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(
                0,
                0,
                0,
                0.1,
              ), // Colors.black.withOpacity(0.1)
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
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
                    if (discountInfo != null)
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
                      )
                    else
                      Text(
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
          ],
        ),
      ),
    );
  }
}
