part of '../../jangsin_map.dart';

class ViewAdmin extends StatefulWidget {
  const ViewAdmin({super.key});

  @override
  State<ViewAdmin> createState() => ViewAdminState();
}

class ViewAdminState extends State<ViewAdmin> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  final Map<String, Map<String, TextEditingController>> mapOfMainCtrl = {
    KEY.ADMIN_MAP_OF_CTRL_DROPDOWN: {
      KEY.ADMIN_SIDO: TextEditingController(),
      KEY.ADMIN_SIGUNGU: TextEditingController(),
    },
    KEY.ADMIN_MAP_OF_CTRL_ADDRESS: {
      KEY.ADMIN_EUPMYEONDONG: TextEditingController(),
      KEY.ADMIN_DETAIL: TextEditingController(),
      KEY.ADMIN_STREET: TextEditingController(),
      KEY.ADMIN_LAT: TextEditingController(),
      KEY.ADMIN_LNG: TextEditingController(),
    },
    KEY.ADMIN_MAP_OF_CTRL_RESTAURANT: {
      KEY.ADMIN_LABEL: TextEditingController(),
      KEY.ADMIN_CONTACT: TextEditingController(),
      KEY.ADMIN_REPRESENTATIVE_MENU: TextEditingController(),
      KEY.ADMIN_CLOSED_DAYS: TextEditingController(),
      KEY.ADMIN_OPERATION_TIME: TextEditingController(),
    },
    KEY.ADMIN_MAP_OF_CTRL_LINK: {
      KEY.ADMIN_SNS_LINK: TextEditingController(),
      KEY.ADMIN_NAVER_MAP_LINK: TextEditingController(),
      KEY.ADMIN_YOUTUBE_LINK: TextEditingController(),
      KEY.ADMIN_YOUTUBE_UPLOADED_AT: TextEditingController(),
      KEY.ADMIN_BAEMIN_LINK: TextEditingController(),
    },
  };

  Map<String, TextEditingController> get mapOfDropdown =>
      mapOfMainCtrl[KEY.ADMIN_MAP_OF_CTRL_DROPDOWN]!;
  Map<String, TextEditingController> get mapOfAddress =>
      mapOfMainCtrl[KEY.ADMIN_MAP_OF_CTRL_ADDRESS]!;
  Map<String, TextEditingController> get mapOfRestaurant =>
      mapOfMainCtrl[KEY.ADMIN_MAP_OF_CTRL_RESTAURANT]!;
  Map<String, TextEditingController> get mapOfLink =>
      mapOfMainCtrl[KEY.ADMIN_MAP_OF_CTRL_LINK]!;

  final TStream<List<String>> $selectedRestaurantThumbnail =
      TStream<List<String>>();

  late final String token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("admin"),
      ),
      body: TStreamBuilder(
        stream: GServiceRestaurant.$selectedRestaurant.browse$,
        builder: (context, MRestaurant restaurant) {
          // print('restaurant ${restaurant.map}');
          // print('restaurant ${restaurant.thumbnail}');
          if (restaurant.id != "" &&
              restaurant.thumbnail != "" &&
              restaurant.thumbnail.length == 32) {
            // 선택한 식당의 썸네일이 id인 경우(length == 32)
            getThumbnail(restaurant);
          }
          return Center(
            child: SizedBox(
              width: width * 0.8,
              height: height * 0.7,
              child: Column(
                children: [
                  Row(
                    children: [
                      buildRestaurantList(restaurant).expand(),
                      const VerticalDivider(),
                      ManagementRestaurantInfo(
                        context: context,
                        restaurant: restaurant,
                        mapOfCtrl: mapOfMainCtrl,
                      ).expand(flex: 3),
                      // TODO : dev code add thumnail image
                      Column(
                        children: [
                          ElevatedButton(
                              child: Text('a'),
                              onPressed: () async {
                                await selectImageFile().then((image) {
                                  addThumbnailImage(restaurant, image);
                                });
                              }).expand(),
                          // FutureBuilder(
                          //     future: getThumbnail(restaurant),
                          //     builder: (BuildContext context, snapshot) {
                          //       if (!snapshot.hasData) {
                          //         return const Text('empty');
                          //       }
                          //       return Image.memory(
                          //           base64Decode(snapshot.data!.first));
                          //     }).expand(),
                          TStreamBuilder(
                            stream: $selectedRestaurantThumbnail.browse$,
                            builder: (context, List<String> thumbnail) {
                              return thumbnail[0] == ""
                                  ? const Text('empty')
                                  : Image.memory(base64Decode(thumbnail[0]));
                            },
                          ).expand(),
                        ],
                      ).expand(),
                    ],
                  ).expand(),
                  buildUpdateButton(restaurant),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildUpdateButton(MRestaurant restaurant) {
    return restaurant.id == ''
        ? ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(COLOR.BLUE),
            ),
            child: const Text(LABEL.UPDATE_NEW),
            onPressed: () async {
              GServiceAdmin.createRestaurant(
                token: token,
                restaurant: restaurant,
              );
            },
          )
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(COLOR.RED),
            ),
            child: const Text(LABEL.UPDATE_MODIFY),
            onPressed: () {
              String token =
                  GSharedPreferences.getString(KEY.LOCAL_DB_TOKEN_KEY)!;

              GServiceAdmin.patchRestaurant(
                token: token,
                restaurant: restaurant,
              );
            },
          );
  }

  Widget buildRestaurantList(MRestaurant selectedRestaurant) {
    return TStreamBuilder(
      initialData: RestfulResult(statusCode: 400, message: '', data: null),
      stream: GServiceRestaurant.$pagination.browse$,
      builder: (BuildContext context, RestfulResult snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.statusCode != 200) {
          return const Center(child: CircularProgressIndicator());
        }

        List<MRestaurant> restaurants = snapshot.data['pagination_data'];

        List<int> pages =
            List.generate(snapshot.data['total_page'], (index) => index + 1);
        return Column(
          children: [
            ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: restaurants.length,
              itemBuilder: (context, index) => SizedBox(
                height: 25,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        restaurants[index].id == selectedRestaurant.id
                            ? MaterialStateProperty.all(COLOR.RED)
                            : MaterialStateProperty.all(COLOR.BLUE),
                  ),
                  child: Text(restaurants[index].label),
                  onPressed: () {
                    // TODO : 선택을 해제하면 입력된 값을 모두 초기화
                    if (selectedRestaurant.id == restaurants[index].id) {
                      initCtrl();
                      return;
                    }

                    inputCtrlSelectedRestaurant(restaurants[index]);
                  },
                ),
              ),
            ).expand(),
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
      },
    );
  }

  @override
  void initState() {
    token = GSharedPreferences.getString(KEY.LOCAL_DB_TOKEN_KEY)!;
    initCtrl();
    GServiceRestaurant.pagination();
    super.initState();
  }

  Future<void> initCtrl() async {
    GServiceRestaurant.$selectedRestaurant.sink$(MRestaurant());
    mapOfDropdown[KEY.ADMIN_SIDO]!.text =
        DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT.keys.toList()[0];
    mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text =
        DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT[DISTRICT.INIT]![0];

    // 컨트롤러를 초기화 하는 함수
    void initController(Map<String, TextEditingController> mapOfInnerCtrl) {
      for (String key in mapOfInnerCtrl.keys) {
        mapOfInnerCtrl[key]!.text = '';
      }
    }

    initController(mapOfAddress);
    initController(mapOfLink);
    initController(mapOfRestaurant);

    $selectedRestaurantThumbnail.sink$(['']);
  }

  void addThumbnailImage(MRestaurant restaurant, List<String> base64String) {
    $selectedRestaurantThumbnail.sink$(base64String);
    GServiceRestaurant.$selectedRestaurant
        .sink$(restaurant.copyWith(thumbnail: base64String[0]));
  }

  // TODO : 선택이 되면 입력 필드에 선택한 restaurant의 데이터를 입력
  void inputCtrlSelectedRestaurant(MRestaurant restaurant) {
    GServiceRestaurant.$selectedRestaurant.sink$(restaurant);
    mapOfDropdown[KEY.ADMIN_SIDO]!.text = restaurant.address_sido;
    mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text = restaurant.address_sigungu;
    mapOfAddress[KEY.ADMIN_EUPMYEONDONG]!.text =
        restaurant.address_eupmyeondong;
    mapOfAddress[KEY.ADMIN_LAT]!.text = restaurant.lat.toString();
    mapOfAddress[KEY.ADMIN_LNG]!.text = restaurant.lng.toString();
    $selectedRestaurantThumbnail.sink$([restaurant.thumbnail]);
  }

  Future<List<String>> getThumbnail(MRestaurant restaurant) async {
    RestfulResult getThumbnail = await GServiceAdmin.getThumbnailAdmin(
      token: token,
      thumbnailId: restaurant.thumbnail == "" ? "" : restaurant.thumbnail,
    );

    $selectedRestaurantThumbnail
        .sink$([getThumbnail.data['thumbnail']['image']]);

    return [getThumbnail.data['thumbnail']['image']];
  }

  @override
  void dispose() {
    GServiceRestaurant.$selectedRestaurant.sink$(MRestaurant());
    $selectedRestaurantThumbnail.dispose();
    // TODO : 모든 textController dispose
    super.dispose();
  }
}
