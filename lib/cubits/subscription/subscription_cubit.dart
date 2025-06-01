import 'package:flutter_bloc/flutter_bloc.dart';
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
    result.fold((failure) => emit(SubscriptionFailure(failure.message)), (
      plans,
    ) {
      String? initialSelectedPlanId;
      if (plans.isNotEmpty) {
        final yearlyPlan = plans.firstWhere(
          (p) => p.isYearly,
          orElse: () => plans.first,
        );
        initialSelectedPlanId = yearlyPlan.id;
      }
      emit(
        SubscriptionPlansLoaded(
          plans: plans,
          selectedPlanId: initialSelectedPlanId,
        ),
      );
    });
  }

  void selectPlan(String planId) {
    if (state is SubscriptionPlansLoaded) {
      final currentState = state as SubscriptionPlansLoaded;
      emit(currentState.copyWith(selectedPlanId: planId, clearError: true));
    }
  }

  void toggleAgreeToTerms(bool? agreed) {
    if (state is SubscriptionPlansLoaded) {
      final currentState = state as SubscriptionPlansLoaded;
      emit(
        currentState.copyWith(agreedToTerms: agreed ?? false, clearError: true),
      );
    }
  }

  Future<void> subscribeToSelectedPlan(String paymentToken) async {
    if (state is SubscriptionPlansLoaded) {
      final currentState = state as SubscriptionPlansLoaded;
      if (currentState.selectedPlanId == null) {
        emit(currentState.copyWith(error: "الرجاء اختيار خطة اشتراك أولاً."));
        return;
      }
      if (!currentState.agreedToTerms) {
        emit(
          currentState.copyWith(error: "الرجاء الموافقة على الشروط والأحكام."),
        );
        return;
      }

      emit(currentState.copyWith(isSubscribing: true, clearError: true));
      final result = await _subscriptionRepository.subscribeToPlan(
        currentState.selectedPlanId!,
        paymentToken, // In a real app, this token would come from a payment provider
      );
      result.fold(
        (failure) => emit(
          currentState.copyWith(isSubscribing: false, error: failure.message),
        ),
        (success) {
          if (success) {
            emit(SubscriptionSuccess(currentState.selectedPlanId!));
          } else {
            emit(
              currentState.copyWith(
                isSubscribing: false,
                error: "Subscription process failed.",
              ),
            );
          }
        },
      );
    }
  }
}
