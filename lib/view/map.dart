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

  final ScrollController ctrlScroll = ScrollController();

  final TextEditingController ctrlSido = TextEditingController();

  // final Map<String, TextEditingController> mapOfDropdown = {
  //   KEY.ADMIN_SIDO: TextEditingController(),
  //   KEY.ADMIN_SIGUNGU: TextEditingController(),
  // };

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  height: kToolbarHeight,
                  child: buildRegionSelectField(),
                )
              ],
            ),
            const HtmlElementView(viewType: 'naver-map').expand(),
            // Container(color: Colors.red).expand(),
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
            Column(
              children: [
                SizedBox(
                  height: kToolbarHeight,
                  child: buildRegionSelectField(),
                ),
                const Divider(),
                Row(
                  children: [
                    buildMapList().expand(),
                    const VerticalDivider(),
                    const HtmlElementView(viewType: 'naver-map').expand(),
                  ],
                ).expand(),
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }

  Widget buildRegionSelectField() {
    return TextField(
      onTap: () => selectRegionDialog(),
      decoration: const InputDecoration(
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VerticalDivider(),
            Icon(Icons.search),
            Padding(padding: EdgeInsets.all(4)),
          ],
        ),
        suffixIconColor: COLOR.WHITE,
        border: OutlineInputBorder(),
        labelText: LABEL.SELECT_REGION,
      ),
      controller: ctrlSido,
      readOnly: true,
    );
  }

  Widget buildMapList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TStreamBuilder(
          initialData: RestfulResult(statusCode: 400, message: '', data: null),
          stream: GServiceRestaurant.$pagination.browse$,
          builder: (BuildContext context, RestfulResult snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            List<MRestaurant> restaurants = snapshot.data['pagination_data'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText('검색결과 : ${snapshot.data['dataCount']}개'),
                const Divider(),
                ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) => SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: TileRestaurantUnit(
                      restaurant: restaurants[index],
                      $selectedRestaurant:
                          GServiceRestaurant.$selectedRestaurant,
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
                const Divider(),
                PaginationButton(
                  currentPage: snapshot.data['current_page'],
                  totalPage: snapshot.data['total_page'],
                  onPressed: (int page) {
                    if (ctrlSido.text == LABEL.ALL) {
                      GServiceRestaurant.pagination(page: page);
                      return;
                    }
                    GServiceRestaurant.pagination(
                      page: page,
                      sido: ctrlSido.text,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> selectRegionDialog() {
    List<String> sidoList =
        DISTRICT.KOREA_ADMINISTRATIVE_DISTRICT.keys.toList();
    sidoList.insert(0, DISTRICT.ALL);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PointerInterceptor(
          child: AlertDialog(
            content: SizedBox(
              width: isPort ? width * 1.8 : width * 0.4,
              height: isPort ? height * 1.3 : height * 0.4,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.0,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                ),
                itemCount: sidoList.length,
                itemBuilder: (BuildContext context, int index) {
                  String sido = sidoList[index];
                  return ElevatedButton(
                    child: AutoSizeText(sido, maxLines: 1),
                    onPressed: () async {
                      if (sido == DISTRICT.ALL) {
                        Navigator.pop(context);
                        ctrlSido.text = DISTRICT.ALL;
                        GServiceRestaurant.pagination(page: 1);
                        return;
                      }

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

    ctrlSido.text = LABEL.ALL;
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
