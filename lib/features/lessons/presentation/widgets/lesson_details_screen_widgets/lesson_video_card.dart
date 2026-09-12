import 'dart:async';

import 'package:al_waleed/core/style/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonVideoCard extends StatefulWidget {
  const LessonVideoCard({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<LessonVideoCard> createState() => _LessonVideoCardState();
}

class _LessonVideoCardState extends State<LessonVideoCard> {
  static const double _cardAspectRatio = 350 / 170;

  YoutubePlayerController? _playerController;

  bool _isPlayerActive = false;

  @override
  void didUpdateWidget(LessonVideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl && _isPlayerActive) {
      _playerController?.close();
      _playerController = null;
      _isPlayerActive = false;
      _restorePortraitLock();
    }
  }

  @override
  void dispose() {
    _playerController?.close();
    if (_isPlayerActive) {
      _restorePortraitLock();
    }
    super.dispose();
  }

  void _allowLandscape() {
    unawaited(
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]),
    );
  }

  void _restorePortraitLock() {
    unawaited(
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
      ]),
    );
  }

  void _activatePlayer() {
    final videoId = _extractVideoId(widget.videoUrl);
    if (videoId.isEmpty || _isPlayerActive) return;

    setState(() {
      _isPlayerActive = true;
      _playerController = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          interfaceLanguage: 'ar',
          captionLanguage: 'ar',
          playsInline: true,
          enableCaption: false,
          strictRelatedVideos: true,
        ),
      );
    });

    _allowLandscape();
  }

  /// Extracts the YouTube video id from any common YouTube link format.
  static String _extractVideoId(String videoUrl) {
    final normalizedUrl = videoUrl.trim();

    if (normalizedUrl.isEmpty) return '';

    final uri = Uri.tryParse(normalizedUrl);
    if (uri == null) return '';

    // youtu.be/VIDEO_ID
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
    }

    // youtube.com/watch?v=VIDEO_ID
    final queryVideoId = uri.queryParameters['v'];
    if (queryVideoId != null && queryVideoId.trim().isNotEmpty) {
      return queryVideoId.trim();
    }

    // youtube.com/embed|shorts|live|v/VIDEO_ID
    for (final segment in const ['embed', 'shorts', 'live', 'v']) {
      final segmentIndex = uri.pathSegments.indexOf(segment);

      if (segmentIndex != -1 && uri.pathSegments.length > segmentIndex + 1) {
        return uri.pathSegments[segmentIndex + 1];
      }
    }

    // A raw video id was passed directly (no path segments or queries).
    if (!normalizedUrl.contains('/') && !normalizedUrl.contains('?')) {
      return normalizedUrl;
    }

    return '';
  }

  static String _thumbnailUrl(String videoId) =>
      'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _cardAspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: _isPlayerActive ? _buildPlayer() : _buildThumbnailPreview(),
      ),
    );
  }

  Widget _buildThumbnailPreview() {
    final videoId = _extractVideoId(widget.videoUrl);

    return GestureDetector(
      onTap: _activatePlayer,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: _thumbnailUrl(videoId),
            fit: BoxFit.cover,
            errorWidget: (_, _, _) => const DecoratedBox(
              decoration: BoxDecoration(color: ColorPalette.info),
            ),
          ),

          Center(
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: ColorPalette.primary,
                shape: BoxShape.circle,
                border: Border.all(color: ColorPalette.textSoftSaga, width: 3),
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
    );
  }

  Widget _buildPlayer() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(
          context,
        ).colorScheme.copyWith(primary: ColorPalette.primary),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: YoutubePlayer(
          controller: _playerController!,
          aspectRatio: _cardAspectRatio,
          backgroundColor: ColorPalette.darkCharcoal,
        ),
      ),
    );
  }
}
