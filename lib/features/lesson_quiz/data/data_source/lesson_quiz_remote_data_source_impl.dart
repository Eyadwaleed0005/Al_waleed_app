import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_fields.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/lesson_quiz/data/data_source/lesson_quiz_remote_data_source.dart';
import 'package:al_waleed/features/lesson_quiz/data/models/lesson_quiz_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class LessonQuizRemoteDataSourceImpl implements LessonQuizRemoteDataSource {
  final FirestoreService firestoreService;

  LessonQuizRemoteDataSourceImpl({ required this.firestoreService});

  @override
  Future<List<LessonQuizModel>> getQuizQuestions({required String lessonId}) async {
    final querySnapshot = await firestoreService.getCollection(
      collectionPath: FirestoreCollections.lessonQuestions,
      queryBuilder: (collection) => collection.where(FirestoreFields.lessonId, isEqualTo: lessonId),
    );
    
     
    

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return LessonQuizModel.fromMap(data);
    }).toList();
  }
}
