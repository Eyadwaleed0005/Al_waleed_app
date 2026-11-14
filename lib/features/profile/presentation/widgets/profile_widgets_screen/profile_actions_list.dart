import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_widgets_screen/profile_action_card.dart';
import 'package:flutter/material.dart';

class ProfileActionsList extends StatelessWidget {
  const ProfileActionsList({
    super.key,
    required this.gradeName,
    required this.onPersonalInfo,
    required this.onSubscription,
    required this.onAboutTeacher,
    required this.onSupport,
    required this.onDeleteAccount,
    required this.onLogout,
  });

  final String gradeName;
  final VoidCallback onPersonalInfo;
  final VoidCallback onSubscription;
  final VoidCallback onAboutTeacher;
  final VoidCallback onSupport;
  final VoidCallback onDeleteAccount;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('حسابي'),
        verticalSpace(12),
        ProfileActionCard(
          icon: Icons.person_outline_rounded,
          title: 'البيانات الشخصية',
          subtitle: 'الاسم ورقم الهاتف والبريد الإلكتروني',
          onTap: onPersonalInfo,
        ),
        verticalSpace(10),
        ProfileActionCard(
          icon: Icons.school_outlined,
          title: 'الصف الدراسي المسجل',
          subtitle: gradeName,
          showArrow: false,
        ),
        verticalSpace(10),
        ProfileActionCard(
          icon: Icons.card_membership_outlined,
          title: 'اشتراكي',
          subtitle: 'تفاصيل اشتراكك في المنصة',
          onTap: onSubscription,
        ),
        verticalSpace(10),
        ProfileActionCard(
          icon: Icons.delete_outline_rounded,
          title: 'حذف الحساب',
          subtitle: 'حذف حسابك وبياناتك نهائيًا',
          onTap: onDeleteAccount,
        ),
        verticalSpace(10),
        ProfileActionCard(
          icon: Icons.logout_outlined,
          title: 'تسجيل الخروج',
          subtitle: 'تبقى بياناتك محفوظة في حسابك',
          onTap: onLogout,
          showArrow: false,
        ),
        verticalSpace(24),
        _buildSectionTitle('الدعم والمعلومات'),
        verticalSpace(12),
        ProfileActionCard(
          icon: Icons.person_pin_outlined,
          title: 'عن المعلّم',
          subtitle: 'تعرّف على معلّمك وطرق التواصل',
          onTap: onAboutTeacher,
        ),
        verticalSpace(10),
        ProfileActionCard(
          icon: Icons.support_agent_rounded,
          title: 'تواصل مع الدعم',
          subtitle: 'مساعدة بخصوص حسابك أو اشتراكك',
          onTap: onSupport,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: AppTextStyle.font16TextPrimarySemiBoldKufam().copyWith(
        color: ColorPalette.primary,
      ),
    );
  }
}
