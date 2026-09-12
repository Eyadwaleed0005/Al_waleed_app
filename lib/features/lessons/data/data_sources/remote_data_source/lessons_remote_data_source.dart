import 'package:al_waleed/features/lessons/data/models/lesson_model.dart';

abstract class LessonsRemoteDataSource {
  Future<LessonModel> getLessonById({
    required String lessonId,
    required String gradeId,
  });

  Stream<List<LessonModel>> streamLessons({required String gradeId});
}