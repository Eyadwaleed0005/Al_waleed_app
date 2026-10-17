import 'dart:async';

import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'video_playback_speed_button.dart';

class LessonVideoControls extends StatefulWidget {
  const LessonVideoControls({
    super.key,
    required this.controller,
    required this.onClose,
  });

  final YoutubePlayerController controller;
  final VoidCallback onClose;

  @override
  State<LessonVideoControls> createState() => _LessonVideoControlsState();
}

class _LessonVideoControlsState extends State<LessonVideoControls> {
  StreamSubscription<YoutubePlayerValue>? _playerSubscription;
  StreamSubscription<Duration>? _positionSubscription;

  Timer? _hideTimer;
  Timer? _feedbackTimer;

  late YoutubePlayerValue _playerValue;

  Duration _position = Duration.zero;

  bool _controlsVisible = true;
  bool _isSeeking = false;
  bool _isChangingPlayback = false;

  double? _dragSeconds;
  int? _seekFeedback;

  double get _durationSeconds =>
      _playerValue.metaData.duration.inMilliseconds / 1000;

  bool get _isPlaying => _playerValue.playerState == PlayerState.playing;

  bool get _isVideoLoading =>
      !_playerValue.hasError &&
      (_playerValue.playerState == PlayerState.buffering ||
          _playerValue.metaData.videoId.isEmpty);

  @override
  void initState() {
    super.initState();

    _playerValue = widget.controller.value;

    _playerSubscription = widget.controller.listen(
      _handlePlayerValue,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Video player stream error: $error');
      },
    );

    _positionSubscription = widget.controller
        .getCurrentPositionStream(period: const Duration(milliseconds: 500))
        .listen(
          (position) {
            if (!mounted) return;

            setState(() {
              _position = position;
            });
          },
          onError: (Object error, StackTrace stackTrace) {
            debugPrint('Video position error: $error');
          },
        );

