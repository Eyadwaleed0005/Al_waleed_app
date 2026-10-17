import 'dart:async';

import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/connection/cubit/network_status_state.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'lesson_video_fullscreen_page.dart';

class LessonVideoCard extends StatefulWidget {
  const LessonVideoCard({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<LessonVideoCard> createState() => _LessonVideoCardState();
}

class _LessonVideoCardState extends State<LessonVideoCard> {
  static const double _cardAspectRatio = 350 / 170;

  bool _isCheckingConnection = false;
  bool _isOpeningVideo = false;
  bool _isOfflineDialogVisible = false;

  int _activationGeneration = 0;

  @override
  void didUpdateWidget(covariant LessonVideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoUrl != widget.videoUrl) {
      _activationGeneration++;
      _isCheckingConnection = false;
    }
  }

  @override
  void dispose() {
    _activationGeneration++;
    super.dispose();
  }

  Future<void> _activatePlayer() async {
    if (_isOpeningVideo || _isOfflineDialogVisible) {
      return;
    }

    final videoId = _extractVideoId(widget.videoUrl);

    if (videoId == null) {
      return;
    }

    final generation = ++_activationGeneration;

    bool changedOrientation = false;
    bool shouldRetry = false;
    bool failed = false;

    setState(() {
      _isOpeningVideo = true;
      _isCheckingConnection = true;
    });

    try {
      final hasInternet = await _checkInternetConnection();

      if (!mounted || generation != _activationGeneration) {
        return;
      }

      setState(() {
        _isCheckingConnection = false;
      });

      if (!hasInternet) {
        shouldRetry = await _showOfflineDialog();
      } else {
        changedOrientation = true;

        await SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);

        if (!mounted || generation != _activationGeneration) {
          return;
        }

        await Navigator.of(context, rootNavigator: true).push<void>(
          MaterialPageRoute<void>(
            builder: (_) {
              return LessonVideoFullscreenPage(videoId: videoId);
            },
          ),
        );
      }
    } catch (_) {
      failed = true;
    } finally {
      try {
        if (changedOrientation) {
          await SystemChrome.setPreferredOrientations(const [
            DeviceOrientation.portraitUp,
          ]);
        }
      } catch (_) {
        failed = true;
      } finally {
        _isOpeningVideo = false;

        if (mounted) {
          setState(() {
            _isCheckingConnection = false;
          });
        }
      }
    }

    if (!mounted || generation != _activationGeneration) {
      return;
    }

    if (failed) {
      await _showPlaybackErrorDialog();
    } else if (shouldRetry) {
      unawaited(_activatePlayer());
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

  Future<bool> _showOfflineDialog() async {
    if (!mounted || _isOfflineDialogVisible) {
      return false;
    }

    _isOfflineDialogVisible = true;

    try {
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

      return shouldRetry == true;
    } finally {
      _isOfflineDialogVisible = false;
    }
  }

  Future<void> _showPlaybackErrorDialog() async {
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CustomOperationResultDialog(
          type: CustomOperationResultType.failure,
          title: 'تعذّر تشغيل الفيديو',
          message: 'حدث خطأ أثناء تجهيز الفيديو، حاول مرة أخرى.',
          actionText: 'حسناً',
          onActionPressed: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  String? _extractVideoId(String videoUrl) {
    final normalizedUrl = videoUrl.trim();

    if (normalizedUrl.isEmpty) {
      return null;
    }

    final convertedId = YoutubePlayerController.convertUrlToId(normalizedUrl);

    if (convertedId != null && convertedId.trim().isNotEmpty) {
      return convertedId.trim();
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
        child: videoId == null
            ? _buildInvalidVideoView()
            : _buildThumbnailPreview(videoId),
      ),
    );
  }

  Widget _buildThumbnailPreview(String videoId) {
    final isBusy = _isOpeningVideo || _isCheckingConnection;

    return Semantics(
      button: true,
      enabled: !isBusy,
      label: 'تشغيل فيديو الدرس بملء الشاشة',
      child: GestureDetector(
        onTap: isBusy ? null : _activatePlayer,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: _thumbnailUrl(videoId),
              fit: BoxFit.cover,
              placeholder: (context, imageUrl) {
                return const ColoredBox(
                  color: ColorPalette.primarySoftBackground,
                );
              },
              errorWidget: (context, imageUrl, error) {
                return const ColoredBox(
                  color: ColorPalette.primarySoftBackground,
                );
              },
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorPalette.textBlack.withValues(alpha: 0),
                    ColorPalette.textBlack.withValues(alpha: 0.38),
                  ],
                ),
              ),
            ),
            Center(
              child: _isCheckingConnection
                  ? _buildLoadingIndicator()
                  : _buildPlayButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorPalette.textBlack.withValues(alpha: 0.54),
        shape: BoxShape.circle,
      ),
      child: const AppLoadingIndicator(
        color: ColorPalette.textLight,
        size: 30,
        strokeWidth: 3,
        wavelength: 14,
        waveSpeed: 10,
      ),
    );
  }

  Widget _buildPlayButton() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: ColorPalette.primary,
        shape: BoxShape.circle,
        border: Border.all(color: ColorPalette.textSoftSaga, width: 3.w),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.textBlack.withValues(alpha: 0.25),
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
    );
  }

  Widget _buildInvalidVideoView() {
    return ColoredBox(
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
}
