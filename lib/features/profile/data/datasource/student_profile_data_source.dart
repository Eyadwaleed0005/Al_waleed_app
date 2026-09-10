import 'package:al_waleed/features/profile/data/model/profile_model.dart';

abstract class StudentProfileDataSource {
  Future<ProfileModel> getStudentProfile();
}
