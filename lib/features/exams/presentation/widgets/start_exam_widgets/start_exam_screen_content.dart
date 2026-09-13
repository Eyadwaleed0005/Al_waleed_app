import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/exams/domain/entities/exam_question_entity.dart';
import 'package:al_waleed/features/exams/presentation/widgets/finish_exam_dialog/finish_exam_confirmation_dialog.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/exam_navigation_actions.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/exam_question_card.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/start_exam_progress_header.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/start_exam_timer.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartExamScreenContent extends StatefulWidget {
  final List<ExamQuestionEntity>? questions;
  final String examTitle;
  final String initialRemainingTime;

  const StartExamScreenContent({
    super.key,
    this.questions,
    this.examTitle = 'اختبار الكيمياء العضوية',
    this.initialRemainingTime = '25:13',
  });
  @override
  State<StartExamScreenContent> createState() => _StartExamScreenContentState();
}

class _StartExamScreenContentState extends State<StartExamScreenContent> {
  static const List<ExamQuestionEntity> _defaultQuestions = [
    ExamQuestionEntity(
      id: '1',
      questionText:
          'أي المركبات التالية يُظهر ظاهرة التشاكل الهندسي (سيس - ترانس)؟',
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1681426678542-613c306013e1?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      options: ['2-بيوتين', '1-بيوتين', '2-ميثيل بروبين', 'الإيثين'],
      correctAnswerIndex: 0,
    ),
    ExamQuestionEntity(
      id: '2',
      questionText: 'ما هي المجموعة الوظيفية المميزة للكحولات؟',
      options: [
        'مجموعة الهيدروكسيل (-OH)',
        'مجموعة الكاربونيل (C=O)',
        'مجموعة الكربوكسيل (-COOH)',
        'مجموعة الأمين (-NH2)',
      ],
      correctAnswerIndex: 0,
    ),
    ExamQuestionEntity(
      id: '3',
      questionText: 'ما هو الناتج الرئيسي عند أكسدة الكحول الأولي أكسدة تامة؟',
      options: ['حمض كربوكسيلي', 'كيتون', 'ألدهيد فقط', 'إيثر'],
      correctAnswerIndex: 0,
    ),
    ExamQuestionEntity(
      id: '4',
      questionText: 'أي من المركبات الآتية يعتبر من الهيدروكربونات الأروماتية؟',
      options: ['البنزين العطري', 'الهكسان الحلقي', 'البروباين', 'البيوتان'],
      correctAnswerIndex: 0,
    ),
    ExamQuestionEntity(
      id: '5',
      questionText: 'ما الصيغة الجزيئية العامة للألكانات غير الحلقية؟',
      options: ['CnH2n+2', 'CnH2n', 'CnH2n-2', 'CnH2n-6'],
      correctAnswerIndex: 0,
    ),
  ];

  late final PageController _pageController;

  late final List<ExamQuestionEntity> _questions;

  final Map<int, int> _selectedAnswers = {};

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _questions = widget.questions ?? _defaultQuestions;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentIndex < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleSubmitExam();
    }
  }

  void _onPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleSubmitExam() {
    FinishExamConfirmationDialog.show(
      context,
      answeredCount: _selectedAnswers.length,
      totalQuestions: _questions.length,
      onConfirmFinish: () {
        Navigator.of(context).pushReplacementNamed(RouteNames.resultExamScreen);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestionNumber = _currentIndex + 1;
    final totalQuestionsCount = _questions.length;
    final completionPercentage = totalQuestionsCount > 0
        ? ((currentQuestionNumber / totalQuestionsCount) * 100).round()
        : 0;

    return ProfileBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Column(
            children: [
              CustomAppBar(
                backgroundColor: Colors.transparent,
                showBackButton: false,
                titleWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StartExamTimer(remainingTime: widget.initialRemainingTime),
                    Expanded(
                      child: Text(
                        widget.examTitle,
                        textAlign: TextAlign.end,
                        style: AppTextStyle.font18TextPrimarySemiBoldKufam(),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(10),
              StartExamProgressHeader(
                currentQuestion: currentQuestionNumber,
                totalQuestions: totalQuestionsCount,
                completionPercentage: completionPercentage,
              ),
              verticalSpace(14),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ExamQuestionCard(
                        questionText: question.questionText,
                        imageQuestion: question.imageUrl,
                        options: question.options,
                        selectedIndex: _selectedAnswers[index] ?? -1,
                        onOptionSelected: (selectedOption) {
                          setState(() {
                            _selectedAnswers[index] = selectedOption;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              verticalSpace(12),
              ExamNavigationActions(
                onPreviousPressed: _currentIndex > 0 ? _onPrevious : null,
                onNextPressed: _onNext,
                onSubmitPressed: _handleSubmitExam,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
