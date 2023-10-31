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

  final TextEditingController ctrlSido = TextEditingController();
  final TextEditingController ctrlSigungu = TextEditingController();
  final ScrollController ctrlScoll = ScrollController();
  final ScrollController ctrlMapScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return TStreamBuilder(
      initialData: RestfulResult(statusCode: 400, message: '', data: null),
      stream: GServiceRestaurant.$pagination.browse$,
      builder: (BuildContext context, RestfulResult snapshot) {
        ('snapshot.statusCode ${snapshot.statusCode}');
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
      body: SingleChildScrollView(
        controller: ctrlScoll,
        child: SizedBox(
          height: height * 1.3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
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
                          ).expand()
                      ],
                    ).sizedBox(height: kToolbarHeight),
                    const HtmlElementView(viewType: 'naver-map').expand(),
                    const Divider(),
                    buildMapList(snapshot).expand(flex: 2),
                  ],
                ),
              ).expand(),
              const Divider(),
              buildFooter().sizedBox(height: kToolbarHeight * 3)
            ],
          ),
        ),
      ),
    );
  }

  // TODO : 가로모드인 경우, appBar 출력
  Widget buildLandscape(RestfulResult snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LABEL.APP_TITLE),
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
      body: SingleChildScrollView(
        controller: ctrlScoll,
        child: SizedBox(
          height: height * 1.1,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: width > 1200 ? 120 : 15,
                  right: width > 1200 ? 120 : 15,
                  top: 25,
                ),
                child: Column(
                  children: [
                    Row(
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
                          ).expand()
                      ],
                    ).sizedBox(height: kToolbarHeight),
                    const Divider(),
                    Row(
                      children: [
                        buildMapList(snapshot).expand(),
                        const VerticalDivider(),
                        const HtmlElementView(viewType: 'naver-map').expand(),
                      ],
                    ).expand(),
                  ],
                ),
              ).expand(),
              const Divider(),
              buildFooter().sizedBox(height: kToolbarHeight * 2.5)
            ],
          ),
        ),
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
              controller: ctrlMapScroll,
              separatorBuilder: (context, index) => const Divider(),
              itemCount: restaurants.length,
              itemBuilder: (context, index) => SizedBox(
                height: 100,
                width: double.infinity,
                child: Row(
                  children: [
                    Text('${index + 1}'),
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
                ctrlMapScroll.jumpTo(0);
                if (ctrlSido.text == LABEL.ALL) {
                  GServiceRestaurant.pagination(page: page);

                  return;
                }
                // 쿼리에 null 값이 들어가게 설정
                GServiceRestaurant.pagination(
                  page: page,
                  sido: ctrlSido.text,
                  sigungu: ctrlSigungu.text == "" ? null : ctrlSigungu.text,
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
                  const Text('SiteMap'),
                  const VerticalDivider(),
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
    super.initState();
    initMap();
  }

  Future<void> selectRegionSidoDialog() async {
    RestfulResult district = await GServiceRestaurant.getDistrict();
    List<String> getSidoList = district.data;
    getSidoList.insert(0, DISTRICT.ALL);
    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PointerInterceptor(
          child: AlertDialog(
            content: SizedBox(
              width: isPort ? width * 0.4 : width * 0.4,
              height: isPort ? height * 0.7 : height * 0.4,
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: getSidoList.length,
                itemBuilder: (BuildContext context, int index) {
                  String sido = getSidoList[index];
                  return Row(
                    children: [
                      Text('${index + 1}'),
                      const VerticalDivider(),
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
                            GServiceRestaurant.pagination(page: 1);
                            ctrlSigungu.text = '';
                            return;
                          }

                          Navigator.pop(context);
                          GServiceRestaurant.pagination(sido: sido);

                          ctrlSido.value = ctrlSido.value.copyWith(
                            text: sido,
                            selection:
                                TextSelection.collapsed(offset: sido.length),
                            composing: TextRange.empty,
                          );
                          ctrlSigungu.text = '';
                        },
                      ).expand(),
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
    await GServiceRestaurant.getDistrict(sido: ctrlSido.text);
    List<String> getSigunguList =
        GServiceRestaurant.$districtSigungu.lastValue.data;
    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PointerInterceptor(
          child: AlertDialog(
            content: SizedBox(
              width: isPort ? width * 0.4 : width * 0.4,
              height: isPort ? height * 0.7 : height * 0.4,
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: getSigunguList.length,
                itemBuilder: (BuildContext context, int index) {
                  String sigungu = getSigunguList[index];
                  return Row(
                    children: [
                      Text('${index + 1}'),
                      const VerticalDivider(),
                      ElevatedButton(
                        child: AutoSizeText(sigungu, maxLines: 1),
                        onPressed: () async {
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
                          );
                        },
                      ).expand(),
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
