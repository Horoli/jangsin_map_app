part of 'common.dart';

class WebViewMainController {
  static WebViewMainController? _instance;
  factory WebViewMainController.getInstance() =>
      _instance ??= WebViewMainController._internal();
  WebViewMainController._internal();

  Future<String> getHtmlFromAssets() async {
    return await rootBundle.loadString('assets/html/map.html');
  }
}
