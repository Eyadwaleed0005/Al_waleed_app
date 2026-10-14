import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LessonVideoFullscreenPage extends StatefulWidget {
  const LessonVideoFullscreenPage({super.key, required this.videoId});

  final String videoId;

  @override
  State<LessonVideoFullscreenPage> createState() =>
      _LessonVideoFullscreenPageState();
}

class _LessonVideoFullscreenPageState extends State<LessonVideoFullscreenPage> {
  late final YoutubePlayerController _controller;

  bool _isClosing = false;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        interfaceLanguage: 'ar',
        captionLanguage: 'ar',
        playsInline: true,
        enableCaption: false,
        strictRelatedVideos: true,
        showControls: true,
        showFullscreenButton: false,
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_controller.close());
    super.dispose();
  }

  void _closeVideo() {
    if (_isClosing) {
      return;
    }

    _isClosing = true;
    Navigator.of(context).pop();
  }

  void _pauseOnExit() {
    unawaited(
      _controller.pauseVideo().catchError((
        Object error,
        StackTrace stackTrace,
      ) {
        // قد يكون المشغّل اتقفل بالفعل أثناء الخروج.
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _pauseOnExit();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
                backgroundColor: Colors.black,
                autoFullScreen: false,
                enableFullScreenOnVerticalDrag: false,
                controlsBuilder: (context, isFullscreen) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        right: 8,
                        bottom: 48,
                        child: Material(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                          child: IconButton(
                            tooltip: 'تصغير الفيديو',
                            color: Colors.white,
                            iconSize: 28,
                            icon: const Icon(Icons.fullscreen_exit_rounded),
                            onPressed: _closeVideo,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
