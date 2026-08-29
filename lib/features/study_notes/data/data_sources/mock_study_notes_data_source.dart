import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/features/study_notes/data/data_sources/study_notes_data_source.dart';
import 'package:al_waleed/features/study_notes/data/models/study_note_model.dart';

/// Provides static mock study notes.
class MockStudyNotesDataSource implements StudyNotesDataSource {
  static const List<StudyNoteModel> _mockNotes = [
    StudyNoteModel(
      id: '1',
      title: 'ملزمة الاتزان الكيميائي',
      subject: 'الاتزان الكيميائي',
      pageCount: 8,
      chapterLabel: 'الفصل الثالث',
      readerHeading: 'الاتزان الكيميائي',
      readerSubheading: 'مراجعة شاملة ومبسطة',
      equationText: 'A + B ⇌ C + D',
      equationTypeLabel: 'اتزان ديناميكي',
      equationDescription: 'التفاعل مستمر في الاتجاهين',
      conceptTitle: 'مفهوم الاتزان الديناميكي:',
      conceptDescription:
          'حالة ديناميكية تتساوى فيها سرعتي التفاعل الطردي والعكسي، مع ثبات '
          'تراكيز المواد المتفاعلة والناتجة.',
      tags: ['Kc', 'السرعة', 'العوامل'],
      accentColor: ColorPalette.highlight,
    ),
    StudyNoteModel(
      id: '2',
      title: 'خرائط الكيمياء العضوية',
      subject: 'المواد العطرية',
      pageCount: 6,
      chapterLabel: 'الفصل الأول',
      readerHeading: 'المواد العطرية',
      readerSubheading: 'خريطة ذهنية مبسطة',
      equationText: 'مركبات عطرية ← C6H6',
      equationTypeLabel: 'حلقة بنزين',
      equationDescription: 'بنية حلقية مستقرة تحتوي على روابط متبادلة',
      conceptTitle: 'مفهوم الاستقرار العطري:',
      conceptDescription:
          'تتميز المركبات العطرية باستقرارها الكيميائي الناتج عن انتشار '
          'الإلكترونات داخل الحلقة.',
      tags: ['الروابط', 'الاستقرار', 'بنزين'],
      accentColor: ColorPalette.accent,
    ),
  ];

  @override
  Future<List<StudyNoteModel>> getStudyNotes() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _mockNotes;
  }
}
