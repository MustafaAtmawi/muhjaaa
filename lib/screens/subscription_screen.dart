import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool _agreedToTermsCheckbox = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SubscriptionCubit>().fetchSubscriptionPlans();
      }
    });
  }

  void _actuallySubscribe(String planId) {
    const String mockPaymentToken = "mock_payment_token_12345";
    context.read<SubscriptionCubit>().subscribeToPlan(planId, mockPaymentToken);
  }

  void _showTermsAndConditionsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: const CircleAvatar(
                          radius: 35,
                          backgroundColor: AppColors.primaryRed,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 13,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                            color: AppColors.darkGreyText,
                          ),
                          label: const Text(
                            "عودة",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: AppColors.darkGreyText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(sheetContext).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 5, 24, 0),
                  child: const Text(
                    'شروط وأحكام الاشتراك في مهجة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreyText,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    children: [
                      const Text(
                        'قبل ما تكمل اشتراكك, ضروري تقرأى هاي الشروط:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color: AppColors.mutedBlueGrey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTermItem(
                        "الاشتراك المدفوع يوفر صلاحيات وخدمات خاصة داخل التطبيق.",
                      ),
                      _buildTermItem(
                        "بياناتك بأمان وتستخدم لتحسين تجربتك فقط! اقرئى مراجعة سياسة الخصوصية.",
                      ),
                      _buildTermItem(
                        "لا يوجد استرداد للمبلغ بعد الاشتراك, إلا بحالات خاصة مثل أعطال تقنية.",
                      ),
                      _buildTermItem(
                        "الاستخدام شخصي فقط, لا يجوز مشاركة حسابك مع غيرك.",
                      ),
                      _buildTermItem(
                        "أي استخدام مخالف من الممكن أن يتسبب في إلغاء اشتراكك.",
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'بالضغط على "أوافق", أنت توافقين على كل البنود.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGreyText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'أوافق',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      if (_selectedPlanId != null) {
                        _actuallySubscribe(_selectedPlanId!);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0, left: 6.0),
            child: Text(
              "•",
              style: TextStyle(
                color: AppColors.primaryRed,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: AppColors.darkGreyText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMainSubscribeButton() {
    if (_selectedPlanId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
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
    if (!_agreedToTermsCheckbox) {
      ScaffoldMessenger.of(context).showSnackBar(
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
    _showTermsAndConditionsSheet();
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
                const SnackBar(
                  content: Text(
                    "تم الاشتراك بنجاح!",
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
              if (_selectedPlanId == null && plans.isNotEmpty) {
                final yearlyPlan = plans.firstWhere(
                  (p) => p.isYearly,
                  orElse: () => plans.first,
                );
                _selectedPlanId = yearlyPlan.id;
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
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.darkGreyText,
                              size: 22,
                            ),
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            'assets/images/Muhja_logo.svg',
                            height: MediaQuery.of(context).size.height * 0.12,
                          ),
                          const Spacer(),
                          const SizedBox(
                            width: 40,
                          ), // To balance the IconButton
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _agreedToTermsCheckbox,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _agreedToTermsCheckbox = newValue ?? false;
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
                              if (_selectedPlanId != null ||
                                  (plans.isNotEmpty)) {
                                _showTermsAndConditionsSheet();
                              } else if (plans.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "لا توجد خطط متاحة حالياً لعرض الشروط.",
                                      textAlign: TextAlign.right,
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              } else {
                                // This case might occur if plans are still loading but state hasn't updated _selectedPlanId yet.
                                // Or if plans are empty from the start.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "الرجاء اختيار خطة أو الانتظار لتحميل الخطط أولاً.",
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
                          onPressed: (state is SubscriptionSubscribing)
                              ? null
                              : _handleMainSubscribeButton,
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
                                        (_agreedToTermsCheckbox &&
                                            _selectedPlanId != null)
                                        ? AppColors.white
                                        : AppColors.white.withAlpha(
                                            (0.7 * 255).round(),
                                          ),
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
