import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_action_card.dart';
import 'package:flutter/material.dart';

class ProfileActionsList extends StatelessWidget {
  const ProfileActionsList({
    super.key,
    required this.gradeName,
    required this.onPersonalInfo,
    required this.onSubscription,
    required this.onAboutTeacher,
    required this.onLogout,
  });

  final String gradeName;
  final VoidCallback onPersonalInfo;
  final VoidCallback onSubscription;
  final VoidCallback onAboutTeacher;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileActionCard(
          icon: Icons.person_outline_rounded,
          title: 'البيانات الشخصية',
          subtitle: 'الاسم والبريد الإلكتروني',
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
          icon: Icons.person_pin_outlined,
          title: 'عن المعلّم',
          subtitle: 'تعرّف على معلّمك',
          onTap: onAboutTeacher,
        ),
        verticalSpace(10),
        ProfileActionCard(
          icon: Icons.logout_outlined,
          title: 'تسجيل الخروج',
          subtitle: 'تبقى بياناتك محفوظة في حسابك',
          onTap: onLogout,
          showArrow: false,
        ),
      ],
    );
  }
}
