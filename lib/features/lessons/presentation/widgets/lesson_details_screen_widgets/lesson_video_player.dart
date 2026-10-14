import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LessonVideoPlayer extends StatelessWidget {
  const LessonVideoPlayer({
    super.key,
    required this.controller,
    this.aspectRatio = 350 / 170,
  });

  final YoutubePlayerController controller;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: YoutubePlayer(
        controller: controller,
        aspectRatio: aspectRatio,
        backgroundColor: ColorPalette.darkCharcoal,
        autoFullScreen: false,
        enableFullScreenOnVerticalDrag: false,
        controlsBuilder: (context, isFullscreen) {
          return Stack(
            children: [
              Positioned(
                right: 8,
                bottom: 48,
                child: Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                  child: IconButton(
                    tooltip: isFullscreen ? 'تصغير الفيديو' : 'تكبير الفيديو',
                    color: Colors.white,
                    iconSize: 26,
                    icon: Icon(
                      isFullscreen
                          ? Icons.fullscreen_exit_rounded
                          : Icons.fullscreen_rounded,
                    ),
                    onPressed: () {
                      if (isFullscreen) {
                        controller.exitFullScreen();
                      } else {
                        controller.enterFullScreen();
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
