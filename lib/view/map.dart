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
  bool isYoutube = true;

  final TextEditingController ctrlSido = TextEditingController();
  final TextEditingController ctrlSigungu = TextEditingController();
  final ScrollController ctrlMainScroll = ScrollController();
  final ScrollController ctrlListScroll = ScrollController();
  final TStream<List<MRestaurant>> $listOfRestaurant =
      TStream<List<MRestaurant>>();
  int dataCount = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    /// TODO : stack
    ///          ㄴ ListView
    ///          ㄴ progress(refresh 발생 시 보여줄 progress/pointIgnore)

    return TStreamBuilder(
      initialData: const <MRestaurant>[],
      stream: $listOfRestaurant.browse$,
      builder: (context, List<MRestaurant> listOfRestaurant) {
        if (listOfRestaurant.isEmpty) {
          // initMarker(listOfRestaurant);
          return ViewDataLoading();
        }
        initMarker(listOfRestaurant);

        return isPort
            ? buildPortaitView(listOfRestaurant)
            : buildLandscapeView(listOfRestaurant);
      },
    );
  }

  Widget buildPortaitView(List<MRestaurant> listOfRestaurant) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: CustomScrollView(
        controller: ctrlMainScroll,
        slivers: [
          SliverAppBar(
            backgroundColor: COLOR.WHITE.withOpacity(0),
            flexibleSpace: Container(
              child: isYoutube
                  ? Image.asset(
                      IMAGE.YOUTUBE_LOGO,
                    )
                  : Image.asset(
                      IMAGE.JASHIM_LOGO,
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                    ),
            ),
            expandedHeight:
                isYoutube ? kToolbarHeight * 2 : kToolbarHeight * 2.5,
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: height * 1.4,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildSelectFields(),
                    ),
                  ).sizedBox(height: kToolbarHeight),
                  /*
                  Map 
                  */

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: HtmlElementView(viewType: 'naver-map'),
                    ),
                  ).sizedBox(height: height * 0.5),

                  /*
                  List 
                  */
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      color: Colors.grey[100],
                      child: buildListView(listOfRestaurant),
                    ),
                  ).expand(),

                  /*
                  Footer 
                  */
                  buildFooter().sizedBox(height: kToolbarHeight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLandscapeView(List<MRestaurant> listOfRestaurant) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: SizedBox(
        height: height,
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  /*
                  map
                  */
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: height,
                      width: width - SIZE.LANDSCAPE_WIDTH_PIXED,
                      color: Colors.amber[100],
                      child: const HtmlElementView(viewType: 'naver-map'),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Material(
                      elevation: 30,
                      child: SizedBox(
                        height: height - kToolbarHeight,
                        width: SIZE.LANDSCAPE_WIDTH_PIXED,
                        child: Column(
                          children: [
                            Container(
                              child: isYoutube
                                  ? Image.asset(
                                      IMAGE.YOUTUBE_LOGO,
                                    )
                                  : Image.asset(
                                      IMAGE.JASHIM_LOGO,
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                    ),
                            ).sizedBox(height: kToolbarHeight * 3),
                            const Padding(padding: EdgeInsets.all(8)),
                            Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: buildSelectFields())
                                .sizedBox(height: kToolbarHeight),
                            const Divider(),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: buildListView(listOfRestaurant),
                              ),
                            ).expand(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ).sizedBox(height: height - kToolbarHeight),
              buildFooter().sizedBox(height: kToolbarHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFooter() {
    List<Map<String, dynamic>> dataList = [
      {
        'url': "https://cafe.naver.com/jangsin1004",
        'children': [
          Center(child: Image.asset(ICON.CAFE)),
          const Center(child: Padding(padding: EdgeInsets.all(2))),
          const Center(child: Text('자영업자의 쉼터 카페')),
        ],
      },
      {
        'url': "https://www.youtube.com/@jangsin",
        'children': [
          Center(child: Image.asset(ICON.YOUTUBE)),
          const Center(child: Padding(padding: EdgeInsets.all(2))),
          const Center(child: Text('장사의 신 유튜브')),
        ],
      },
    ];
    return FooterBar(
      context: context,
      barColor: Colors.blue[200],
      mapOfData: dataList,
    );
  }

  Widget buildListView(List<MRestaurant> listOfRestaurant) {
    return AppendScrollListView(
      isLoading: isLoading,
      controller: ctrlListScroll,
      itemCount: listOfRestaurant.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 100,
          child: Row(
            children: [
              Center(
                  child: Text(
                '${index + 1}',
                style: const TextStyle(color: COLOR.GREY),
              )).sizedBox(width: 25),
              TileRestaurantUnit(
                restaurant: listOfRestaurant[index],
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
                      .sink$(listOfRestaurant[index]);

                  inputDataForHtml(
                    dataType: 'set',
                    data: {
                      'label': listOfRestaurant[index].label,
                      'lat': listOfRestaurant[index].lat,
                      'lng': listOfRestaurant[index].lng
                    },
                  );
                },
              ).expand(),
            ],
          ),
        );
      },
      onRefreshStart: () async {
        // 스크롤을 비활성화 시키기 위해
        isLoading = true;
        RestfulResult result = GServiceRestaurant.$pagination.lastValue;
        /*

         현재 페이지가 마지막 페이지가 아닌 경우 페이지를 추가

        */
        if (result.data['total_page'] != result.data['current_page']) {
          RestfulResult getDataResult = await GServiceRestaurant.pagination(
            sido: ctrlSido.text == DISTRICT.ALL ? null : ctrlSido.text,
            sigungu: ctrlSigungu.text == DISTRICT.ALL ? null : ctrlSigungu.text,
            page: result.data['current_page'] + 1,
            isYoutube: isYoutube,
          );

          if (getDataResult.statusCode != 200) {
            $listOfRestaurant.sink$(listOfRestaurant);
            return;
          }

          debugPrint(
              'getDataResult.data[current_page] ${getDataResult.data['current_page']}');

          /*

          스크롤을 여러번 내려서 데이터가 중복되는 경우를 exception 처리

        */
          if (listOfRestaurant.length <
              getDataResult.data['current_page'] *
                  getDataResult.data['limit']) {
            listOfRestaurant.addAll(getDataResult.data['pagination_data']);
          }
        }
      },
      onRefreshEnd: () async {
        // 스크롤을 비활성화 시키기 위해 지연시간 추가
        await Future.delayed(const Duration(milliseconds: 500), () async {
          isLoading = false;
          $listOfRestaurant.sink$(listOfRestaurant);
        });
        // $restaurants.sink$(listOfRestaurant);
      },
    );
  }

  Widget buildSelectFields() {
    return Row(
      children: [
        buildRegionSelectField(
          controller: ctrlSido,
          selectRegion: LABEL.SELECT_REGION_SIDO,
          selectedRegionFunction: selectRegionSidoDialog,
        ).expand(),
        const Padding(padding: EdgeInsets.all(4)),
        if (ctrlSido.text != DISTRICT.ALL)
          buildRegionSelectField(
            controller: ctrlSigungu,
            selectRegion: LABEL.SELECT_REGION_SIGUNGU,
            selectedRegionFunction: selectRegionSigunguDialog,
          ).expand(),
      ],
    );
  }

  Widget buildFloatingActionButton() {
    return PointerInterceptor(
      child: FloatingActionButton(
        child: isYoutube ? Image.asset(ICON.YOUTUBE) : Image.asset(ICON.CAFE),
        onPressed: () async {
          // youtube를 선택하면 검색값 초기화
          ctrlSido.text = DISTRICT.ALL;
          ctrlSigungu.text = DISTRICT.ALL;

          isYoutube = !isYoutube;
          RestfulResult result =
              await GServiceRestaurant.pagination(isYoutube: isYoutube);
          $listOfRestaurant.sink$(result.data['pagination_data']);
          dataCount = result.data['dataCount'];
          if (isPort) {
            ctrlMainScroll.jumpTo(0);
          }
          ctrlListScroll.jumpTo(0);
        },
      ),
    );
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///

  Widget buildRegionSelectField({
    required String selectRegion,
    required TextEditingController controller,
    required Function() selectedRegionFunction,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VerticalDivider(),
            Icon(Icons.search),
            Padding(padding: EdgeInsets.all(4)),
          ],
        ),
        suffixIconColor: COLOR.GREY,
        border: const OutlineInputBorder(),
        labelText: selectRegion,
        labelStyle: const TextStyle(color: COLOR.GREY),
        fillColor: COLOR.GREY,
        focusColor: COLOR.GREY,
        hoverColor: COLOR.GREY,
      ),
      readOnly: true,
      autocorrect: false,
      onTap: selectedRegionFunction,
    );
  }

  @override
  void initState() {
    registerNaverMap();
    initData();
    super.initState();
  }

  Future<void> initData() async {
    ctrlSido.text = LABEL.ALL;
    RestfulResult initPaginationData = await GServiceRestaurant.pagination(
      isYoutube: isYoutube,
    );
    await registerNaverMap();
    List<MRestaurant> result = initPaginationData.data['pagination_data'];
    await GUtility.wait(splashDuration);
    $listOfRestaurant.sink$(result);

    ///
    ///
    /// TODO : 현재 initState에서 initMarker를 호출하면
    /// markerCreate가 실행되지 않는 상황
    ///
    ///

    dataCount = initPaginationData.data['dataCount'];
  }

  Future<void> initMarker(List<MRestaurant> result) async {
    print('aaaaaaaaaaaaaaaaaaaaaa');
    List<Map<String, dynamic>> getData = result
        .map((MRestaurant rest) => {
              'label': rest.label,
              'lat': rest.lat,
              'lng': rest.lng,
            })
        .toList();

    await inputDataForHtml(dataType: 'init', data: getData);

    // await initMarkerInput(getData);
  }

  Future<void> initMarkerInput(List<Map<String, dynamic>> data) async {}

  Future<void> inputDataForHtml(
      {required String dataType, required dynamic data}) async {
    assert(dataType == 'init' || dataType == 'set',
        'inputDataForHtml exception : dataType is not init or set');
    Map<String, dynamic> mapOfData = {
      'type': dataType,
      'data': data,
    };

    String jsonData = jsonEncode(mapOfData);
    // String jsonData = jsonEncode(asd);
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

  Future<void> selectRegionSidoDialog() async {
    RestfulResult district =
        await GServiceRestaurant.getDistrict(isYoutube: isYoutube);
    List<String> getSidoList = district.data;
    getSidoList.insert(0, DISTRICT.ALL);
    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PointerInterceptor(
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: isPort
                  ? width * SIZE.PORTRAIT_DIALOG_WIDTH_RATIO
                  : SIZE.LANDSCAPE_DIALOG_WIDTH,
              height: isPort
                  ? height * SIZE.PORTRAIT_DIALOG_HEIGHT_RATIO
                  : height * SIZE.LANDSCAPE_DIALOG_HEIGHT_RATIO,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(LABEL.SELECT_REGION_SIDO),
                    const Divider(),
                    ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: getSidoList.length,
                      itemBuilder: (BuildContext context, int index) {
                        String sido = getSidoList[index];
                        return Row(
                          children: [
                            Center(child: Text('${index + 1}')).expand(),
                            ElevatedButton(
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

                                  RestfulResult result =
                                      await GServiceRestaurant.pagination(
                                          isYoutube: isYoutube);
                                  $listOfRestaurant
                                      .sink$(result.data['pagination_data']);
                                  return ctrlListScroll.jumpTo(0);
                                }

                                Navigator.pop(context);
                                RestfulResult result =
                                    await GServiceRestaurant.pagination(
                                        sido: sido, isYoutube: isYoutube);
                                $listOfRestaurant
                                    .sink$(result.data['pagination_data']);

                                ctrlSido.value = ctrlSido.value.copyWith(
                                  text: sido,
                                  selection: TextSelection.collapsed(
                                      offset: sido.length),
                                  composing: TextRange.empty,
                                );
                                ctrlSigungu.text = DISTRICT.ALL;
                                return ctrlListScroll.jumpTo(0);
                              },
                            ).expand(flex: 4),
                          ],
                        );
                      },
                    ).expand(),
                    buildExitButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> selectRegionSigunguDialog() async {
    await GServiceRestaurant.getDistrict(
        isYoutube: isYoutube, sido: ctrlSido.text);
    List<String> getSigunguList =
        GServiceRestaurant.$districtSigungu.lastValue.data;
    getSigunguList.insert(0, DISTRICT.ALL);
    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PointerInterceptor(
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: isPort
                  ? width * SIZE.PORTRAIT_DIALOG_WIDTH_RATIO
                  : SIZE.LANDSCAPE_DIALOG_WIDTH,
              height: isPort
                  ? height * SIZE.PORTRAIT_DIALOG_HEIGHT_RATIO
                  : height * SIZE.LANDSCAPE_DIALOG_HEIGHT_RATIO,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(LABEL.SELECT_REGION_SIGUNGU),
                    const Divider(),
                    ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: getSigunguList.length,
                      itemBuilder: (BuildContext context, int index) {
                        String sigungu = getSigunguList[index];
                        return Row(
                          children: [
                            Center(child: Text('${index + 1}')).expand(),
                            const VerticalDivider(),
                            ElevatedButton(
                              child: AutoSizeText(sigungu, maxLines: 1),
                              onPressed: () async {
                                if (sigungu == DISTRICT.ALL) {
                                  Navigator.pop(context);
                                  ctrlSigungu.value =
                                      ctrlSigungu.value.copyWith(
                                    text: sigungu,
                                    selection: TextSelection.collapsed(
                                        offset: sigungu.length),
                                    composing: TextRange.empty,
                                  );
                                  ctrlSigungu.text = DISTRICT.ALL;

                                  RestfulResult result =
                                      await GServiceRestaurant.pagination(
                                    sido: ctrlSido.text,
                                    sigungu: ctrlSigungu.text == DISTRICT.ALL
                                        ? null
                                        : ctrlSigungu.text,
                                    isYoutube: isYoutube,
                                  );
                                  $listOfRestaurant
                                      .sink$(result.data['pagination_data']);
                                  return ctrlListScroll.jumpTo(0);
                                }
                                Navigator.pop(context);

                                ctrlSigungu.value = ctrlSigungu.value.copyWith(
                                  text: sigungu,
                                  selection: TextSelection.collapsed(
                                      offset: sigungu.length),
                                  composing: TextRange.empty,
                                );

                                RestfulResult result =
                                    await GServiceRestaurant.pagination(
                                  sido: ctrlSido.text,
                                  sigungu: ctrlSigungu.text,
                                  isYoutube: isYoutube,
                                );

                                $listOfRestaurant
                                    .sink$(result.data['pagination_data']);

                                return ctrlListScroll.jumpTo(0);
                                // GServiceRestaurant.pagination(
                                //   sido: ctrlSido.text,
                                //   sigungu: ctrlSigungu.text,
                                //   isYoutube: isYoutube,
                                // );
                              },
                            ).expand(flex: 4),
                          ],
                        );
                      },
                    ).expand(),
                    buildExitButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
