import 'package:al_waleed/features/profile/data/model/profile_model.dart';

abstract interface class StudentProfileDataSource {
  Stream<ProfileModel> streamStudentProfile();
}