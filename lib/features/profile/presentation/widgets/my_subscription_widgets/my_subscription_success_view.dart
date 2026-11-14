import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/constants/const.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:al_waleed/features/profile/domain/entities/my_subscription_entity.dart';
import 'package:al_waleed/features/profile/domain/usecase/get_personal_info_use_case.dart';
import 'package:al_waleed/features/profile/presentation/widgets/my_subscription_widgets/my_subscription_details_card.dart';
import 'package:al_waleed/features/profile/presentation/widgets/my_subscription_widgets/my_subscription_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class MySubscriptionSuccessView extends StatefulWidget {
  const MySubscriptionSuccessView({super.key, required this.subscription});

  final MySubscriptionEntity subscription;

  @override
  State<MySubscriptionSuccessView> createState() {
    return _MySubscriptionSuccessViewState();
  }
}

class _MySubscriptionSuccessViewState extends State<MySubscriptionSuccessView> {
  bool _isOpeningWhatsApp = false;

  Future<void> _contactSupport() async {
    if (_isOpeningWhatsApp) return;

    setState(() {
      _isOpeningWhatsApp = true;
    });

    try {
      final result = await getIt<GetPersonalInfoUseCase>()();

      if (!mounted) return;

      await result.fold<Future<void>>(
        (error) async {
          showAppToast(
            context,
            message: error.message,
            icon: Icons.error_outline_rounded,
          );
        },
        (personalInfo) async {
          final message = [
            'السلام عليكم،',
            'عندي استفسار بخصوص حالة اشتراكي على منصة الوليد.',
            '',
            'بيانات الطالب:',
            'الاسم: ${personalInfo.name.trim()}',
            'رقم الهاتف: ${personalInfo.phoneNumber.trim()}',
            'البريد الإلكتروني: ${personalInfo.email.trim()}',
          ].join('\n');

          final uri = Uri.parse(
            Const.teacherWhatsAppUrl,
          ).replace(queryParameters: {'text': message});

          final opened = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );

          if (!opened && mounted) {
            _showContactError();
          }
        },
      );
    } catch (_) {
      if (mounted) {
        _showContactError();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningWhatsApp = false;
        });
      }
    }
  }

  void _showContactError() {
    showAppToast(
      context,
      message: 'تعذر فتح واتساب. حاول مرة أخرى.',
      icon: Icons.error_outline_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final subscription = widget.subscription;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MySubscriptionStatusCard(isActive: subscription.isActive),
        if (subscription.isActive) ...[
          verticalSpace(32),
          MySubscriptionDetailsCard(subscription: subscription),
        ],
        verticalSpace(28),
        const Divider(height: 1, color: ColorPalette.border),
        verticalSpace(28),
        _buildSupportSection(),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'الدعم والمساعدة',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: AppTextStyle.font16TextPrimarySemiBoldKufam(),
        ),
        verticalSpace(16),
        Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(12.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _isOpeningWhatsApp ? null : _contactSupport,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(
                    Icons.support_agent_rounded,
                    color: ColorPalette.primary,
                    size: 26.sp,
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'تواصل مع الدعم',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: AppTextStyle.font14TextPrimarySemiBoldKufam(),
                        ),
                        verticalSpace(6),
                        Text(
                          'للاستفسار عن حالة اشتراكك أو الإبلاغ عن مشكلة.',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style:
                              AppTextStyle.font12TextSecondaryRegularTajawal()
                                  .copyWith(height: 1.5),
                        ),
                        verticalSpace(4),
                        Text(
                          'ستُضاف بيانات حسابك إلى رسالة واتساب لتراجعها قبل الإرسال.',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style:
                              AppTextStyle.font12TextSecondaryRegularTajawal()
                                  .copyWith(height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  horizontalSpace(8),
                  Icon(
                    Icons.chevron_left_rounded,
                    color: ColorPalette.primary,
                    size: 24.sp,
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
