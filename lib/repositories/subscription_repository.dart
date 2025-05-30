import 'package:muhjaaa/models/subscription_plan_model.dart';
import 'package:muhjaaa/repositories/failure.dart';
import 'auth_repository.dart'; // For FutureEither type

class SubscriptionRepository {
  FutureEither<List<SubscriptionPlanModel>> getSubscriptionPlans() async {
    // TODO: Implement actual API call
    print('SubscriptionRepository: Fetching subscription plans');
    await Future.delayed(const Duration(seconds: 1));

    final mockPlans = [
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
        pricePerPeriod: '₪15/شهرياً', // Or empty if not applicable
        totalPriceInfo: '₪15/شهرياً',
        discountInfo: null,
        isYearly: false,
      ),
    ];
    return Right(mockPlans);
  }

  FutureEither<bool> subscribeToPlan(String planId, String paymentToken) async {
    // TODO: Implement actual API call to subscribe user to a plan
    // paymentToken would come from a payment gateway integration
    print(
      'SubscriptionRepository: Subscribing to plan $planId with payment token $paymentToken',
    );
    await Future.delayed(const Duration(seconds: 2));

    // Simulate success
    if (planId.isNotEmpty && paymentToken.isNotEmpty) {
      return const Right(true); // true for success
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
