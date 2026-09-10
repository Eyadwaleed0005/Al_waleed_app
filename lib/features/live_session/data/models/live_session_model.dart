
import 'package:al_waleed/features/live_session/domain/entity/live_session_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveSessionModel extends LiveSessionEntity {
  const LiveSessionModel({
    required super.gradeId,
    required super.platformType,
    required super.meetingUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LiveSessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return LiveSessionModel(
      gradeId: doc.id,
      platformType: data['platformType'] as String? ?? '',
      meetingUrl: data['meetingUrl'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'platformType': platformType,
      'meetingUrl': meetingUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
 
}