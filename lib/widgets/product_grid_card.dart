import 'package:flutter/material.dart';
import 'package:muhjaaa/models/product_model.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class ProductGridCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;

  const ProductGridCard({
    super.key,
    required this.product,
    this.onAddToCart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final priceString = '${product.price.toStringAsFixed(2)} ₪';

    return InkWell(
      onTap:
          onTap ??
          () {
            // Default tap action if none provided
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Tapped on ${product.name}",
                  textAlign: TextAlign.right,
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
      borderRadius: BorderRadius.circular(12.0),
      child: Card(
        elevation: 1.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  // **** MODIFIED PART: Replaced Image.asset with a placeholder Icon ****
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors
                          .searchBarBg, // A light background for the icon area
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.inventory_2_outlined, // Generic placeholder icon
                        size: 48, // Adjust size as needed
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ),
                  // **** END OF MODIFIED PART ****
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.name,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGreyText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    priceString,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  InkWell(
                    onTap:
                        onAddToCart ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${product.name} أضيف إلى السلة (مثال)",
                                textAlign: TextAlign.right,
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart_outlined,
                        size: 18,
                        color: AppColors.darkGreyText70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
