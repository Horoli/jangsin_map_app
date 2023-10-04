part of '../common.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebViewXController webViewXController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(''),
        ),
        body: HtmlElementView(viewType: 'naver-map')
        // body: Center(child: buildWebViewX()),
        );
  }

  Widget buildWebViewX() {
    return FutureBuilder(
        future: GWebView.getHtmlFromAssets(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data == null) {
            return Container();
          }

          return WebViewX(
            width: 1000,
            height: 1000,
            initialContent: 'naver-map',
            initialSourceType: SourceType.html,
            onWebViewCreated: (controller) {
              webViewXController = controller;
            },
            javascriptMode: JavascriptMode.unrestricted,
          );
        });
  }

  @override
  void initState() {
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      'naver-map',
      (int id) => IFrameElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..src = 'assets/html/map.html',
    );
    super.initState();
    GWebView.getHtmlFromAssets();
  }
}
