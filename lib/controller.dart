part of 'common.dart';

class WebViewMainController {
  static WebViewMainController? _instance;
  factory WebViewMainController.getInstance() =>
      _instance ??= WebViewMainController._internal();
  WebViewMainController._internal();

  final WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
          // TODO
          ),
    )
    ..addJavaScriptChannel('map',
        onMessageReceived: (JavaScriptMessage message) {
      print(message.message);
    });

  WebViewController getWebViewController() => webViewController;
}
