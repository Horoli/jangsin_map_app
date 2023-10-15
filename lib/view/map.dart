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
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(''),
        actions: [
          TextButton(
            child: Container(),
            onPressed: () {},
            onLongPress: () {
              Navigator.of(context).pushNamed(PATH.ROUTE_ADMIN_LOGIN);
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
    return TStreamBuilder(
        initialData: RestfulResult(statusCode: 400, message: '', data: null),
        stream: GServiceRestaurant.$pagination.browse$,
        builder: (BuildContext context, RestfulResult snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          List<MRestaurant> restaurants = snapshot.data['pagination_data'];

          List<int> pages =
              List.generate(snapshot.data['total_page'], (index) => index + 1);

          return Column(
            children: [
              TStreamBuilder(
                  stream: GServiceRestaurant.$selectedRestaurant.browse$,
                  builder: (context, MRestaurant selectedRestaurant) {
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) => SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // 선택한 가게 표시용 stack
                            Container(
                              color:
                                  selectedRestaurant.id == restaurants[index].id
                                      ? COLOR.RED
                                      : COLOR.GREEN,
                            ),
                            // 가게 정보
                            TileRestaurantUnit(
                              restaurant: restaurants[index],
                              clickEvent: () {
                                if (selectedRestaurant.id ==
                                    restaurants[index].id) {
                                  GServiceRestaurant.$selectedRestaurant
                                      .sink$(MRestaurant());
                                  return;
                                }
                                GServiceRestaurant.$selectedRestaurant
                                    .sink$(restaurants[index]);

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
                          ],
                        ),
                      ),
                    ).expand();
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pages
                    .map((page) => ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: page == snapshot.data['current_page']
                              ? MaterialStateProperty.all(COLOR.RED)
                              : MaterialStateProperty.all(COLOR.BLUE),
                        ),
                        onPressed: () {
                          GServiceRestaurant.pagination(page: page);
                        },
                        child: Text('$page')))
                    .toList(),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    initMap();
    super.initState();
  }

  Future<void> initMap() async {
    await registerView();
    RestfulResult result = await GServiceRestaurant.getLatLng();
    await GServiceRestaurant.pagination();
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
