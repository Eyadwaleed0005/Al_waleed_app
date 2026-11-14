abstract final class YoutubeThumbnailHelper {
  const YoutubeThumbnailHelper._();

  static final RegExp _videoIdPattern = RegExp(r'^[a-zA-Z0-9_-]{11}$');

  static String? thumbnailUrl(String url) {
    final videoId = extractVideoId(url);

    if (videoId == null) return null;

    return 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg';
  }

  static String? extractVideoId(String url) {
    final value = url.trim();

    if (value.isEmpty) return null;

    if (_videoIdPattern.hasMatch(value)) {
      return value;
    }

    final normalizedUrl = value.startsWith('//')
        ? 'https:$value'
        : value.contains('://')
        ? value
        : 'https://$value';

    final uri = Uri.tryParse(normalizedUrl);

    if (uri == null) return null;

    final host = uri.host.toLowerCase();
    final segments = uri.pathSegments;

    String? videoId;

    if (host == 'youtu.be' || host == 'www.youtu.be') {
      videoId = segments.isNotEmpty ? segments.first : null;
    } else if (host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtube-nocookie.com' ||
        host.endsWith('.youtube-nocookie.com')) {
      videoId = uri.queryParameters['v'];

      if (videoId == null &&
          segments.length >= 2 &&
          const ['embed', 'shorts', 'live', 'v'].contains(segments.first)) {
        videoId = segments[1];
      }
    }

    if (videoId == null || !_videoIdPattern.hasMatch(videoId)) {
      return null;
    }

    return videoId;
  }
}
