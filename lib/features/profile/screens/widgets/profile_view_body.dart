import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
import 'package:al_waleed/core/widgets/custom_dialog.dart';
import 'package:al_waleed/features/profile/screens/widgets/profile_background.dart';
import 'package:al_waleed/features/profile/screens/widgets/profile_info_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_waleed/core/style/textstyles.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60.h),
            Text(
              'محمد جلال عبد الفتاح',
              style: AppTextStyle.font20TextBlackSemiBoldKufam(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Text(
              'طالب الصف الثالث الثانوي',
              style: AppTextStyle.font12TextSecondaryRegularTajawal(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),

            CustomAppCard(
              child: Column(
                children: [
                  const ProfileInfoTile(
                    label: 'البريد الإلكتروني',
                    value: 'galal@alwaleed.com',
                    icon: Icons.email_outlined,
                  ),
                  const ProfileInfoTile(
                    label: 'الصف الدراسي',
                    value: 'الثالث الثانوي',
                    icon: Icons.school_outlined,
                  ),
                  const ProfileInfoTile(
                    label: 'بداية الاشتراك',
                    value: '18 / 07 / 2026',
                    icon: Icons.calendar_today_outlined,
                  ),
                  const ProfileInfoTile(
                    label: 'نهاية الاشتراك',
                    value: '18 / 10 / 2026',
                    icon: Icons.calendar_month_outlined,
                    showDivider: false,
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            CustomButton(
              text: 'تسجيل الخروج',
              foreground: ColorPalette.error,
              borderColor: ColorPalette.error.withValues(alpha: .3),
              background: ColorPalette.cardBackground,

              onPressed: () {
                CustomDialog.showDelete(
                  icon: Icons.logout_outlined,
                  iconBorderRadius: BorderRadius.circular(16.r),
                  context,
                  title: 'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
                  message: 'ستحتاج إلى تسجيل الدخول مرة أخرى للوصول إلى حسابك.',
                  primaryText: 'تسجيل الخروج',
                  secondaryText: 'إلغاء',
                  onDelete: () => Navigator.pop(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
