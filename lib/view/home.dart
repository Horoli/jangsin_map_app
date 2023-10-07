part of '../common.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> location = {
    'type': 'init',
    'data': {
      'aaa': {'lat': '37.3595704', 'lng': '127.105399'},
      'bbb': {
        'lat': '37.4824419369998',
        'lng': '126.84983521857548',
      }
    }
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(''),
        ),
        body: Column(
          children: [
            // Expanded(
            //   child: FutureBuilder(
            //     future: GServiceMap.getLatLng(),
            //     builder: (BuildContext context, AsyncSnapshot snapshot) {
            //       return Container();
            //     },
            //   ),
            // ),
            const Expanded(
              child: HtmlElementView(
                viewType: 'naver-map',
                // onPlatformViewCreated: (int a) {},
              ),
            ),
            ElevatedButton(
              child: Text('aa'),
              onPressed: () async {
                // html.window.postMessage(
                //     jsonEncode({
                //       "type": "set",
                //       "data": {
                //         "": {
                //           "lng": '126.75',
                //           "lat": '36.3333',
                //         }
                //       }
                //     }),
                //     "*");
              },
            ),
          ],
        ));
  }

  @override
  void initState() {
    initMap();

    // html.window.addEventListener('message', (event) {
    //   var asd = (event as html.MessageEvent).data;
    //   print('listener $asd');
    // }, true);

    super.initState();
  }

  Future<void> initMap() async {
    await registerView();
    RestfulResult result = await GServiceMap.getLatLng();
    List latLngs = result.data;
    Future.delayed(
        const Duration(milliseconds: 500), () => {postMessage(latLngs)});
  }

  Future<void> registerView() async {
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      'naver-map',
      (int id) => html.IFrameElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..src = 'assets/html/map.html',
    );
  }

  Future<void> postMessage(dynamic latLng) async {
    Map<String, dynamic> data = {
      'type': 'init',
      'data': latLng,
    };
    String jsonData = jsonEncode(data);
    print('jsonData $jsonData');
    html.window.postMessage(jsonData, '*');
  }

  @override
  void dispose() {
    // html.window.removeEventListener('message', (event) {
    //   print('remove event listener');
    // }, true);
    super.dispose();
  }
}
