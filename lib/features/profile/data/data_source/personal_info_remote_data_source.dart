import 'package:al_waleed/features/profile/data/model/personal_info_model.dart';

abstract interface class PersonalInfoRemoteDataSource {
  Future<PersonalInfoModel> getPersonalInfo();

  Future<void> updatePersonalInfo({
    required String name,
    required String phoneNumber,
    required String email,
    String? currentPassword,
  });
}
