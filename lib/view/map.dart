part of "../jangsin_map.dart";

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  State<ViewMap> createState() => ViewMapState();
}

class ViewMapState extends State<ViewMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(''),
        actions: [
          TextButton(
            child: Container(),
            onPressed: () {},
            onLongPress: () {
              Navigator.of(context).pushNamed(PATH.ADMIN_LOGIN);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          const HtmlElementView(viewType: 'naver-map').expand(),
          buildMapList().expand(),
        ],
      ),
    );
  }

  Widget buildMapList() {
    return FutureBuilder(
      future: GServiceMap.get(),
      builder: (
        BuildContext context,
        AsyncSnapshot<RestfulResult> snapshot,
      ) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        List<MRestaurant> restaurants = snapshot.data!.data;

        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: restaurants.length,
          itemBuilder: (context, index) => SizedBox(
            height: 100,
            width: double.infinity,
            child: TileMapUnit(
              restaurant: restaurants[index],
              clickEvent: () {
                Map<String, dynamic> data = {
                  'type': 'set',
                  'data': {
                    'lat': restaurants[index].lat,
                    'lng': restaurants[index].lng
                  },
                };

                String jsonData = jsonEncode(data);

                html.window.postMessage(jsonData, '*');
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    initMap();
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
      // 'src': dotenv.env['NAVER_MAP_CLIENT_SRC'],
    };
    String jsonData = jsonEncode(data);
    print('jsonData $jsonData');
    html.window.postMessage(jsonData, '*');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
