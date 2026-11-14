part of 'my_subscription_cubit.dart';

sealed class MySubscriptionState extends Equatable {
  const MySubscriptionState();

  @override
  List<Object?> get props => [];
}

final class MySubscriptionInitial extends MySubscriptionState {
  const MySubscriptionInitial();
}

final class MySubscriptionLoading extends MySubscriptionState {
  const MySubscriptionLoading();
}

final class MySubscriptionSuccess extends MySubscriptionState {
  const MySubscriptionSuccess({required this.subscription});

  final MySubscriptionEntity subscription;

  @override
  List<Object?> get props => [
    subscription.isActive,
    subscription.subscriptionStartAt,
    subscription.subscriptionEndAt,
  ];
}

final class MySubscriptionFailure extends MySubscriptionState {
  const MySubscriptionFailure({required this.error});

  final AppErrorModel error;

  @override
  List<Object?> get props => [error];
}
