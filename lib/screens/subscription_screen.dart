import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/subscription/subscription_cubit.dart';
// import 'package:muhjaaa/models/subscription_plan_model.dart'; // Likely unused directly here
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
    context.read<SubscriptionCubit>().fetchSubscriptionPlans();
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
              // TODO: Navigate to a success screen or back, or update user profile
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios),
                            color: AppColors.darkGreyText,
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 200,
                            child: Image.asset(
                              'assets/images/Subscription_mama.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * 0.5 -
                                90 +
                                40,
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
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              // TODO: Navigate to terms and conditions screen/dialog
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
                          onPressed:
                              (_agreedToTerms &&
                                  _selectedPlanId != null &&
                                  state is! SubscriptionSubscribing)
                              ? () => _handleSubscription(_selectedPlanId!)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            disabledBackgroundColor: AppColors.lightGrey
                                .withAlpha((0.5 * 255).round()), // CORRECTED
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
                                          ), // CORRECTED
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                "حدث خطأ ما في تحميل الخطط.",
                textAlign: TextAlign.right,
              ),
            );
          },
        ),
      ),
    );
  }
}
