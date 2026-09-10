import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> launchSessionUrl(String sessionLink) async {
    final link = sessionLink.trim();
    if (link.isEmpty) return;

    final Uri url = Uri.parse(link);
    
    try {
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        await launchUrl(
          url,
          mode: LaunchMode.platformDefault,
        );
      }
    } catch (e) {
      log('Could not launch $url: $e');
    }
  }
}