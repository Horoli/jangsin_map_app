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
  final TStream<List<MRestaurant>> $restaurants = TStream<List<MRestaurant>>();
  int dataCount = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    /// TODO : stack
    ///          ㄴ ListView
    ///          ㄴ progress(refresh 발생 시 보여줄 progress/pointIgnore)

    return TStreamBuilder(
      initialData: const <MRestaurant>[],
      stream: $restaurants.browse$,
      builder: (context, List<MRestaurant> listOfRestaurant) {
        if (listOfRestaurant.isEmpty) {
          return ViewDataLoading();
        }
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
            backgroundColor: Colors.blue[100],
            flexibleSpace: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildSelectFields(),
              ),
            ),
            expandedHeight: kToolbarHeight * 1.5,
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: height * 1.2,
              child: Column(
                children: [
                  /*
                  Map 
                  */

                  // const Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: Card(),
                  // ).sizedBox(height: height * 0.5),
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
                  buildFooter().sizedBox(height: kToolbarHeight * 3)
                  // Container(color: Colors.blue[200])
                  //     .sizedBox(height: kToolbarHeight * 3),
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
      body: SingleChildScrollView(
        controller: ctrlMainScroll,
        child: SizedBox(
          height: height * 1.2,
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: height,
                        color: Colors.amber[100],
                      ),
                    ),
                  ],
                ).sizedBox(height: height),
                // Stack(
                //   children: [
                //     /*
                //      map
                //     */
                //     Positioned(
                //       top: 0,
                //       right: 0,
                //       child: Container(
                //           // color: Colors.amber[100],
                //           ),
                //     ),
                //     // const HtmlElementView(viewType: 'naver-map').expand(),
                //     /*
                //      list
                //     */
                //     Positioned(
                //       top: 0,
                //       left: 0,
                //       child: Material(
                //         elevation: 30,
                //         child: Container(
                //           // decoration: BoxDecoration(
                //           //   color: COLOR.WHITE,
                //           //   boxShadow: [
                //           //     BoxShadow(
                //           //       color: Colors.grey.withOpacity(0.1),
                //           //       blurRadius: 15,
                //           //       // spreadRadius: -20,
                //           //       offset: const Offset(3, 0),
                //           //     ),
                //           //   ],
                //           // ),
                //           padding: const EdgeInsets.all(8.0),
                //           child: Column(
                //             children: [
                //               Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Row(
                //                   children: [
                //                     Center(
                //                       child: InkWell(
                //                         child: Image.asset(IMAGE.MAIN_LOGO),
                //                         onTap: () {},
                //                       ),
                //                     ).expand(),
                //                     const Padding(padding: EdgeInsets.all(4)),
                //                     Container(
                //                       color: Colors.red[100],
                //                       child: const Center(
                //                         child: AutoSizeText('자쉼맵 - jashim map'),
                //                       ),
                //                     ).expand(flex: 2),
                //                   ],
                //                 ),
                //               ).sizedBox(height: kToolbarHeight * 3),
                //               //
                //               buildSelectFields()
                //                   .sizedBox(height: kToolbarHeight),
                //               //

                //               Card(
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: buildListView(listOfRestaurant),
                //                 ),
                //               ).sizedBox(height: height * 0.7),
                //             ],
                //           ),
                //         ),
                //       ).sizedBox(width: 600),
                //     ),
                //   ],
                // ).sizedBox(height: height),

                // Footer
                Container(
                  color: Colors.blue[100],
                  child: Stack(
                    children: [
                      buildFooter(),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: TextButton(
                          child: const Text(''),
                          onPressed: () {},
                          onLongPress: () {
                            Navigator.of(context)
                                .pushNamed(PATH.ROUTE_ADMIN_LOGIN);
                          },
                        ),
                      ),
                    ],
                  ),
                ).expand(),
              ],
            ),
          ),
        ),
      ),
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
            $restaurants.sink$(listOfRestaurant);
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
          $restaurants.sink$(listOfRestaurant);
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
          $restaurants.sink$(result.data['pagination_data']);
          dataCount = result.data['dataCount'];
          // if (isPort) {
          ctrlMainScroll.jumpTo(0);
          // }
          ctrlListScroll.jumpTo(0);
        },
      ),
    );
  }

  Future<void> initMap() async {
    ctrlSido.text = LABEL.ALL;
    await registerNaverMap();
    await GUtility.wait(splashDuration);
    RestfulResult initPaginationData = await GServiceRestaurant.pagination(
      isYoutube: isYoutube,
    );
    RestfulResult latLng = await GServiceRestaurant.getLatLng();

    await Future.delayed(const Duration(milliseconds: 200), () async {
      $restaurants.sink$(initPaginationData.data['pagination_data']);
      dataCount = initPaginationData.data['dataCount'];
      await inputDataForHtml(dataType: 'init', data: latLng.data);
    });
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

  Widget buildFooter() {
    return Container(
      color: Colors.blue[200],
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: COLOR.WHITE,
                    ),
                    child: Row(
                      children: [
                        Image.asset(ICON.CAFE),
                        const Padding(padding: EdgeInsets.all(2)),
                        const Text('자영업자의 쉼터 카페').expand(),
                      ],
                    ),
                    onPressed: () {
                      js.context.callMethod(
                          'open', ["https://cafe.naver.com/jangsin1004"]);
                    },
                  ).expand(),
                  TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: COLOR.WHITE,
                      ),
                      child: Row(
                        children: [
                          Image.asset(ICON.YOUTUBE),
                          const Padding(padding: EdgeInsets.all(2)),
                          const Text('장사의 신 유튜브').expand(),
                        ],
                      ),
                      onPressed: () {
                        js.context.callMethod(
                            'open', ["https://www.youtube.com/@jangsin"]);
                      }).expand()
                ],
              ),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('자쉼맵 Ver.0.1.beta'),
                  const Text('현재 자쉼맵은 개발 단계에 있습니다.'),
                  const Text('의견 및 제안은 메일로 보내주시기 바랍니다.'),
                  const Padding(padding: EdgeInsets.all(4)),
                  const Text(LABEL.FOOTER_COPYRIGHT),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(ICON.EMAIL),
                      const Padding(padding: EdgeInsets.all(4)),
                      const Text(LABEL.FOOTER_EMAIL),
                    ],
                  ),
                ],
              ).expand(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    initMap();
    super.initState();
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
            content: SizedBox(
              width: isPort
                  ? width * SIZE.PORTRAIT_DIALOG_WIDTH_RATIO
                  : SIZE.LANDSCAPE_DIALOG_WIDTH,
              height: isPort
                  ? height * SIZE.PORTRAIT_DIALOG_HEIGHT_RATIO
                  : height * SIZE.LANDSCAPE_DIALOG_HEIGHT_RATIO,
              child: ListView.separated(
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
                            $restaurants.sink$(result.data['pagination_data']);
                            return ctrlListScroll.jumpTo(0);
                          }

                          Navigator.pop(context);
                          RestfulResult result =
                              await GServiceRestaurant.pagination(
                                  sido: sido, isYoutube: isYoutube);
                          $restaurants.sink$(result.data['pagination_data']);

                          ctrlSido.value = ctrlSido.value.copyWith(
                            text: sido,
                            selection:
                                TextSelection.collapsed(offset: sido.length),
                            composing: TextRange.empty,
                          );
                          ctrlSigungu.text = DISTRICT.ALL;
                          return ctrlListScroll.jumpTo(0);
                        },
                      ).expand(flex: 4),
                    ],
                  );
                },
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
            content: SizedBox(
              width: isPort
                  ? width * SIZE.PORTRAIT_DIALOG_WIDTH_RATIO
                  : SIZE.LANDSCAPE_DIALOG_WIDTH,
              height: isPort
                  ? height * SIZE.PORTRAIT_DIALOG_HEIGHT_RATIO
                  : height * SIZE.LANDSCAPE_DIALOG_HEIGHT_RATIO,
              child: ListView.separated(
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
                            ctrlSigungu.value = ctrlSigungu.value.copyWith(
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
                            $restaurants.sink$(result.data['pagination_data']);
                            return ctrlListScroll.jumpTo(0);
                          }
                          Navigator.pop(context);

                          ctrlSigungu.value = ctrlSigungu.value.copyWith(
                            text: sigungu,
                            selection:
                                TextSelection.collapsed(offset: sigungu.length),
                            composing: TextRange.empty,
                          );

                          RestfulResult result =
                              await GServiceRestaurant.pagination(
                            sido: ctrlSido.text,
                            sigungu: ctrlSigungu.text,
                            isYoutube: isYoutube,
                          );
                          print(result.map);

                          $restaurants.sink$(result.data['pagination_data']);

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
              ),
            ),
          ),
        );
      },
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
