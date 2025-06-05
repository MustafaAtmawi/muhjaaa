import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/models/category_model.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class CategoryFilterItem extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryFilterItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryRed.withOpacity(0.15)
                    : AppColors.searchBarBg,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: isSelected ? AppColors.primaryRed : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: SvgPicture.asset(
                category.iconAssetPath, // Ensure this asset exists
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.primaryRed : AppColors.darkGreyText70,
                  BlendMode.srcIn,
                ),
                width: 28,
                height: 28,
                placeholderBuilder: (_) =>
                    const Icon(Icons.category, color: AppColors.lightGrey),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.primaryRed
                    : AppColors.darkGreyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
