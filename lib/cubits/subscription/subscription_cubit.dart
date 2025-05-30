import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muhjaaa/models/subscription_plan_model.dart';
import 'package:muhjaaa/repositories/subscription_repository.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository _subscriptionRepository;

  SubscriptionCubit({required SubscriptionRepository subscriptionRepository})
    : _subscriptionRepository = subscriptionRepository,
      super(SubscriptionInitial());

  Future<void> fetchSubscriptionPlans() async {
    emit(SubscriptionLoading());
    final result = await _subscriptionRepository.getSubscriptionPlans();
    result.fold(
      (failure) => emit(SubscriptionFailure(failure.message)),
      (plans) => emit(SubscriptionPlansLoaded(plans)),
    );
  }

  Future<void> subscribeToPlan(String planId, String paymentToken) async {
    emit(SubscriptionSubscribing());
    // In a real app, paymentToken would be obtained from a payment gateway
    final result = await _subscriptionRepository.subscribeToPlan(
      planId,
      paymentToken,
    );
    result.fold((failure) => emit(SubscriptionFailure(failure.message)), (
      success,
    ) {
      if (success) {
        emit(SubscriptionSuccess(planId));
        // You might want to update user's subscription status in AuthCubit or a UserCubit
      } else {
        // This case should ideally be handled by the Left(Failure(...)) from the repo
        emit(const SubscriptionFailure("Subscription process failed."));
      }
    });
  }
}
