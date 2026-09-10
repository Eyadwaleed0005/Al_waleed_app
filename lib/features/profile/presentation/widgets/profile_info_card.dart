import 'package:al_waleed/core/helper/app_date_time_formatter.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_info_title.dart';
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final ProfileEntity profile;
  const ProfileInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return CustomAppCard(
      child: Column(
        children: [
          ProfileInfoTile(
            label: 'البريد الإلكتروني',
            value: profile.studentProfile.email,
            icon: Icons.email_outlined,
            isCopyable: true,
          ),
          ProfileInfoTile(
            label: 'الصف الدراسي',
            value: profile.grade.name,
            icon: Icons.school_outlined,
          ),
          ProfileInfoTile(
            label: 'بداية الاشتراك',
            value: AppDateTimeFormatter.formatDateWithSlash(
              DateTime.parse(profile.studentProfile.subscriptionStartAt),
              useArabicDigits: false,
            ),
            icon: Icons.calendar_today_outlined,
          ),
          ProfileInfoTile(
            label: 'نهاية الاشتراك',
            value: AppDateTimeFormatter.formatDateWithSlash(
              DateTime.parse(profile.studentProfile.subscriptionEndAt),
              useArabicDigits: false,
            ),
            icon: Icons.calendar_month_outlined,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
