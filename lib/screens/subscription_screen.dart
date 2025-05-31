import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Kept in case FeatureListItem or PlanSelectionCard uses SVGs
import 'package:muhjaaa/cubits/subscription/subscription_cubit.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/feature_list_item.dart';
import 'package:muhjaaa/widgets/plan_selection_card.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String? _selectedPlanId;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    // Fetch subscription plans when the screen initializes
    // Ensure SubscriptionCubit is provided above this widget in the tree
    // For example, in your main.dart or a higher-level widget.
    // If not, this line will throw an error.
    // You might want to add a check or ensure it's always provided.
    // Future.microtask(() { // Ensure context is available if called directly in initState
    // context.read<SubscriptionCubit>().fetchSubscriptionPlans();
    // });
    // Or, if you are certain it's provided and context is safe to use:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Check if the widget is still in the tree
        context.read<SubscriptionCubit>().fetchSubscriptionPlans();
      }
    });
  }

  void _handleSubscription(String planId) {
    const String mockPaymentToken = "mock_payment_token_12345";
    context.read<SubscriptionCubit>().subscribeToPlan(planId, mockPaymentToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: SafeArea(
        child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
          listener: (context, state) {
            if (state is SubscriptionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, textAlign: TextAlign.right),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is SubscriptionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "تم الاشتراك بنجاح في الخطة ${state.planId}!",
                    textAlign: TextAlign.right,
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is SubscriptionInitial || state is SubscriptionLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryRed),
              );
            }

            if (state is SubscriptionPlansLoaded) {
              final plans = state.plans;
              // Default to selecting the first plan if none is selected yet and plans are available
              if (_selectedPlanId == null && plans.isNotEmpty) {
                _selectedPlanId = plans.first.id;
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // MODIFIED: Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios_new, // Points left
                              color: AppColors.darkGreyText,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 25),
                          // Blue square placeholder on the left
                          SvgPicture.asset(
                            // Using SVG for logo
                            'assets/images/Muhja_logo.svg',
                            height:
                                MediaQuery.of(context).size.height *
                                0.25, // Adjusted from 0.25 for better balance
                          ),
                          // Back button on the right
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
                        text:
                            '4 محادثات مجانية شهرياً مع أطباء وأخصائيين معتمدين.',
                        iconBackgroundColor: AppColors.positiveGreen,
                      ),
                      const SizedBox(height: 12),
                      const FeatureListItem(
                        text:
                            'معلومات مخصصة لطفلك،وتقارير دورية مبنية على تتبع طفلك',
                        iconBackgroundColor: AppColors.primaryOrange,
                      ),
                      const SizedBox(height: 32),
                      if (plans.isEmpty)
                        const Center(
                          child: Text(
                            "لا توجد خطط اشتراك متاحة حالياً.",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.lightGrey,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: plans.length,
                          itemBuilder: (context, index) {
                            final plan = plans[index];
                            return PlanSelectionCard(
                              title: plan.title,
                              pricePerPeriod: plan.pricePerPeriod,
                              totalPriceInfo: plan.totalPriceInfo,
                              discountInfo: plan.discountInfo,
                              isSelected: _selectedPlanId == plan.id,
                              onTap: () {
                                setState(() {
                                  _selectedPlanId = plan.id;
                                });
                              },
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                        ),
                      const SizedBox(height: 24),
                      // Terms and Conditions Row - Order remains Checkbox then Text for RTL consistency with image
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // To vertically align checkbox and text
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
                                .compact, // Added for tighter spacing
                            materialTapTargetSize: MaterialTapTargetSize
                                .shrinkWrap, // Added for tighter spacing
                          ),
                          const SizedBox(
                            width: 4,
                          ), // Spacing between checkbox and text
                          GestureDetector(
                            onTap: () {
                              // TODO: Implement navigation to Terms and Conditions screen or show a dialog
                              print("Navigate to Terms and Conditions");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "سيتم عرض الشروط والأحكام هنا.",
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'أوافق على الشروط والأحكام',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: AppColors.primaryRed, // Red color
                                decoration:
                                    TextDecoration.underline, // Underlined
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
                          onPressed:
                              (_agreedToTerms &&
                                  _selectedPlanId != null &&
                                  state is! SubscriptionSubscribing)
                              ? () => _handleSubscription(_selectedPlanId!)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            disabledBackgroundColor: AppColors.lightGrey
                                .withAlpha((0.5 * 255).round()),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: state is SubscriptionSubscribing
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  'اشتركي مع ماما مهجة',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        (_agreedToTerms &&
                                            _selectedPlanId != null)
                                        ? AppColors.white
                                        : AppColors.white.withAlpha(
                                            (0.7 * 255).round(),
                                          ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20), // Bottom padding
                    ],
                  ),
                ),
              );
            }
            // Fallback for any other unhandled states or if state is SubscriptionFailure but not caught by listener for UI build
            return const Center(
              child: Text(
                "حدث خطأ ما في تحميل الخطط أو حالة غير معروفة.",
                textAlign: TextAlign.right,
              ),
            );
          },
        ),
      ),
    );
  }
}
