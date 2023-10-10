library jangin_map;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui_web' as ui_web;
import 'dart:html' as html;

import 'package:http/http.dart' as http;
import 'package:jangsin_map/model/lib.dart';
// preset
import 'package:jangsin_map/preset/path.dart' as PATH;
import 'package:jangsin_map/preset/key.dart' as KEY;
import 'package:jangsin_map/preset/district.dart' as DISTRICT;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:horoli_package/model/lib.dart';
import 'package:jangsin_map/widget/lib.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnd_pkg_widget/tnd_pkg_widget.dart';

part 'app_root.dart';

part 'service/map.dart';
part 'service/admin.dart';

part 'global.dart';

part 'view/map.dart';
part 'view/admin.dart';
part 'view/admin_login.dart';
