import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/features/profile/data/data_source/my_subscription_remote_data_source.dart';
import 'package:al_waleed/features/profile/domain/entities/my_subscription_entity.dart';
import 'package:al_waleed/features/profile/domain/repositories/my_subscription_repository.dart';
import 'package:dartz/dartz.dart';

class MySubscriptionRepositoryImpl implements MySubscriptionRepository {
  const MySubscriptionRepositoryImpl({required this._remoteDataSource});

  final MySubscriptionRemoteDataSource _remoteDataSource;

  @override
  Stream<Either<AppErrorModel, MySubscriptionEntity>>
  streamMySubscription() async* {
    try {
      await for (final model in _remoteDataSource.streamMySubscription()) {
        yield Right<AppErrorModel, MySubscriptionEntity>(model.toEntity());
      }
    } catch (error) {
      yield Left<AppErrorModel, MySubscriptionEntity>(
        FirebaseErrorHandler.handle(error),
      );
    }
  }
}
