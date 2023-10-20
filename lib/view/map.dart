part of "../jangsin_map.dart";

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  State<ViewMap> createState() => ViewMapState();
}

class ViewMapState extends State<ViewMap> {
  MediaQueryData get mediaQuery => MediaQuery.of(context);
  bool get isPort => mediaQuery.orientation == Orientation.portrait;
  double get width => mediaQuery.size.width;
  double get height => mediaQuery.size.height;

  final TextEditingController ctrlSido = TextEditingController();

  // final Map<String, TextEditingController> mapOfDropdown = {
  //   KEY.ADMIN_SIDO: TextEditingController(),
  //   KEY.ADMIN_SIGUNGU: TextEditingController(),
  // };

  @override
  Widget build(BuildContext context) {
    print('mediaQuery.viewPadding.top ${mediaQuery.viewPadding.top}');

    return isPort ? buildPortait() : buildLandscape();
  }

  // TODO : 세로모드(mobile) 인 경우, appBar 미출력
  Widget buildPortait() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  height: kToolbarHeight,
                  // color: Colors.amber,
                  child: Row(
                    children: [
                      buildSelectSidoDialogButton(),
                      const Padding(padding: EdgeInsets.all(8)),
                      TextField(
                        // style: TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          // focusColor: Colors.black,
                          border: OutlineInputBorder(),
                          labelText: LABEL.SELECT_REGION,
                        ),
                        controller: ctrlSido,
                        readOnly: true,
                      ).expand(),
                    ],
                  ),
                ),
                const HtmlElementView(viewType: 'naver-map').expand(),
              ],
            ).expand(),
            const Divider(),
            buildMapList().expand(),
          ],
        ),
      ),
    );
  }

  // TODO : 가로모드인 경우, appBar 출력
  Widget buildLandscape() {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const HtmlElementView(viewType: 'naver-map').expand(),
            const VerticalDivider(),
            buildMapList().expand(),
          ],
        ),
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
            ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: restaurants.length,
              itemBuilder: (context, index) => SizedBox(
                height: 100,
                width: double.infinity,
                child: TileRestaurantUnit(
                  restaurant: restaurants[index],
                  $selectedRestaurant: GServiceRestaurant.$selectedRestaurant,
                  onPressed: () {
                    // 선택한 식당이 같은 경우 빈 식당 sink$
                    // if (GServiceRestaurant.$selectedRestaurant.lastValue.id ==
                    //     restaurants[index].id) {
                    //   GServiceRestaurant.$selectedRestaurant
                    //       .sink$(MRestaurant());
                    //   return;
                    // }

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
                  sido: ctrlSido.text,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildSelectSidoDialogButton() {
    return ElevatedButton(
      child: const Text(LABEL.SELECT_REGION),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PointerInterceptor(
              child: AlertDialog(
                content: SizedBox(
                  width: isPort ? width * 0.8 : width * 0.4,
                  height: isPort ? height * 0.4 : height * 0.4,
                  child: ListView.separated(
                    // gridDelegate:
                    //     const SliverGridDelegateWithFixedCrossAxisCount(
                    //   crossAxisCount: 3,
                    // childAspectRatio: 1.0,
                    // crossAxisSpacing: 2.0,
                    // mainAxisSpacing: 2.0,
                    // ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount:
                        DISTRICT.KOREA_ADMINISTRATIVE_DISTRICT.keys.length,
                    itemBuilder: (BuildContext context, int index) {
                      String sido = DISTRICT.KOREA_ADMINISTRATIVE_DISTRICT.keys
                          .toList()[index];
                      return ElevatedButton(
                        child: AutoSizeText(sido, maxLines: 2),
                        onPressed: () {
                          Navigator.pop(context);
                          GServiceRestaurant.pagination(sido: sido);
                          ctrlSido.text = sido;
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
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
    RestfulResult result = await GServiceRestaurant.getLatLng();
    List latLngs = result.data;

    ctrlSido.text = "전체";
    GServiceRestaurant.pagination(page: 1);

    Future.delayed(const Duration(milliseconds: 200),
        () => {inputDataForHtml(dataType: 'init', data: latLngs)});
  }

  Future<void> registerView() async {
    String htmlPath =
        PATH.IS_LOCAL ? PATH.MAP_HTML_LOCAL : PATH.MAP_HTML_FORIEGN;

    ui_web.platformViewRegistry.registerViewFactory(
      'naver-map',
      (int id) => html.IFrameElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
        ..src = htmlPath,
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
