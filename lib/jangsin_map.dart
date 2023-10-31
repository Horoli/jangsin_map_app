library jangin_map;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui_web' as ui_web;
import 'dart:html' as html;

import 'package:http/http.dart' as http;
import 'package:jangsin_map/model/lib.dart';
import 'package:jangsin_map/widget/lib.dart';
// preset
import 'package:jangsin_map/preset/path.dart' as PATH;
import 'package:jangsin_map/preset/key.dart' as KEY;
import 'package:jangsin_map/preset/district.dart' as DISTRICT;
import 'package:jangsin_map/preset/label.dart' as LABEL;
import 'package:jangsin_map/preset/color.dart' as COLOR;
import 'package:jangsin_map/preset/icon.dart' as ICON;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:horoli_package/model/lib.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnd_core/tnd_core.dart';
import 'package:tnd_pkg_widget/tnd_pkg_widget.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';

part 'app_root.dart';

part 'service/restaurant.dart';
part 'service/admin.dart';

part 'global.dart';

part 'utility.dart';

part 'view/splash.dart';
part 'view/server_disconnect.dart';
part 'view/loading.dart';
part 'view/map.dart';
part 'view/admin/admin.dart';
part 'view/admin/admin_login.dart';
