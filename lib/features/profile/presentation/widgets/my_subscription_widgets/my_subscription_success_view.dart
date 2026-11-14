import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/constants/const.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:al_waleed/core/widgets/custom_button.dart';
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
  bool _isSupportRequest = false;

  Future<void> _contactTeacher({required bool isSupport}) async {
    if (_isOpeningWhatsApp) return;

    setState(() {
      _isOpeningWhatsApp = true;
      _isSupportRequest = isSupport;
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
          final requestMessage = isSupport
              ? 'السلام عليكم، '
                    'محتاج مساعدة بخصوص حسابي على منصة الوليد.'
              : 'السلام عليكم يا مستر، '
                    'لو سمحت عاوز أفعّل أو أجدّد اشتراكي على منصة الوليد.';

          final message = [
            requestMessage,
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
          _isSupportRequest = false;
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
        verticalSpace(32),
        if (subscription.isActive)
          MySubscriptionDetailsCard(subscription: subscription)
        else
          _buildActivationSection(),
        verticalSpace(28),
        const Divider(height: 1, color: ColorPalette.border),
        verticalSpace(28),
        _buildSupportSection(),
      ],
    );
  }

  Widget _buildActivationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'تفعيل الاشتراك',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: AppTextStyle.font16TextPrimarySemiBoldKufam(),
        ),
        verticalSpace(8),
        Text(
          'تواصل مع المعلّم لمعرفة تفاصيل التفعيل أو التجديد.',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: AppTextStyle.font12TextSecondaryRegularTajawal().copyWith(
            height: 1.6,
          ),
        ),
        verticalSpace(20),
        IgnorePointer(
          ignoring: _isOpeningWhatsApp,
          child: CustomButton(
            text: 'تفعيل أو تجديد الاشتراك',
            isLoading: _isOpeningWhatsApp && !_isSupportRequest,
            onPressed: () {
              _contactTeacher(isSupport: false);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    final isOpeningSupport = _isOpeningWhatsApp && _isSupportRequest;

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
          child: InkWell(
            onTap: _isOpeningWhatsApp
                ? null
                : () {
                    _contactTeacher(isSupport: true);
                  },
            borderRadius: BorderRadius.circular(12.r),
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
                          isOpeningSupport
                              ? 'جارٍ فتح واتساب...'
                              : 'تواصل مع الدعم',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: AppTextStyle.font14TextPrimarySemiBoldKufam(),
                        ),
                        verticalSpace(6),
                        Text(
                          'نساعدك في أي استفسار بخصوص حسابك أو اشتراكك.',
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
