part of "../jangsin_map.dart";

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  State<ViewMap> createState() => ViewMapState();
}

class ViewMapState extends State<ViewMap> {
  MediaQueryData get mediaQuery => MediaQuery.of(context);
  bool get isPort => mediaQuery.orientation == Orientation.portrait;

  final Map<String, TextEditingController> mapOfDropdown = {
    KEY.ADMIN_SIDO: TextEditingController(),
    KEY.ADMIN_SIGUNGU: TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          TextButton(
            child: const Text(''),
            onPressed: () {},
            onLongPress: () {
              Navigator.of(context).pushNamed(PATH.ROUTE_ADMIN_LOGIN);
            },
          ),
        ],
      ),
      body: isPort ? buildPortait() : buildLandscape(),
    );
  }

  Widget buildPortait() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const HtmlElementView(viewType: 'naver-map').expand(),
          const Divider(),
          buildMapList().expand(),
        ],
      ),
    );
  }

  Widget buildLandscape() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const HtmlElementView(viewType: 'naver-map').expand(),
          const VerticalDivider(),
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

        return Column(
          children: [
            buildSidoDropdownButton(),
            const Divider(),
            ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: restaurants.length,
              itemBuilder: (context, index) => SizedBox(
                height: 100,
                width: double.infinity,
                child: TileRestaurantUnit(
                  restaurant: restaurants[index],
                  $selectedRestaurant: GServiceRestaurant.$selectedRestaurant,
                  clickEvent: () {
                    // 선택한 식당이 같은 경우 빈 식당 sink$
                    if (GServiceRestaurant.$selectedRestaurant.lastValue.id ==
                        restaurants[index].id) {
                      GServiceRestaurant.$selectedRestaurant
                          .sink$(MRestaurant());
                      return;
                    }

                    // 선택한 식당이 다른 경우 해당 식당을 sink$
                    GServiceRestaurant.$selectedRestaurant
                        .sink$(restaurants[index]);

                    inputDataForHtml(
                      dataType: 'set',
                      data: {
                        'lat': restaurants[index].lat,
                        'lng': restaurants[index].lng
                      },
                    );
                  },
                ),
              ),
            ).expand(),
            PaginationButton(
              currentPage: snapshot.data['current_page'],
              totalPage: snapshot.data['total_page'],
              onPressed: (int page) {
                GServiceRestaurant.pagination(
                  page: page,
                  sido: mapOfDropdown[KEY.ADMIN_SIDO]!.text,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildSidoDropdownButton() {
    return CustomDropdownField(
      value: mapOfDropdown[KEY.ADMIN_SIDO]!.text == ""
          ? DISTRICT.INIT
          : mapOfDropdown[KEY.ADMIN_SIDO]!.text,
      items: DISTRICT.KOREA_ADMINISTRATIVE_DISTRICT.keys
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (dynamic value) {
        mapOfDropdown[KEY.ADMIN_SIDO]!.text = value;
        GServiceRestaurant.pagination(sido: value);
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
    RestfulResult result = await GServiceRestaurant.getLatLng();
    print('result ${result.map}');
    // late List latLngs;
    // if (result.statusCode == 200) {
    //   // return;
    // }
    List latLngs = result.data;

    mapOfDropdown[KEY.ADMIN_SIDO]!.text = DISTRICT.INIT;
    GServiceRestaurant.pagination(page: 1);

    Future.delayed(const Duration(milliseconds: 200),
        () => {inputDataForHtml(dataType: 'init', data: latLngs)});
  }

  Future<void> registerView() async {
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      'naver-map',
      (int id) => html.IFrameElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
        ..src = 'assets/html/map.html',
    );
  }

  Future<void> inputDataForHtml(
      {required String dataType, required dynamic data}) async {
    assert(dataType == 'init' || dataType == 'set',
        'inputDataForHtml exception : dataType is not init or set');
    Map<String, dynamic> mapOfData = {
      'type': dataType,
      'data': data,
    };

    String jsonData = jsonEncode(mapOfData);
    html.window.postMessage(jsonData, '*');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
