import 'package:al_waleed/core/style/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonVideoCard extends StatelessWidget {
  final String videoUrl;

  const LessonVideoCard({super.key, required this.videoUrl});

  /// Extracts YouTube video ID from any URL format or returns as-is
  String _extractVideoId(String url) {
    // Already a raw ID (11 chars, no slashes)
    if (!url.contains('/') && !url.contains('=')) return url;

    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    // youtu.be/VIDEO_ID
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : url;
    }

    // youtube.com/watch?v=VIDEO_ID
    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'] ?? url;
    }

    // youtube.com/embed/VIDEO_ID
    if (uri.pathSegments.contains('embed') &&
        uri.pathSegments.length > uri.pathSegments.indexOf('embed') + 1) {
      return uri.pathSegments[uri.pathSegments.indexOf('embed') + 1];
    }

    return url;
  }

  String _thumbnailUrl(String videoId) =>
      'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

  @override
  Widget build(BuildContext context) {
    final videoId = _extractVideoId(videoUrl);

    return AspectRatio(
      aspectRatio: 350 / 170,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: _thumbnailUrl(videoId),
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(color: ColorPalette.info),
              ),
            ),

            Center(
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: ColorPalette.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorPalette.textSoftSaga,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 40.sp,
                  color: ColorPalette.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
