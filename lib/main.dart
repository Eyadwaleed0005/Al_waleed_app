import 'package:al_waleed/app/al_waleed_app.dart';
import 'package:al_waleed/app/app_initializer.dart';
import 'package:al_waleed/core/services/device_preview_service.dart';

Future<void> main() async {
  await AppInitializer.initialize();
  DevicePreviewService.run(child: const AlWaleedApp());
}
