import 'package:muhjaaa/models/subscription_plan_model.dart';
import 'package:muhjaaa/repositories/failure.dart';
import 'auth_repository.dart'; // For FutureEither type

class SubscriptionRepository {
  FutureEither<List<SubscriptionPlanModel>> getSubscriptionPlans() async {
    // TODO: Implement actual API call
    print('SubscriptionRepository: Fetching subscription plans');
    await Future.delayed(const Duration(seconds: 1));

    final List<SubscriptionPlanModel> mockPlans = [
      // Changed to List<SubscriptionPlanModel>
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
    return Right(mockPlans); // Return const Right if mockPlans is const
  }

  FutureEither<bool> subscribeToPlan(String planId, String paymentToken) async {
    // TODO: Implement actual API call to subscribe user to a plan
    print(
      'SubscriptionRepository: Subscribing to plan $planId with payment token $paymentToken',
    );
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
