import 'package:al_waleed/core/constants/const.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherSocialLinks extends StatelessWidget {
  const TeacherSocialLinks({super.key});

  Future<void> _openLink(BuildContext context, String url) async {
    try {
      final opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );

      if (!opened && context.mounted) {
        _showError(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showError(context);
      }
    }
  }

  void _showError(BuildContext context) {
    showAppToast(
      context,
      message: 'تعذر فتح الرابط',
      icon: Icons.error_outline_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLink(
              context: context,
              title: 'واتساب',
              icon: Icons.chat_outlined,
              url: Const.teacherWhatsAppUrl,
            ),
            const Divider(color: ColorPalette.divider),
            _buildLink(
              context: context,
              title: 'فيسبوك',
              icon: Icons.facebook,
              url: Const.teacherFacebookUrl,
            ),
            const Divider(color: ColorPalette.divider),
            _buildLink(
              context: context,
              title: 'إنستجرام',
              icon: Icons.camera_alt_outlined,
              url: Const.teacherInstagramUrl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLink({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String url,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: ColorPalette.primary, size: 26.sp),
      title: Text(
        title,
        style: AppTextStyle.font14TextSecondaryRegularTajawal(),
      ),
      trailing: Icon(
        Icons.open_in_new_rounded,
        size: 20.sp,
        color: ColorPalette.primary,
      ),
      onTap: () {
        _openLink(context, url);
      },
    );
  }
}