    _scheduleHide();
  }

  void _handlePlayerValue(YoutubePlayerValue value) {
    if (!mounted) return;

    final wasPlaying = _isPlaying;
    final previouslyHadError = _playerValue.hasError;

    setState(() {
      _playerValue = value;

      if (!_isPlaying) {
        _controlsVisible = true;
      }
    });

    if (value.hasError && !previouslyHadError) {
      _showError('تعذّر تشغيل الفيديو، أغلقه وحاول مرة أخرى.');
    }

    if (_isPlaying && !wasPlaying) {
      _scheduleHide();
    } else if (!_isPlaying) {
      _hideTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _feedbackTimer?.cancel();

    unawaited(_playerSubscription?.cancel());
    unawaited(_positionSubscription?.cancel());

    super.dispose();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();

    if (!_isPlaying || _dragSeconds != null) {
      return;
    }

    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted || !_isPlaying || _dragSeconds != null) {
        return;
      }

      setState(() {
        _controlsVisible = false;
      });
    });
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });

    if (_controlsVisible) {
      _scheduleHide();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    showAppToast(context, message: message, icon: Icons.error_outline_rounded);
  }

  Future<void> _togglePlayback() async {
    if (_isChangingPlayback || _isVideoLoading) {
      return;
    }

    _isChangingPlayback = true;

    try {
      if (_isPlaying) {
        await widget.controller.pauseVideo();
      } else {
        if (_playerValue.playerState == PlayerState.ended) {
          await widget.controller.seekTo(seconds: 0, allowSeekAhead: true);
        }

        await widget.controller.playVideo();
      }
    } catch (_) {
      _showError('تعذّر التحكم في الفيديو، حاول مرة أخرى.');
    } finally {
      _isChangingPlayback = false;

      if (mounted) {
        _scheduleHide();
      }
    }
  }

  Future<bool> _seekTo(double seconds) async {
    final duration = await widget.controller.duration;

    if (!mounted) return false;

    if (duration <= 0) {
      _showError('انتظر تحميل الفيديو ثم حاول مرة أخرى.');
      return false;
    }

    final target = seconds.clamp(0.0, duration).toDouble();

    await widget.controller.seekTo(seconds: target, allowSeekAhead: true);

    if (!mounted) return false;

    setState(() {
      _position = Duration(milliseconds: (target * 1000).round());
    });

    return true;
  }

  Future<void> _seekBy(int seconds) async {
    if (_isSeeking) return;

    _isSeeking = true;

    try {
      final position = await widget.controller.currentTime;

      if (!mounted) return;

      final succeeded = await _seekTo(position + seconds);

      if (!mounted || !succeeded) return;

      _feedbackTimer?.cancel();

      setState(() {
        _seekFeedback = seconds;
      });

      _feedbackTimer = Timer(const Duration(milliseconds: 700), () {
        if (mounted) {
          setState(() {
            _seekFeedback = null;
          });
        }
      });

      _scheduleHide();
    } catch (_) {
      _showError('تعذّر تقديم أو إرجاع الفيديو.');
    } finally {
      _isSeeking = false;
    }
  }

  Future<void> _finishDragging(double seconds) async {
    try {
      await _seekTo(seconds);
    } catch (_) {
      _showError('تعذّر تغيير موضع الفيديو.');
    } finally {
      if (mounted) {
        setState(() {
          _dragSeconds = null;
        });

        _scheduleHide();
      }
    }
  }

  String _formatTime(double seconds) {
    final totalSeconds = seconds.floor();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final remainingSeconds = totalSeconds % 60;

    final mm = minutes.toString().padLeft(2, '0');
    final ss = remainingSeconds.toString().padLeft(2, '0');

    return hours > 0 ? '$hours:$mm:$ss' : '$mm:$ss';
  }

  Widget _buildTouchArea(int seconds) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleControls,
        onDoubleTap: () => _seekBy(seconds),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildSeekFeedback() {
    final seconds = _seekFeedback;

    if (seconds == null) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment: seconds > 0
              ? const Alignment(0.6, 0)
              : const Alignment(-0.6, 0),
          child: Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: ColorPalette.textBlack.withValues(alpha: 0.54),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  seconds > 0
                      ? Icons.forward_10_rounded
                      : Icons.replay_10_rounded,
                  color: ColorPalette.textLight,
                  size: 40.r,
                ),
                verticalSpace(6),
                Text(
                  seconds > 0 ? 'تقديم ١٠ ثواني' : 'رجوع ١٠ ثواني',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: ColorPalette.textLight,
                    fontFamily: 'Tajawal',
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 8.h,
      left: 12.w,
      child: VideoPlaybackSpeedButton(controller: widget.controller),
    );
  }

  Widget _buildPlaybackButton() {
    if (_isVideoLoading) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Material(
        color: ColorPalette.textBlack.withValues(alpha: 0.30),
        shape: const CircleBorder(),
        child: IconButton(
          tooltip: _isPlaying ? 'إيقاف مؤقت' : 'تشغيل',
          onPressed: _togglePlayback,
          color: ColorPalette.textLight,
          iconSize: 52.r,
          padding: EdgeInsets.all(8.r),
          icon: Icon(
            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          ),
        ),
      ),
    );
  }

  Widget _buildVideoLoading() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: AppLoadingIndicator(
            color: ColorPalette.highlight,
            size: 36.r,
            strokeWidth: 3.r,
            wavelength: 14.r,
            waveSpeed: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final duration = _durationSeconds;
    final maxSeconds = duration > 0 ? duration : 1.0;

    final positionSeconds = _position.inMilliseconds / 1000;

    final displayedSeconds = (_dragSeconds ?? positionSeconds)
        .clamp(0.0, maxSeconds)
        .toDouble();

    final timeStyle = TextStyle(
      color: ColorPalette.textLight,
      fontFamily: 'Tajawal',
      fontSize: 7.sp,
    );

    return Positioned(
      left: 12.w,
      right: 12.w + 48.r + 8.w,
      bottom: 8.h,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: ColorPalette.textBlack.withValues(alpha: 0.54),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Text(_formatTime(displayedSeconds), style: timeStyle),
            horizontalSpace(4),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3.r,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                ),
                child: Slider(
                  value: displayedSeconds,
                  min: 0,
                  max: maxSeconds,
                  activeColor: ColorPalette.highlight,
                  inactiveColor: ColorPalette.textLight.withValues(alpha: 0.30),
                  onChangeStart: duration <= 0
                      ? null
                      : (value) {
                          _hideTimer?.cancel();

                          setState(() {
                            _dragSeconds = value;
                          });
                        },
                  onChanged: duration <= 0
                      ? null
                      : (value) {
                          setState(() {
                            _dragSeconds = value;
                          });
                        },
                  onChangeEnd: duration <= 0
                      ? null
                      : (value) {
                          unawaited(_finishDragging(value));
                        },
                ),
              ),
            ),
            horizontalSpace(4),
            Text(_formatTime(duration), style: timeStyle),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      right: 12.w,
      bottom: 12.h,
      child: Material(
        color: ColorPalette.textBlack.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(10.r),
        child: IconButton(
          tooltip: 'تصغير الفيديو',
          onPressed: widget.onClose,
          color: ColorPalette.textLight,
          iconSize: 26.r,
          padding: EdgeInsets.all(8.r),
          constraints: BoxConstraints(minWidth: 48.r, minHeight: 48.r),
          icon: const Icon(Icons.fullscreen_exit_rounded),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Row(children: [_buildTouchArea(-10), _buildTouchArea(10)]),
          IgnorePointer(
            ignoring: !_controlsVisible,
            child: AnimatedOpacity(
              opacity: _controlsVisible ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const IgnorePointer(
                    child: ColoredBox(color: ColorPalette.ligthBlackShadow),
                  ),
                  _buildTopControls(),
                  _buildPlaybackButton(),
                  _buildProgressBar(),
                ],
              ),
            ),
          ),
          _buildSeekFeedback(),
          if (_isVideoLoading) _buildVideoLoading(),
          _buildCloseButton(),
        ],
      ),
    );
  }
}
