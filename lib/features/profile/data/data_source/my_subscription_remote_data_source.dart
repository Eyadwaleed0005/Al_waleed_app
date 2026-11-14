import 'package:al_waleed/features/profile/data/model/my_subscription_model.dart';

abstract interface class MySubscriptionRemoteDataSource {
  Stream<MySubscriptionModel> streamMySubscription();
}
