import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/home/presentation/widgets/category_navigation_card.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/bottom_navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeQuickLinksSection extends StatelessWidget {
  const HomeQuickLinksSection({super.key});

  void _changeNavigationIndex(BuildContext context, int index) {
    context.read<BottomNavigationCubit>().changeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'روابط سريعة',
          style: AppTextStyle.font20TextPrimarySemiBoldKufam(),
        ),
        verticalSpace(10),
        Row(
          children: [
            CategoryNavigationCard(
              label: 'الامتحانات',
              image: AppImage().exam,
              onTap: () {
                _changeNavigationIndex(context, 3);
              },
            ),
            horizontalSpace(10),
            CategoryNavigationCard(
              label: 'المذاكرات',
              image: AppImage().studyNotes,
              onTap: () {
                _changeNavigationIndex(context, 2);
              },
            ),
            horizontalSpace(10),
            CategoryNavigationCard(
              label: 'الدروس',
              image: AppImage().bookOpen,
              onTap: () {
                _changeNavigationIndex(context, 1);
              },
            ),
          ],
        ),
      ],
    );
  }
}
