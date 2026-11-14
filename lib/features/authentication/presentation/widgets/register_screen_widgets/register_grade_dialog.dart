import 'package:al_waleed/core/errors/error_model/app_error_model.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/features/grades/domain/entities/grade_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterGradeDialog extends StatelessWidget {
  const RegisterGradeDialog({
    super.key,
    required this.gradesStream,
    this.selectedGradeId,
  });

  final Stream<Either<AppErrorModel, List<GradeEntity>>> gradesStream;
  final String? selectedGradeId;

  Future<void> _confirmGrade(BuildContext context, GradeEntity grade) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.failure,
          failureIcon: Icons.warning_amber_rounded,
          title: 'تأكيد الصف الدراسي',
          message:
              'لقد اخترت "${grade.name}".\n'
              'بعد إنشاء الحساب، لا يمكنك تغيير الصف الدراسي بنفسك؛ '
              'تعديل الصف يتم عن طريق المعلّم فقط.\n'
              'هل تريد تأكيد اختيارك؟',
          actionText: 'تأكيد الاختيار',
          secondaryActionText: 'رجوع',
          onActionPressed: () {
            Navigator.of(dialogContext).pop(true);
          },
          onSecondaryActionPressed: () {
            Navigator.of(dialogContext).pop(false);
          },
        );
      },
    );

    if (!context.mounted || confirmed != true) return;

    Navigator.of(context).pop<GradeEntity>(grade);
  }

  @override
  Widget build(BuildContext context) {
    return CustomOperationResultDialog(
      type: CustomOperationResultType.success,
      successIcon: Icons.school_outlined,
      title: 'اختر الصف الدراسي',
      message: 'اختر الصف الدراسي الخاص بك.',
      actionText: 'إغلاق',
      content: SizedBox(
        height: 260.h,
        child: StreamBuilder<Either<AppErrorModel, List<GradeEntity>>>(
          stream: gradesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _buildMessage(
                'تعذر تحميل الصفوف الدراسية. حاول مرة أخرى.',
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Center(
                child: AppLoadingIndicator(
                  color: ColorPalette.primary,
                  size: 36,
                ),
              );
            }

            final result = snapshot.data;

            if (result == null) {
              return _buildMessage('لا توجد صفوف دراسية متاحة حاليًا.');
            }

            return result.fold((error) => _buildMessage(error.message), (
              grades,
            ) {
              if (grades.isEmpty) {
                return _buildMessage('لا توجد صفوف دراسية متاحة حاليًا.');
              }

              return Directionality(
                textDirection: TextDirection.rtl,
                child: Material(
                  type: MaterialType.transparency,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      final grade = grades[index];
                      final isSelected = grade.gradeId == selectedGradeId;

                      return ListTile(
                        selected: isSelected,
                        selectedColor: ColorPalette.primary,
                        selectedTileColor: ColorPalette.primarySoftBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        title: Text(
                          grade.name,
                          style:
                              AppTextStyle.font14TextSecondaryRegularTajawal()
                                  .copyWith(
                                    color: isSelected
                                        ? ColorPalette.primary
                                        : ColorPalette.textSecondary,
                                  ),
                        ),
                        trailing: Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? ColorPalette.primary
                              : ColorPalette.textMuted,
                        ),
                        onTap: () {
                          _confirmGrade(context, grade);
                        },
                      );
                    },
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: AppTextStyle.font14TextSecondaryRegularTajawal(),
      ),
    );
  }
}
