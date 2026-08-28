import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/note_page_card.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/page_progress_card.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/reader_header.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/zoom_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoteReaderScreen extends StatefulWidget {
  const NoteReaderScreen({super.key, required this.note});

  final StudyNoteEntity note;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  static const int _currentPage = 1;
  int _zoomPercent = 100;

  void _zoomOut() {
    setState(() => _zoomPercent = (_zoomPercent - 10).clamp(50, 200));
  }

  void _zoomIn() {
    setState(() => _zoomPercent = (_zoomPercent + 10).clamp(50, 200));
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;

    return Scaffold(
      backgroundColor: ColorPalette.background,
      body: Column(
        children: [
          // ── 1. Top Header Widget ─────────────────────────────────────────
          ReaderHeader(note: note),

          // ── 2. Reading Layout Body ───────────────────────────────────────
          Expanded(
            child: BackgroundStudentLayout(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          // Fixed Progress Card
                          PageProgressCard(
                            currentPage: _currentPage,
                            totalPages: note.pageCount,
                          ),
                          verticalSpace(12),

                          // Isolated Scrollable Note Cards Container
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.64,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorPalette.primarySoftBackground,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: ColorPalette.border,
                                  width: 1.5.w,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24.r),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 80.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      NotePageCard(note: note, pageNumber: 1),
                                      verticalSpace(14),
                                      NotePageCard(
                                        note: note,
                                        pageNumber: 2,
                                        isSecondaryPage: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Floating Zoom Toolbar Widget
                      Positioned(
                        left: 12.w,
                        right: 12.w,
                        bottom: 20.h,
                        child: ZoomToolbar(
                          zoomPercent: _zoomPercent,
                          currentPage: _currentPage,
                          totalPages: note.pageCount,
                          onZoomIn: _zoomIn,
                          onZoomOut: _zoomOut,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
