import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jangsin_map/jangsin_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    const int megabyte = 1000000;
    SystemChannels.skia
        .invokeMethod('Skia.setResourceCacheMaxBytes', 512 * megabyte);
    await Future<void>.delayed(Duration.zero);
  }

  await dotenv.load(fileName: ".env");
  await _initSerivice();
  await _initLocalStorage();

  runApp(const AppRoot());
}

Future<void> _initLocalStorage() async {
  GSharedPreferences = await SharedPreferences.getInstance();
}

Future<void> _initSerivice() async {
  GServiceRestaurant = ServiceRestaurant.getInstance();
  GServiceAdmin = ServiceAdmin.getInstance();
}
