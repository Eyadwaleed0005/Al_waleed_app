import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_info_title.dart';
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomAppCard(
      child: Column(
        children: [
          ProfileInfoTile(
            label: 'البريد الإلكتروني',
            value: 'galal@alwaleed.com',
            icon: Icons.email_outlined,
            isCopyable: true,
          ),
          ProfileInfoTile(
            label: 'الصف الدراسي',
            value: 'الثالث الثانوي',
            icon: Icons.school_outlined,
          ),
          ProfileInfoTile(
            label: 'بداية الاشتراك',
            value: '18 / 07 / 2026',
            icon: Icons.calendar_today_outlined,
          ),
          ProfileInfoTile(
            label: 'نهاية الاشتراك',
            value: '18 / 10 / 2026',
            icon: Icons.calendar_month_outlined,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}