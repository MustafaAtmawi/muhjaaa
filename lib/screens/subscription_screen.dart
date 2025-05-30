import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/feature_list_item.dart';
import 'package:muhjaaa/widgets/plan_selection_card.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlanIndex = 0; // 0 for Yearly, 1 for Monthly
  bool _agreedToTerms = false; // State for the checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      color: AppColors.darkGreyText,
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        'assets/images/Subscription_mama.png', // Ensure this asset exists
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5 - 90,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  'خطة الإشتراك',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreyText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const FeatureListItem(
                  text: 'وصول كامل لمحتوى تربوي وترفيهي لطفلك',
                  iconBackgroundColor: AppColors.positiveGreen,
                ),
                const SizedBox(height: 12),
                const FeatureListItem(
                  text:
                      'محادثات غير محدودة مع ال AI "ماما مهجة" لمساعدتك 24/7."',
                  iconBackgroundColor: AppColors.primaryOrange,
                ),
                const SizedBox(height: 12),
                const FeatureListItem(
                  text: '4 محادثات مجانية شهرياً مع أطباء وأخصائيين معتمدين.',
                  iconBackgroundColor: AppColors.positiveGreen,
                ),
                const SizedBox(height: 12),
                const FeatureListItem(
                  text: 'معلومات مخصصة لطفلك،وتقارير دورية مبنية على تتبع طفلك',
                  iconBackgroundColor: AppColors.primaryOrange,
                ),
                const SizedBox(height: 32),
                PlanSelectionCard(
                  title: 'إشتراك سنوي',
                  pricePerPeriod: '₪12.5/شهرياً',
                  totalPriceInfo: '₪150/سنوياً',
                  discountInfo: '180',
                  isSelected: _selectedPlanIndex == 0,
                  onTap: () {
                    setState(() {
                      _selectedPlanIndex = 0;
                    });
                  },
                ),
                const SizedBox(height: 16),
                PlanSelectionCard(
                  title: 'إشتراك شهري',
                  pricePerPeriod: '',
                  totalPriceInfo: '₪15/شهرياً',
                  isSelected: _selectedPlanIndex == 1,
                  onTap: () {
                    setState(() {
                      _selectedPlanIndex = 1;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _agreedToTerms = newValue ?? false;
                        });
                      },
                      activeColor: AppColors.primaryRed,
                      visualDensity: VisualDensity
                          .compact, // Makes checkbox slightly smaller
                      materialTapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // Reduces tap area slightly
                    ),
                    const SizedBox(
                      width: 4,
                    ), // Reduced space between checkbox and text
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to terms and conditions screen/dialog
                        print("Navigate to Terms and Conditions");
                      },
                      child: const Text(
                        'أوافق على الشروط والأحكام',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: AppColors.primaryRed,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _agreedToTerms
                        ? () {
                            // TODO: Implement subscription logic based on _selectedPlanIndex
                            print(
                              "Subscribing with plan index: $_selectedPlanIndex",
                            );
                          }
                        : null, // Button is disabled if terms are not agreed
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      disabledBackgroundColor: AppColors.lightGrey.withOpacity(
                        0.5,
                      ), // Style for disabled state
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'اشتركي مع ماما مهجة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _agreedToTerms
                            ? AppColors.white
                            : AppColors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
