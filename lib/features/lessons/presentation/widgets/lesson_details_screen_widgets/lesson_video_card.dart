import 'dart:async';

import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/connection/cubit/network_status_state.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool _isCheckingConnection = false;
  bool _isOfflineDialogVisible = false;

  @override
  void didUpdateWidget(LessonVideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoUrl != widget.videoUrl) {
      _closePlayer();
      _restorePortraitOrientation();
    }
  }

  @override
  void dispose() {
    _closePlayer();
    _restorePortraitOrientation();
    super.dispose();
  }

  Future<void> _activatePlayer() async {
    if (_isPlayerActive || _isCheckingConnection) {
      return;
    }

    final videoId = _extractVideoId(widget.videoUrl);

    if (videoId == null) {
      return;
    }

    _isCheckingConnection = true;

    try {
      final hasInternet = await _checkInternetConnection();

      if (!mounted) {
        return;
      }

      if (!hasInternet) {
        unawaited(_showOfflineDialog());
        return;
      }

      _createPlayer(videoId);
    } finally {
      _isCheckingConnection = false;
    }
  }

  Future<bool> _checkInternetConnection() async {
    final networkStatusCubit = context.read<NetworkStatusCubit>();

    await networkStatusCubit.checkConnection();

    if (!mounted) {
      return false;
    }

    return networkStatusCubit.state is NetworkStatusConnected;
  }

  void _createPlayer(String videoId) {
    final controller = YoutubePlayerController.fromVideoId(
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

    controller.setFullScreenListener(_handleFullScreenChanged);

    if (!mounted) {
      unawaited(controller.close());
      return;
    }

    setState(() {
      _playerController = controller;
      _isPlayerActive = true;
    });
  }

  void _handleFullScreenChanged(bool isFullScreen) {
    if (isFullScreen) {
      _setLandscapeOrientation();
      return;
    }

    _restorePortraitOrientation();
  }

  void _setLandscapeOrientation() {
    unawaited(
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]),
    );
  }

  void _restorePortraitOrientation() {
    unawaited(
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
      ]),
    );
  }

  void _closePlayer() {
    final controller = _playerController;

    _playerController = null;
    _isPlayerActive = false;

    if (controller != null) {
      unawaited(controller.close());
    }
  }

  Future<void> _showOfflineDialog() async {
    if (!mounted || _isOfflineDialogVisible) {
      return;
    }

    _isOfflineDialogVisible = true;

    final shouldRetry = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.failure,
          title: 'لا يوجد اتصال بالإنترنت',
          message:
              'تحقق من اتصالك بالإنترنت ثم اضغط على إعادة المحاولة لتشغيل الفيديو.',
          actionText: 'إعادة المحاولة',
          secondaryActionText: 'إلغاء',
          failureIcon: Icons.wifi_off_rounded,
          onActionPressed: () {
            Navigator.of(dialogContext).pop(true);
          },
          onSecondaryActionPressed: () {
            Navigator.of(dialogContext).pop(false);
          },
        );
      },
    );

    _isOfflineDialogVisible = false;

    if (shouldRetry == true && mounted) {
      unawaited(_activatePlayer());
    }
  }

  String? _extractVideoId(String videoUrl) {
    final normalizedUrl = videoUrl.trim();

    if (normalizedUrl.isEmpty) {
      return null;
    }

    final convertedVideoId = YoutubePlayerController.convertUrlToId(
      normalizedUrl,
    );

    if (convertedVideoId != null && convertedVideoId.trim().isNotEmpty) {
      return convertedVideoId.trim();
    }

    final isRawVideoId = RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(normalizedUrl);

    return isRawVideoId ? normalizedUrl : null;
  }

  String _thumbnailUrl(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final videoId = _extractVideoId(widget.videoUrl);

    return AspectRatio(
      aspectRatio: _cardAspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _buildContent(videoId),
        ),
      ),
    );
  }

  Widget _buildContent(String? videoId) {
    if (videoId == null) {
      return _buildInvalidVideoView();
    }

    if (_isPlayerActive && _playerController != null) {
      return _buildPlayer();
    }

    return _buildThumbnailPreview(videoId);
  }

  Widget _buildThumbnailPreview(String videoId) {
    return GestureDetector(
      key: const ValueKey('video-thumbnail'),
      onTap: _activatePlayer,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: _thumbnailUrl(videoId),
            fit: BoxFit.cover,
            placeholder: (_, _) {
              return const ColoredBox(
                color: ColorPalette.primarySoftBackground,
                child: Center(
                  child: CircularProgressIndicator(color: ColorPalette.primary),
                ),
              );
            },
            errorWidget: (_, _, _) {
              return const ColoredBox(
                color: ColorPalette.primarySoftBackground,
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: ColorPalette.primary,
                  ),
                ),
              );
            },
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black38],
              ),
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
                  width: 3.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 12.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
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

  Widget _buildInvalidVideoView() {
    return ColoredBox(
      key: const ValueKey('invalid-video'),
      color: ColorPalette.primarySoftBackground,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 40.sp,
              color: ColorPalette.primary,
            ),
            SizedBox(height: 8.h),
            Text(
              'رابط الفيديو غير صالح',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorPalette.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    return Theme(
      key: const ValueKey('youtube-player'),
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
          autoFullScreen: false,
          enableFullScreenOnVerticalDrag: false,
        ),
      ),
    );
  }
}
