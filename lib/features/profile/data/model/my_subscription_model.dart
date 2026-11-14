import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/profile/domain/entities/my_subscription_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MySubscriptionModel extends MySubscriptionEntity {
  const MySubscriptionModel({
    required super.isActive,
    super.subscriptionStartAt,
    super.subscriptionEndAt,
  });

  factory MySubscriptionModel.fromFirestore(Map<String, dynamic> data) {
    return MySubscriptionModel(
      isActive: _readIsActive(data[FirestoreFields.isActive]),
      subscriptionStartAt: _readDateTime(
        data[FirestoreFields.subscriptionStartAt],
      ),
      subscriptionEndAt: _readDateTime(data[FirestoreFields.subscriptionEndAt]),
    );
  }

  MySubscriptionEntity toEntity() {
    return MySubscriptionEntity(
      isActive: isActive,
      subscriptionStartAt: subscriptionStartAt,
      subscriptionEndAt: subscriptionEndAt,
    );
  }

  static bool _readIsActive(Object? value) {
    if (value == null) return false;

    if (value is bool) return value;

    throw const FormatException('Invalid subscription status.');
  }

  static DateTime? _readDateTime(Object? value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate().toUtc();
    }

    if (value is DateTime) {
      return value.toUtc();
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    }

    if (value is String) {
      final date = DateTime.tryParse(value);

      if (date != null) return date.toUtc();
    }

    throw const FormatException('Invalid subscription date.');
  }
}
