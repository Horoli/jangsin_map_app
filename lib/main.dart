import 'package:jangsin_map/jangsin_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await _initSerivice();
  await _initLocalStorage();

  runApp(AppRoot());
}

Future<void> _initLocalStorage() async {
  GSharedPreferences = await SharedPreferences.getInstance();
}

Future<void> _initSerivice() async {
  GServiceMap = ServiceMap.getInstance();
  GServiceAdmin = ServiceAdmin.getInstance();
}
