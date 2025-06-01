import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muhjaaa/cubits/subscription/subscription_cubit.dart';
import 'package:muhjaaa/models/subscription_plan_model.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/feature_list_item.dart';
import 'package:muhjaaa/widgets/plan_selection_card.dart';
import 'package:muhjaaa/widgets/terms_and_conditions_sheet.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure Cubit is accessed only after build or via context safely
      if (mounted) {
        context.read<SubscriptionCubit>().fetchSubscriptionPlans();
      }
    });
  }

  void _showTermsSheet(BuildContext context) {
    final cubit = context.read<SubscriptionCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return TermsAndConditionsSheet(
          onAgreed: () {
            // This token would come from a payment SDK in a real app
            const String mockPaymentToken = "mock_payment_token_12345";
            cubit.subscribeToSelectedPlan(mockPaymentToken);
          },
        );
      },
    );
  }

  void _handleMainSubscribeButtonPressed(
    BuildContext context,
    SubscriptionPlansLoaded state,
  ) {
    final cubit = context.read<SubscriptionCubit>();
    if (state.selectedPlanId == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "الرجاء اختيار خطة اشتراك أولاً.",
              textAlign: TextAlign.right,
            ),
            backgroundColor: Colors.orange,
          ),
        );
      return;
    }
    if (!state.agreedToTerms) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "الرجاء الموافقة على الشروط والأحكام.",
              textAlign: TextAlign.right,
            ),
            backgroundColor: Colors.orange,
          ),
        );
      return;
    }
    // If already agreed and plan selected, show terms for confirmation, then subscribe
    _showTermsSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubscriptionCubit>();

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: SafeArea(
        child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
          listener: (context, state) {
            if (state is SubscriptionPlansLoaded &&
                state.error != null &&
                state.error!.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error!, textAlign: TextAlign.right),
                    backgroundColor: Colors.red,
                  ),
                );
            } else if (state is SubscriptionFailure) {
              // For initial plan loading failure
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message, textAlign: TextAlign.right),
                    backgroundColor: Colors.red,
                  ),
                );
            } else if (state is SubscriptionSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      "تم الاشتراك بنجاح!",
                      textAlign: TextAlign.right,
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              if (Navigator.canPop(context)) {
                Navigator.pop(context); // Pop subscription screen on success
              }
            }
          },
          builder: (context, state) {
            if (state is SubscriptionInitial || state is SubscriptionLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryRed),
              );
            }

            if (state is SubscriptionFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => cubit.fetchSubscriptionPlans(),
                      child: const Text("أعد المحاولة"),
                    ),
                  ],
                ),
              );
            }

            if (state is SubscriptionPlansLoaded) {
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
                        children: [
                          IconButton(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.darkGreyText,
                              size: 22,
                            ),
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            'assets/images/Muhja_logo.svg', // Ensure this asset exists
                            height: MediaQuery.of(context).size.height * 0.12,
                          ),
                          const Spacer(),
                          const SizedBox(width: 40), // Balance IconButton
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
                      if (state.plans.isEmpty)
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
                          itemCount: state.plans.length,
                          itemBuilder: (context, index) {
                            final plan = state.plans[index];
                            return PlanSelectionCard(
                              title: plan.title,
                              pricePerPeriod: plan.pricePerPeriod,
                              totalPriceInfo: plan.totalPriceInfo,
                              discountInfo: plan.discountInfo,
                              isSelected: state.selectedPlanId == plan.id,
                              onTap: () => cubit.selectPlan(plan.id),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                        ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: state.agreedToTerms,
                            onChanged: (bool? newValue) =>
                                cubit.toggleAgreeToTerms(newValue),
                            activeColor: AppColors.primaryRed,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              if (state.selectedPlanId != null ||
                                  state.plans.isNotEmpty) {
                                _showTermsSheet(context);
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "الرجاء اختيار خطة أولاً لعرض الشروط.",
                                        textAlign: TextAlign.right,
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                              }
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
                          onPressed: state.isSubscribing
                              ? null
                              : () => _handleMainSubscribeButtonPressed(
                                  context,
                                  state,
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            disabledBackgroundColor: const Color.fromRGBO(
                              157,
                              189,
                              187,
                              0.5,
                            ), // lightGrey with 0.5 opacity
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: state.isSubscribing
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
                                        (state.agreedToTerms &&
                                            state.selectedPlanId != null)
                                        ? AppColors.white
                                        : const Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            0.7,
                                          ), // white with 0.7 opacity
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
              child: Text("حالة غير معروفة.", textAlign: TextAlign.right),
            );
          },
        ),
      ),
    );
  }
}
