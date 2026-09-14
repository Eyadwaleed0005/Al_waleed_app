import 'package:al_waleed/core/errors/handlers/firebase_error_handler.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/lesson_quiz/data/data_source/lesson_quiz_remote_data_source.dart';
import 'package:al_waleed/features/lesson_quiz/data/models/lesson_quiz_question_model.dart';

class FirebaseLessonQuizRemoteDataSource implements LessonQuizRemoteDataSource {
  const FirebaseLessonQuizRemoteDataSource({
    required FirestoreService firestoreService,
  }) : _firestoreService = firestoreService;

  final FirestoreService _firestoreService;

  @override
  Future<List<LessonQuizQuestionModel>> getQuizQuestions({
    required String lessonId,
  }) {
    return FirebaseErrorHandler.execute(() async {
      final querySnapshot = await _firestoreService.getCollection(
        collectionPath: FirestoreCollections.lessonQuestions,
        queryBuilder: (collection) {
          return collection.where(
            FirestoreFields.lessonId,
            isEqualTo: lessonId,
          );
        },
      );

      final documents = querySnapshot.docs.toList();

      documents.sort((first, second) {
        final firstOrder =
            (first.data()[FirestoreFields.questionOrder] as num?)?.toInt() ?? 0;

        final secondOrder =
            (second.data()[FirestoreFields.questionOrder] as num?)?.toInt() ??
            0;

        return firstOrder.compareTo(secondOrder);
      });

      return documents
          .map((document) {
            return LessonQuizQuestionModel.fromMap({
              ...document.data(),
              FirestoreFields.questionId: document.id,
            });
          })
          .toList(growable: false);
    });
  }
}
