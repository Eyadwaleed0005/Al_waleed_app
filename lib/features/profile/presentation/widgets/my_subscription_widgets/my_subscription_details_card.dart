import 'dart:async';

import 'package:al_waleed/core/helper/app_date_time_formatter.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/features/profile/domain/entities/my_subscription_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySubscriptionDetailsCard extends StatefulWidget {
  const MySubscriptionDetailsCard({super.key, required this.subscription});

  final MySubscriptionEntity subscription;

  @override
  State<MySubscriptionDetailsCard> createState() {
    return _MySubscriptionDetailsCardState();
  }
}

class _MySubscriptionDetailsCardState extends State<MySubscriptionDetailsCard>
    with WidgetsBindingObserver {
  Timer? _timer;
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _refreshCurrentDate(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshCurrentDate();
    }
  }

  void _refreshCurrentDate() {
    if (!mounted) return;

    setState(() {
      _currentDate = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subscription = widget.subscription;

    final hasInvalidPeriod =
        subscription.subscriptionStartAt != null &&
        subscription.subscriptionEndAt != null &&
        !subscription.hasSubscriptionPeriod;

    final remainingDays = hasInvalidPeriod
        ? null
        : subscription.remainingDays(currentDate: _currentDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'تفاصيل الاشتراك',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: AppTextStyle.font16TextPrimarySemiBoldKufam(),
        ),
        verticalSpace(8),
        Text(
          'تابع مدة اشتراكك وموعد التجديد.',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: AppTextStyle.font12TextSecondaryRegularTajawal(),
        ),
        verticalSpace(24),
        _buildInfoRow(
          title: 'بداية الاشتراك',
          value: _formatDate(subscription.subscriptionStartAt),
          icon: Icons.calendar_today_outlined,
          isDate: subscription.subscriptionStartAt != null,
        ),
        _buildDivider(),
        _buildInfoRow(
          title: 'نهاية الاشتراك',
          value: _formatDate(subscription.subscriptionEndAt),
          icon: Icons.event_available_outlined,
          isDate: subscription.subscriptionEndAt != null,
        ),
        _buildDivider(),
        _buildInfoRow(
          title: 'المدة المتبقية',
          value: _formatRemainingDays(remainingDays),
          icon: Icons.hourglass_bottom_rounded,
        ),
        if (hasInvalidPeriod) ...[
          verticalSpace(16),
          Text(
            'تواصل مع المعلّم لمراجعة تواريخ الاشتراك.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyle.font12TextSecondaryRegularTajawal(),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'غير محدد';

    return AppDateTimeFormatter.formatDateWithSlash(
      date.toLocal(),
      useArabicDigits: false,
    );
  }

  String _formatRemainingDays(int? days) {
    if (days == null) return 'غير محددة';
    if (days == 0) return 'انتهت المدة المسجّلة';
    if (days == 1) return 'يوم واحد';
    if (days == 2) return 'يومان';
    if (days <= 10) return '$days أيام';

    return '$days يومًا';
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: const Divider(height: 1, color: ColorPalette.border),
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String value,
    required IconData icon,
    bool isDate = false,
  }) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Icon(icon, color: ColorPalette.primary, size: 24.sp),
        horizontalSpace(12),
        Expanded(
          child: Text(
            title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTextStyle.font14TextSecondaryRegularTajawal(),
          ),
        ),
        horizontalSpace(12),
        Flexible(
          child: Text(
            value,
            textDirection: isDate ? TextDirection.ltr : TextDirection.rtl,
            textAlign: TextAlign.left,
            style: AppTextStyle.font14TextPrimarySemiBoldKufam(),
          ),
        ),
      ],
    );
  }
}
