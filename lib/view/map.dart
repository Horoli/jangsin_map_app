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
  final ScrollController ctrlScroll = ScrollController();
  final ScrollController ctrlRestaurantScroll = ScrollController();

  List<MRestaurant> restaurants = [];

  @override
  Widget build(BuildContext context) {
    /// TODO : stack
    ///          ㄴ ListView
    ///          ㄴ progress(refresh 발생 시 보여줄 progress/pointIgnore)
    return Scaffold(
      body: Column(
        children: [
          Container().expand(),
          InfinityScrollList(
            controller: ctrlScroll,
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 100,
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
              );
            },
            onRefresh: () async {
              RestfulResult result = GServiceRestaurant.$pagination.lastValue;
              print(result.data);
              if (result.data['total_page'] != result.data['current_page']) {
                RestfulResult getNewData = await GServiceRestaurant.pagination(
                    page: result.data['current_page'] + 1, isYoutube: true);

                setState(() {
                  restaurants.addAll(getNewData.data['pagination_data']);
                });
              }
            },
          ).expand(),
        ],
      ),
    );
    // return TStreamBuilder(
    //   initialData: RestfulResult(statusCode: 400, message: '', data: null),
    //   stream: GServiceRestaurant.$pagination.browse$,
    //   builder: (BuildContext context, RestfulResult snapshot) {
    //     ('snapshot.statusCode ${snapshot.statusCode}');
    //     if (snapshot.statusCode == 403) {
    //       return ViewServerDisconnect();
    //     }
    //     if (snapshot.statusCode != 200) {
    //       return ViewDataLoading();
    //     }

    //     return isPort ? buildPortait(snapshot) : buildLandscape(snapshot);
    //   },
    // );
  }

  // TODO : 세로모드(mobile) 인 경우, appBar 미출력
  Widget buildPortait(RestfulResult snapshot) {
    List<MRestaurant> restaurants = snapshot.data['pagination_data'];
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: SingleChildScrollView(
          controller: ctrlScroll,
          child: SizedBox(
            height: height,
            // height: height * SIZE.PORTRAIT_HEIGHT_BODY_RATIO,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const HtmlElementView(viewType: 'naver-map'),
                      buildSelectFields().sizedBox(height: kToolbarHeight),
                    ],
                  ).sizedBox(height: height / 2),
                  // InfinityScrollList(restaurants: restaurants).expand(),

                  // buildInfinityScollListView(restaurants).expand(),
                  // .sizedBox(height: (100 * restaurants.length).toDouble()),

                  PaginationButton(
                    currentPage: snapshot.data['current_page'],
                    totalPage: snapshot.data['total_page'],
                    onPressed: (int page) {
                      ctrlRestaurantScroll.jumpTo(0);
                      if (ctrlSido.text == LABEL.ALL) {
                        GServiceRestaurant.pagination(
                            page: page, isYoutube: isYoutube);

                        return;
                      }
                      // 쿼리에 null 값이 들어가게 설정
                      GServiceRestaurant.pagination(
                        page: page,
                        sido: ctrlSido.text,
                        sigungu:
                            ctrlSigungu.text == "" ? null : ctrlSigungu.text,
                        isYoutube: isYoutube,
                      );

                      // ctrlMapScroll.jumpTo(0);
                    },
                  ),
                  // Container(color: Colors.red[200]).expand(),
                  // Container(color: Colors.red[300]).expand(),
                  // Container(color: Colors.red[400]).expand(),
                  // Container(color: Colors.red[500]).expand(),
                ],
              ),
            ),
          )
          // child: SizedBox(
          //   height: height * SIZE.PORTRAIT_HEIGHT_BODY_RATIO,
          //   child: Column(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(12.0),
          //         child: Column(
          //           children: [
          //             buildSelectFields().sizedBox(height: kToolbarHeight),
          //             const HtmlElementView(viewType: 'naver-map').expand(),
          //             const Divider(),
          //             buildMapList(snapshot).expand(flex: 2),
          //           ],
          //         ),
          //       ).expand(),
          //       const Divider(),
          //       buildFooter().sizedBox(
          //           height: kToolbarHeight * SIZE.PORTRAIT_HEIGHT_FOOTER)
          //     ],
          //   ),
          // ),
          ),
    );
  }

  // Widget buildInfinityScollListView(List<MRestaurant> restaurants) {
  //   return ListView.separated(
  //     controller: ctrlRestaurantScroll,
  //     // separatorBuilder: (context, index) => const Divider(),
  //     separatorBuilder: (context, index) => Container(),
  //     itemCount: restaurants.length,
  //     itemBuilder: (context, index) {
  //       return SizedBox(
  //         height: 100,
  //         width: double.infinity,
  //         child: Row(
  //           children: [
  //             Center(child: Text('${index + 1}')).sizedBox(width: 25),
  //             const Padding(padding: EdgeInsets.all(4)),
  //             TileRestaurantUnit(
  //               restaurant: restaurants[index],
  //               $selectedRestaurant: GServiceRestaurant.$selectedRestaurant,
  //               onPressed: () {
  //                 // 선택한 식당이 같은 경우 빈 식당 sink$
  //                 // if (GServiceRestaurant.$selectedRestaurant.lastValue.id ==
  //                 //     restaurants[index].id) {
  //                 //   GServiceRestaurant.$selectedRestaurant
  //                 //       .sink$(MRestaurant());
  //                 //   return;
  //                 // }

  //                 // 선택한 식당이 다른 경우 해당 식당을 sink$
  //                 GServiceRestaurant.$selectedRestaurant
  //                     .sink$(restaurants[index]);

  //                 inputDataForHtml(
  //                   dataType: 'set',
  //                   data: {
  //                     'lat': restaurants[index].lat,
  //                     'lng': restaurants[index].lng
  //                   },
  //                 );
  //               },
  //             ).expand(),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget buildLandscape(RestfulResult snapshot) {
    return Row(
      children: [
        buildMapList(snapshot).sizedBox(width: 600),
        // Container(color: Colors.blue[100], width: 300),

        const HtmlElementView(viewType: 'naver-map').expand(),
        // Container(color: Colors.red[100]).expand(),
      ],
    );
  }

  // TODO : 가로모드인 경우, appBar 출력
  Widget buildLandscapeaaa(RestfulResult snapshot) {
    print('height $height');
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: CustomScrollView(
        controller: ctrlScroll,
        slivers: [
          SliverAppBar(
            flexibleSpace: Center(
              child: Text('aaaa'),
            ),
            expandedHeight: 200,
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              // height: height,
              height: height * SIZE.LANDSCAPE_HEIGHT_BODY_RATIO,
              child: Column(
                children: [
                  /*

                      header

                      */
                  Stack(
                    children: [
                      Container(
                        color: Colors.blue[200],
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Center(
                        child: Container(
                          width: SIZE.LANDSCAPE_WIDTH_PIXED,
                          height: double.infinity,
                          color: Colors.blue[300],
                          child: Center(child: Text('header')),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        height: kToolbarHeight,
                        child: TextButton(
                          child: const Text(''),
                          onPressed: () {},
                          onLongPress: () {
                            Navigator.of(context)
                                .pushNamed(PATH.ROUTE_ADMIN_LOGIN);
                          },
                        ),
                      )
                    ],
                  ).sizedBox(height: kToolbarHeight * 3),

                  /*

                      body

                      */
                  Container(
                    width: SIZE.LANDSCAPE_WIDTH_PIXED,
                    height: double.infinity,
                    color: Colors.blue[300],
                    child: Center(
                      child: SizedBox(
                        height: height * SIZE.LANDSCAPE_HEIGHT_BODY_RATIO,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              buildSelectFields()
                                  .sizedBox(height: kToolbarHeight),
                              const Divider(),
                              Row(
                                children: [
                                  buildMapList(snapshot).expand(),
                                  const VerticalDivider(),
                                  const HtmlElementView(viewType: 'naver-map')
                                      .expand(),
                                ],
                              ).expand(),
                            ],
                          ),
                        ).expand(),
                      ),
                    ),
                  ).expand(),

                  /*

                     footer

                      */
                  Stack(
                    children: [
                      Container(
                        color: Colors.blue[200],
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Center(
                        child: Container(
                          width: SIZE.LANDSCAPE_WIDTH_PIXED,
                          height: double.infinity,
                          color: Colors.blue[300],
                          child: buildFooter(),
                        ),
                      ),
                    ],
                  ).sizedBox(height: kToolbarHeight * 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return PointerInterceptor(
      child: FloatingActionButton(
        child: isYoutube ? Image.asset(ICON.YOUTUBE) : Image.asset(ICON.CAFE),
        onPressed: () {
          ctrlScroll.jumpTo(0);
          // youtube를 선택하면 검색값 초기화
          isYoutube = !isYoutube;
          GServiceRestaurant.pagination(isYoutube: isYoutube);
          ctrlSido.text = DISTRICT.ALL;
          ctrlSigungu.text = DISTRICT.ALL;
        },
      ),
    );
  }

  Widget buildSelectFields() {
    return PointerInterceptor(
      child: Row(
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
          const Padding(padding: EdgeInsets.all(4)),
        ],
      ),
    );
  }

  Widget buildMapList(RestfulResult snapshot) {
    List<MRestaurant> restaurants = snapshot.data['pagination_data'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
              controller: ctrlRestaurantScroll,
              separatorBuilder: (context, index) => const Divider(),
              itemCount: restaurants.length,
              itemBuilder: (context, index) => SizedBox(
                height: 100,
                width: double.infinity,
                child: Row(
                  children: [
                    Center(child: Text('${index + 1}')).sizedBox(width: 25),
                    const Padding(padding: EdgeInsets.all(4)),
                    TileRestaurantUnit(
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
                    ).expand(),
                  ],
                ),
              ),
            ).expand(),
            const Divider(),
            PaginationButton(
              currentPage: snapshot.data['current_page'],
              totalPage: snapshot.data['total_page'],
              onPressed: (int page) {
                ctrlRestaurantScroll.jumpTo(0);
                if (ctrlSido.text == LABEL.ALL) {
                  GServiceRestaurant.pagination(
                      page: page, isYoutube: isYoutube);

                  return;
                }
                // 쿼리에 null 값이 들어가게 설정
                GServiceRestaurant.pagination(
                  page: page,
                  sido: ctrlSido.text,
                  sigungu: ctrlSigungu.text == "" ? null : ctrlSigungu.text,
                  isYoutube: isYoutube,
                );

                // ctrlMapScroll.jumpTo(0);
              },
            ),
          ],
        ),
      ),
    );
  }

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
        suffixIconColor: COLOR.WHITE,
        border: const OutlineInputBorder(),
        labelText: selectRegion,
      ),
      readOnly: true,
      autocorrect: false,
      onTap: selectedRegionFunction,
    );
  }

  Widget buildFooter() {
    return SizedBox(
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
                  // ElevatedButton(
                  //     onPressed: () {
                  //       // ctrlScoll.jumpTo(0);
                  //     },
                  //     child: Text(''))
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
                            GServiceRestaurant.pagination(
                                page: 1, isYoutube: isYoutube);
                            ctrlSigungu.text = DISTRICT.ALL;
                            return;
                          }

                          Navigator.pop(context);
                          GServiceRestaurant.pagination(
                              sido: sido, isYoutube: isYoutube);

                          ctrlSido.value = ctrlSido.value.copyWith(
                            text: sido,
                            selection:
                                TextSelection.collapsed(offset: sido.length),
                            composing: TextRange.empty,
                          );
                          ctrlSigungu.text = DISTRICT.ALL;
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
                            GServiceRestaurant.pagination(
                              sido: ctrlSido.text,
                              isYoutube: isYoutube,
                            );
                            ctrlSigungu.text = DISTRICT.ALL;
                            return;
                          }
                          Navigator.pop(context);

                          ctrlSigungu.value = ctrlSigungu.value.copyWith(
                            text: sigungu,
                            selection:
                                TextSelection.collapsed(offset: sigungu.length),
                            composing: TextRange.empty,
                          );

                          GServiceRestaurant.pagination(
                            sido: ctrlSido.text,
                            sigungu: ctrlSigungu.text,
                            isYoutube: isYoutube,
                          );
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

  Future<void> initMap() async {
    ctrlSido.text = LABEL.ALL;
    await registerNaverMap();
    await GUtility.wait(splashDuration);
    RestfulResult initPaginationData = await GServiceRestaurant.pagination(
      isYoutube: isYoutube,
    );
    setState(() {
      restaurants.addAll(initPaginationData.data['pagination_data']);
    });

    RestfulResult latLng = await GServiceRestaurant.getLatLng();
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await inputDataForHtml(dataType: 'init', data: latLng.data);
    });
  }

  // void onScroll() {
  //   final double maxScroll = ctrlRestaurantScroll.position.maxScrollExtent;
  //   final double currentScroll = ctrlRestaurantScroll.position.pixels;
  //   if (maxScroll - currentScroll <= 10) {
  //     print('onScroll max : ${maxScroll}, current : ${currentScroll}');
  //     GServiceRestaurant.pagination(isYoutube: isYoutube);
  //   }
  // }

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
