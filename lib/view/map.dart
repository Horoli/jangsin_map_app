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
  final int splashDuration = 2000;

  final ScrollController ctrlScroll = ScrollController();

  final TextEditingController ctrlSido = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TStreamBuilder(
      initialData: RestfulResult(statusCode: 400, message: '', data: null),
      stream: GServiceRestaurant.$pagination.browse$,
      builder: (BuildContext context, RestfulResult snapshot) {
        print('snapshot.statusCode ${snapshot.statusCode}');
        if (snapshot.statusCode == 403) {
          return ViewServerDisconnect();
        }
        if (snapshot.statusCode != 200) {
          return ViewDataLoading();
        }

        return isPort ? buildPortait(snapshot) : buildLandscape(snapshot);
      },
    );
  }

  // TODO : 세로모드(mobile) 인 경우, appBar 미출력
  Widget buildPortait(RestfulResult snapshot) {
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
            buildMapList(snapshot).expand(),
          ],
        ),
      ),
    );
  }

  // TODO : 가로모드인 경우, appBar 출력
  Widget buildLandscape(RestfulResult snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jangsin Map'),
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
                    buildMapList(snapshot).expand(),
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
      controller: ctrlSido,
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
      readOnly: true,
      autocorrect: false,
      onTap: () => selectRegionDialog(),
    );
  }

  Widget buildMapList(RestfulResult snapshot) {
    List<MRestaurant> restaurants = snapshot.data['pagination_data'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText('검색결과 : ${snapshot.data['dataCount']}개'),
                AutoSizeText('페이지 당 ${snapshot.data['limit']}개 표시'),
              ],
            ),
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
              width: isPort ? width * 0.8 : width * 0.4,
              height: isPort ? height * 0.7 : height * 0.4,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isPort ? 2 : 5,
                  childAspectRatio: isPort ? 2.0 : 1.5,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: sidoList.length,
                itemBuilder: (BuildContext context, int index) {
                  String sido = sidoList[index];
                  return ElevatedButton(
                    child: AutoSizeText(sido, maxLines: 1),
                    onPressed: () async {
                      if (sido == DISTRICT.ALL) {
                        Navigator.pop(context);
                        ctrlSido.value = ctrlSido.value.copyWith(
                          text: DISTRICT.ALL,
                          selection: const TextSelection.collapsed(
                              offset: DISTRICT.ALL.length),
                          composing: TextRange.empty,
                        );
                        GServiceRestaurant.pagination(page: 1);
                        return;
                      }

                      Navigator.pop(context);
                      GServiceRestaurant.pagination(sido: sido);
                      // ctrlSido.text = sido;
                      // ctrlSido.selection =
                      //     TextSelection.collapsed(offset: sido.length);

                      ctrlSido.value = ctrlSido.value.copyWith(
                        text: sido,
                        selection: TextSelection.collapsed(offset: sido.length),
                        composing: TextRange.empty,
                      );
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
    super.initState();
    initMap();
  }

  Future<void> initMap() async {
    ctrlSido.text = LABEL.ALL;
    await registerNaverMap();
    await GUtility.wait(splashDuration);
    await GServiceRestaurant.pagination();
    RestfulResult latLng = await GServiceRestaurant.getLatLng();
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await inputDataForHtml(dataType: 'init', data: latLng.data);
    });
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

  Future<void> registerNaverMap() async {
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

  @override
  void dispose() {
    super.dispose();
  }
}
