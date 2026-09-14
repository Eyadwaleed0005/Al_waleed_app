import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/features/notifications/presentation/services/firebase_notification_background_handler.dart';
import 'package:al_waleed/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations(
      const <DeviceOrientation>[
        DeviceOrientation.portraitUp,
      ],
    );

    await ScreenUtil.ensureScreenSize();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(
      firebaseNotificationBackgroundHandler,
    );

    setupServiceLocator();
  }
}