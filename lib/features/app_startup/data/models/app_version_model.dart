import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/features/app_startup/domain/entities/app_version_entity.dart';

class AppVersionModel extends AppVersionEntity {
  const AppVersionModel({
    required super.latestVersion,
    required super.latestBuildNumber,
    required super.storeUrl,
    required super.forceUpdate,
  });

  factory AppVersionModel.fromAndroid(Map<String, dynamic> data) {
    return AppVersionModel(
      latestVersion: _readRequiredString(
        data: data,
        field: FirestoreFields.androidLatestVersion,
      ),
      latestBuildNumber: _readRequiredInt(
        data: data,
        field: FirestoreFields.androidLatestBuildNumber,
      ),
      storeUrl: _readString(data: data, field: FirestoreFields.androidStoreUrl),
      forceUpdate: _readRequiredBool(
        data: data,
        field: FirestoreFields.androidForceUpdate,
      ),
    );
  }

  factory AppVersionModel.fromIos(Map<String, dynamic> data) {
    return AppVersionModel(
      latestVersion: _readRequiredString(
        data: data,
        field: FirestoreFields.iosLatestVersion,
      ),
      latestBuildNumber: _readRequiredInt(
        data: data,
        field: FirestoreFields.iosLatestBuildNumber,
      ),
      storeUrl: _readString(data: data, field: FirestoreFields.iosStoreUrl),
      forceUpdate: _readRequiredBool(
        data: data,
        field: FirestoreFields.iosForceUpdate,
      ),
    );
  }

  AppVersionEntity toEntity() {
    return AppVersionEntity(
      latestVersion: latestVersion,
      latestBuildNumber: latestBuildNumber,
      storeUrl: storeUrl,
      forceUpdate: forceUpdate,
    );
  }

  static String _readRequiredString({
    required Map<String, dynamic> data,
    required String field,
  }) {
    final value = data[field];

    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Missing or invalid field: $field');
    }

    return value.trim();
  }

  static String _readString({
    required Map<String, dynamic> data,
    required String field,
  }) {
    final value = data[field];

    if (value is! String) {
      return '';
    }

    return value.trim();
  }

  static int _readRequiredInt({
    required Map<String, dynamic> data,
    required String field,
  }) {
    final value = data[field];

    if (value is num) {
      return value.toInt();
    }
    throw FormatException('Missing or invalid field: $field');
  }

  static bool _readRequiredBool({
    required Map<String, dynamic> data,
    required String field,
  }) {
    final value = data[field];

    if (value is! bool) {
      throw FormatException('Missing or invalid field: $field');
    }

    return value;
  }
}
