import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:flutter/material.dart';

class StudyNoteModel extends StudyNoteEntity {
  const StudyNoteModel({
    required super.id,
    required super.title,
    required super.subject,
    required super.pageCount,
    required super.chapterLabel,
    required super.readerHeading,
    required super.readerSubheading,
    required super.equationText,
    required super.equationTypeLabel,
    required super.equationDescription,
    required super.conceptTitle,
    required super.conceptDescription,
    required super.tags,
    super.accentColor,
  });

  factory StudyNoteModel.fromJson(Map<String, dynamic> json) {
    return StudyNoteModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      pageCount: json['pageCount'] as int? ?? 0,
      chapterLabel: json['chapterLabel'] as String? ?? '',
      readerHeading: json['readerHeading'] as String? ?? '',
      readerSubheading: json['readerSubheading'] as String? ?? '',
      equationText: json['equationText'] as String? ?? '',
      equationTypeLabel: json['equationTypeLabel'] as String? ?? '',
      equationDescription: json['equationDescription'] as String? ?? '',
      conceptTitle: json['conceptTitle'] as String? ?? '',
      conceptDescription: json['conceptDescription'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      accentColor: json['accentColor'] != null
          ? Color(json['accentColor'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'pageCount': pageCount,
      'chapterLabel': chapterLabel,
      'readerHeading': readerHeading,
      'readerSubheading': readerSubheading,
      'equationText': equationText,
      'equationTypeLabel': equationTypeLabel,
      'equationDescription': equationDescription,
      'conceptTitle': conceptTitle,
      'conceptDescription': conceptDescription,
      'tags': tags,
      'accentColor': accentColor?.toARGB32(),
    };
  }
}
