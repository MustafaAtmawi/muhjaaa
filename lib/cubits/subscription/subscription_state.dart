part of 'subscription_cubit.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading
    extends SubscriptionState {} // Used for initial plan loading

class SubscriptionPlansLoaded extends SubscriptionState {
  final List<SubscriptionPlanModel> plans;
  final String? selectedPlanId;
  final bool agreedToTerms;
  final bool
  isSubscribing; // For loading state during actual subscription attempt
  final String? error; // For errors during plan loading or subscription

  const SubscriptionPlansLoaded({
    required this.plans,
    this.selectedPlanId,
    this.agreedToTerms = false,
    this.isSubscribing = false,
    this.error,
  });

  SubscriptionPlansLoaded copyWith({
    List<SubscriptionPlanModel>? plans,
    String? selectedPlanId,
    bool? agreedToTerms,
    bool? isSubscribing,
    String? error,
    bool clearError = false,
  }) {
    return SubscriptionPlansLoaded(
      plans: plans ?? this.plans,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      isSubscribing: isSubscribing ?? this.isSubscribing,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    plans,
    selectedPlanId,
    agreedToTerms,
    isSubscribing,
    error,
  ];
}

// Kept for simplicity if you want separate states, though merging into SubscriptionPlansLoaded can work too.
// class SubscriptionSubscribing extends SubscriptionState {} // Can be merged as bool flag

class SubscriptionSuccess extends SubscriptionState {
  final String planId; // ID of the successfully subscribed plan
  const SubscriptionSuccess(this.planId);
  @override
  List<Object?> get props => [planId];
}

// General failure state, can be used if plans fail to load initially
class SubscriptionFailure extends SubscriptionState {
  final String message;
  const SubscriptionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
