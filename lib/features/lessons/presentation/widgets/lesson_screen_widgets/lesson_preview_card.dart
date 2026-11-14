import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/helper/youtube_thumbnail_helper.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonPreviewCard extends StatelessWidget {
  const LessonPreviewCard({
    super.key,
    required this.lessonId,
    required this.title,
    required this.subtitle,
    required this.youtubeUrl,
    required this.isFree,
    required this.hasValidSubscription,
    required this.onTap,
  });

  final String lessonId;
  final String title;
  final String subtitle;
  final String youtubeUrl;
  final bool isFree;
  final bool? hasValidSubscription;
  final VoidCallback onTap;

  bool get _isLocked => !isFree && hasValidSubscription == false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(18.r);
    final thumbnailUrl = YoutubeThumbnailHelper.thumbnailUrl(youtubeUrl);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            color: ColorPalette.ligthBlackShadow,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: ColorPalette.primary,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'lesson-thumbnail-$lessonId',
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18.r),
                  ),
                  child: SizedBox(
                    height: 180.h,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (thumbnailUrl != null)
                          Image.network(
                            thumbnailUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }

                              return const ColoredBox(
                                color: ColorPalette.paleSage,
                                child: Center(
                                  child: AppLoadingIndicator(
                                    color: ColorPalette.primary,
                                    size: 30,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholder();
                            },
                          )
                        else
                          _buildPlaceholder(),
                        if (_isLocked)
                          ColoredBox(
                            color: ColorPalette.deepOlive.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        if (thumbnailUrl != null || _isLocked)
                          Center(
                            child: Container(
                              width: 48.w,
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: ColorPalette.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorPalette.paleSage,
                                  width: 1.w,
                                ),
                              ),
                              child: Icon(
                                _isLocked
                                    ? Icons.lock_outline_rounded
                                    : Icons.play_arrow_rounded,
                                size: _isLocked ? 26.sp : 32.sp,
                                color: ColorPalette.textLight,
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.font15TextBlackSemiBoldKufam()
                          .copyWith(color: ColorPalette.textLight),
                    ),
                    if (subtitle.trim().isNotEmpty) ...[
                      verticalSpace(8),
                      Text(
                        subtitle,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.font14TextSecondaryRegularTajawal()
                            .copyWith(color: ColorPalette.softSage),
                      ),
                    ],
                    verticalSpace(16),
                    _buildAccessStatus(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccessStatus() {
    final String label;

    if (isFree) {
      label = 'مجاني';
    } else if (hasValidSubscription == true) {
      label = 'متاح باشتراكك';
    } else if (hasValidSubscription == false) {
      label = 'تفعيل الاشتراك';
    } else {
      label = 'التحقق من الاشتراك عند الفتح';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: _isLocked ? ColorPalette.paleSage : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLocked) ...[
            Icon(
              Icons.lock_outline_rounded,
              size: 18.sp,
              color: ColorPalette.primary,
            ),
            horizontalSpace(8),
          ],
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyle.font14TextSecondaryRegularTajawal().copyWith(
                color: _isLocked ? ColorPalette.primary : ColorPalette.paleSage,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return ColoredBox(
      color: ColorPalette.paleSage,
      child: Center(
        child: Icon(
          Icons.video_library_outlined,
          size: 44.sp,
          color: ColorPalette.primary,
        ),
      ),
    );
  }
}
