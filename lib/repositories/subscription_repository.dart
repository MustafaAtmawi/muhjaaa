import 'package:muhjaaa/models/subscription_plan_model.dart';
import 'package:muhjaaa/repositories/failure.dart';
import 'package:muhjaaa/utils/either.dart'; // For FutureEither type

class SubscriptionRepository {
  FutureEither<List<SubscriptionPlanModel>> getSubscriptionPlans() async {
    await Future.delayed(const Duration(seconds: 1));

    final List<SubscriptionPlanModel> mockPlans = [
      const SubscriptionPlanModel(
        id: 'yearly_plan_01',
        title: 'إشتراك سنوي',
        pricePerPeriod: '₪12.5/شهرياً',
        totalPriceInfo: '₪150/سنوياً',
        discountInfo: '180',
        isYearly: true,
      ),
      const SubscriptionPlanModel(
        id: 'monthly_plan_01',
        title: 'إشتراك شهري',
        pricePerPeriod: '₪15/شهرياً',
        totalPriceInfo: '₪15/شهرياً',
        discountInfo: null,
        isYearly: false,
      ),
    ];
    return Right(mockPlans);
  }

  FutureEither<bool> subscribeToPlan(String planId, String paymentToken) async {
    await Future.delayed(const Duration(seconds: 2));

    if (planId.isNotEmpty && paymentToken.isNotEmpty) {
      return const Right(true);
    } else {
      return const Left(
        Failure(
          "Subscription failed. Invalid plan or payment.",
          statusCode: 400,
        ),
      );
    }
  }
}
