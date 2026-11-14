import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherBiography extends StatelessWidget {
  const TeacherBiography({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'خبرة ٣٠ عامًا في تدريس الكيمياء وتبسيط مفاهيمها، '
          'من بناء الأساسيات وفهم الأفكار إلى التدريب على حل '
          'المسائل والأسئلة، بشرح منظّم وخطوات واضحة.',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
            height: 1.8,
          ),
        ),
        verticalSpace(18),
        _buildPoint(
          icon: Icons.lightbulb_outline_rounded,
          text: 'تأسيس المفاهيم وفهم الأساسيات',
        ),
        verticalSpace(12),
        _buildPoint(
          icon: Icons.science_outlined,
          text: 'تبسيط الأفكار وربطها بالأمثلة',
        ),
        verticalSpace(12),
        _buildPoint(
          icon: Icons.edit_note_rounded,
          text: 'التدريب على الأسئلة وخطوات الحل',
        ),
      ],
    );
  }

  Widget _buildPoint({required IconData icon, required String text}) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Icon(icon, size: 22.sp, color: ColorPalette.primary),
        horizontalSpace(10),
        Expanded(
          child: Text(
            text,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyle.font14TextSecondaryRegularTajawal(),
          ),
        ),
      ],
    );
  }
}
