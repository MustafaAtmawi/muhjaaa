part of 'subscription_cubit.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionPlansLoaded extends SubscriptionState {
  final List<SubscriptionPlanModel> plans;

  const SubscriptionPlansLoaded(this.plans);

  @override
  List<Object> get props => [plans];
}

class SubscriptionSubscribing extends SubscriptionState {}

class SubscriptionSuccess extends SubscriptionState {
  final String planId;
  const SubscriptionSuccess(this.planId);
  @override
  List<Object> get props => [planId];
}

class SubscriptionFailure extends SubscriptionState {
  final String message;

  const SubscriptionFailure(this.message);

  @override
  List<Object> get props => [message];
}
