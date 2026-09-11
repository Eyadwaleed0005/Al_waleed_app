import 'package:al_waleed/core/firebase/firestore/firestore_collections.dart';
import 'package:al_waleed/core/firebase/firestore/firestore_service.dart';
import 'package:al_waleed/features/live_session/data/data_source/live_session_remote_data_source.dart';
import 'package:al_waleed/features/live_session/data/models/live_session_model.dart';

class FirebaseLiveSessionRemoteDataSource
    implements LiveSessionRemoteDataSource {
  final FirestoreService firestoreService;

  FirebaseLiveSessionRemoteDataSource({required this.firestoreService});

  @override
  Future<LiveSessionModel> getLiveSession({required String gradeId}) async {
    final docSnapshot = await firestoreService.getDocument(
      collectionPath: FirestoreCollections.liveSessions,
      documentId: gradeId,
    );

    return LiveSessionModel.fromFirestore(docSnapshot);
  }
}
