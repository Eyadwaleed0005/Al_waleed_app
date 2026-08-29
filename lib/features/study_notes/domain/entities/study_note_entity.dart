import 'package:flutter/material.dart';

class StudyNoteEntity {
  const StudyNoteEntity({
    required this.id,
    required this.title,
    required this.subject,
    required this.pageCount,
    required this.chapterLabel,
    required this.readerHeading,
    required this.readerSubheading,
    required this.equationText,
    required this.equationTypeLabel,
    required this.equationDescription,
    required this.conceptTitle,
    required this.conceptDescription,
    required this.tags,
    this.accentColor,
  });

  final String id;
  final String title;
  final String subject;
  final int pageCount;
  final String chapterLabel;
  final String readerHeading;
  final String readerSubheading;
  final String equationText;
  final String equationTypeLabel;
  final String equationDescription;
  final String conceptTitle;
  final String conceptDescription;
  final List<String> tags;
  final Color? accentColor;
}
