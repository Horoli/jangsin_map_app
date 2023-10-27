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
    },
    KEY.ADMIN_MAP_OF_CTRL_RESTAURANT: {
      KEY.ADMIN_LABEL: TextEditingController(),
      KEY.ADMIN_SOURCE: TextEditingController(),
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

  final TStream<List<String>> $selectedNewThumbnail = TStream<List<String>>();
  final TStream<List<List<dynamic>>> $csv = TStream<List<List<dynamic>>>()
    ..sink$([]);
  final TextEditingController ctrlCSV = TextEditingController();

  late final String token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("admin"),
      ),
      body: TStreamBuilder(
        stream: GServiceRestaurant.$selectedRestaurant.browse$,
        builder: (context, MRestaurant selectedRestaurant) {
          return Center(
            child: SizedBox(
              width: width * 0.8,
              height: height * 0.7,
              child: Column(
                children: [
                  buildSelectAndUploadCsvField(),
                  Row(
                    children: [
                      buildRestaurantList(selectedRestaurant).expand(),
                      const VerticalDivider(),
                      ManagementInfo(
                        context: context,
                        restaurant: selectedRestaurant,
                        mapOfCtrl: mapOfMainCtrl,
                      ).expand(flex: 3),
                      ManagementImage(
                        context: context,
                        restaurant: selectedRestaurant,
                        token: token,
                        $selectedNewThumbnail: $selectedNewThumbnail,
                      ).expand(),
                    ],
                  ).expand(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildUpdateButton(selectedRestaurant),
                      if (selectedRestaurant.id != '')
                        ElevatedButton(
                          child: const Text(LABEL.UPDATE_DELETE),
                          onPressed: () async {
                            updateConfirmDialog(
                              LABEL.CONFIRM_DELETE,
                              acceptFunction: () async {
                                RestfulResult deleteResult =
                                    await GServiceAdmin.delete(
                                  token: token,
                                  id: selectedRestaurant.id,
                                );

                                if (deleteResult.statusCode == 403) {
                                  return tokenExpiredDialog(deleteResult);
                                }

                                Navigator.pop(context);

                                initCtrl();
                                GServiceRestaurant.$selectedRestaurant
                                    .sink$(selectedRestaurant);
                              },
                              cancelFunction: () => Navigator.pop(context),
                            );
                          },
                        )
                    ],
                  ).sizedBox(height: kToolbarHeight),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSelectAndUploadCsvField() {
    return TStreamBuilder(
      stream: $csv.browse$,
      builder: (BuildContext context, List<List<dynamic>> snapshot) {
        if (snapshot.isEmpty) {
          return buildSelectCsvButton();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSelectCsvButton(),
            const Padding(padding: EdgeInsets.all(3)),
            TextField(
              focusNode: FocusNode(canRequestFocus: false),
              maxLength: ctrlCSV.text.length,
              decoration: const InputDecoration(
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VerticalDivider(),
                    Icon(Icons.upload),
                    Padding(padding: EdgeInsets.all(4)),
                  ],
                ),
                suffixIconColor: COLOR.WHITE,
                border: OutlineInputBorder(),
                labelText: 'CSV 파일 업로드',
              ),
              controller: ctrlCSV,
              readOnly: true,
              onTap: () async {
                RestfulResult csvUploadResult =
                    await GServiceAdmin.csvUpload(token: token, csv: snapshot);
                if (csvUploadResult.statusCode == 403) {
                  return tokenExpiredDialog(csvUploadResult);
                }
                print('csvUpload ${csvUploadResult.map}');
                await uploadDialog(csvUploadResult);

                await GServiceRestaurant.pagination(page: 1);
                $csv.sink$([]);
              },
            ).expand(),
          ],
        );
      },
    );
  }

  Future<void> tokenExpiredDialog(RestfulResult result) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('토큰 시간이 만료되었습니다'),
          children: [
            ElevatedButton(
              child: Text('다시 로그인하기'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, PATH.ROUTE_ADMIN_LOGIN);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadDialog(RestfulResult result) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: result.statusCode == 200
                ? const Text('업로드 완료')
                : const Text('업로드할 데이터가 없습니다.'),
          );
        });
  }

  Widget buildSelectCsvButton() {
    return ElevatedButton(
      child: const Text('CSV 파일 업로드'),
      onPressed: () async {
        List<List<dynamic>> csv = await selectCsvFile();
        $csv.sink$(csv);
        ctrlCSV.text = 'csv 업로드 하시려면 우측 화살표 버튼을 누르세요';
      },
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
              // TODO : 정말 등록하시겠습니까 팝업 띄우고
              // 변경 완료된 경우 선택 해제 및 페이지네이션은 현재 페이지로 고정
              updateConfirmDialog(
                LABEL.CONFIRM_SAVE,
                acceptFunction: () async {
                  Map<String, dynamic> mapOfRestaurant =
                      setRestaurantInfo(restaurant).map;
                  mapOfRestaurant['add_thumbnail'] =
                      $selectedNewThumbnail.lastValue[0];

                  RestfulResult updateResult =
                      await GServiceAdmin.createRestaurant(
                          token: token, mapOfRestaurant: mapOfRestaurant);

                  if (updateResult.statusCode == 403) {
                    return tokenExpiredDialog(updateResult);
                  }

                  initCtrl();
                  GServiceRestaurant.$selectedRestaurant.sink$(restaurant);
                },
                cancelFunction: () => Navigator.pop(context),
              );
            },
          )
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(COLOR.RED),
            ),
            child: const Text(LABEL.UPDATE_MODIFY),
            onPressed: () async {
              // TODO : 정말 변경하시겠습니까 팝업 띄우고
              // 변경 완료된 경우 선택 해제 및 페이지네이션은 현재 페이지로 고정
              updateConfirmDialog(
                LABEL.CONFRIM_MODIFY,
                acceptFunction: () async {
                  Navigator.pop(context);

                  Map<String, dynamic> mapOfRestaurant =
                      setRestaurantInfo(restaurant).map;

                  mapOfRestaurant['add_thumbnail'] =
                      $selectedNewThumbnail.lastValue[0];
                  await GServiceAdmin.patchRestaurant(
                      token: token, mapOfRestaurant: mapOfRestaurant);
                  initCtrl();
                  await GServiceRestaurant.pagination();
                },
                cancelFunction: () => Navigator.pop(context),
              );
            },
          );
  }

  Future<void> updateConfirmDialog(
    String label, {
    required VoidCallback acceptFunction,
    required VoidCallback cancelFunction,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(label),
          children: [
            SimpleDialogOption(
              onPressed: acceptFunction,
              child: const Text(LABEL.YES),
            ),
            SimpleDialogOption(
              onPressed: cancelFunction,
              child: const Text(LABEL.NO),
            )
          ],
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
            PaginationButton(
              currentPage: snapshot.data['current_page'],
              totalPage: snapshot.data['total_page'],
              onPressed: (int page) {
                GServiceRestaurant.pagination(page: page);
                initCtrl();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    token = GSharedPreferences.getString(KEY.LOCAL_DB_TOKEN_KEY)!;
    GServiceRestaurant.pagination();
    initCtrl();
    super.initState();
  }

  Future<void> initCtrl() async {
    GServiceRestaurant.$selectedRestaurant.sink$(MRestaurant());
    mapOfDropdown[KEY.ADMIN_SIDO]!.text =
        DISTRICT.KOREA_ADMINISTRATIVE_DISTRICT.keys.toList()[0];
    mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text =
        DISTRICT.KOREA_ADMINISTRATIVE_DISTRICT[DISTRICT.CTRL_INIT]![0];

    // 컨트롤러를 초기화 하는 함수
    Future<void> initController(
        Map<String, TextEditingController> mapOfInnerCtrl) async {
      for (String key in mapOfInnerCtrl.keys) {
        mapOfInnerCtrl[key]!.text = '';
      }
    }

    await initController(mapOfAddress);
    await initController(mapOfLink);
    await initController(mapOfRestaurant);

    $selectedNewThumbnail.sink$(['']);
  }

  // TODO : 선택이 되면 입력 필드에 선택한 restaurant의 데이터를 입력
  Future<void> inputCtrlSelectedRestaurant(MRestaurant restaurant) async {
    GServiceRestaurant.$selectedRestaurant.sink$(restaurant);
    mapOfDropdown[KEY.ADMIN_SIDO]!.text = restaurant.address_sido;
    mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text = restaurant.address_sigungu;
    mapOfAddress[KEY.ADMIN_EUPMYEONDONG]!.text =
        restaurant.address_eupmyeondong;
    mapOfAddress[KEY.ADMIN_DETAIL]!.text = restaurant.address_detail.toString();
    mapOfRestaurant[KEY.ADMIN_LABEL]!.text = restaurant.label.toString();
    mapOfRestaurant[KEY.ADMIN_SOURCE]!.text = restaurant.source.toString();
    mapOfRestaurant[KEY.ADMIN_CONTACT]!.text = restaurant.contact.toString();
    mapOfRestaurant[KEY.ADMIN_REPRESENTATIVE_MENU]!.text =
        restaurant.representative_menu.toString();
    mapOfRestaurant[KEY.ADMIN_CLOSED_DAYS]!.text =
        restaurant.closed_days.toString();
    mapOfRestaurant[KEY.ADMIN_OPERATION_TIME]!.text =
        restaurant.operation_time.toString();
    mapOfLink[KEY.ADMIN_SNS_LINK]!.text = restaurant.sns_link.toString();
    mapOfLink[KEY.ADMIN_NAVER_MAP_LINK]!.text =
        restaurant.naver_map_link.toString();
    mapOfLink[KEY.ADMIN_YOUTUBE_LINK]!.text =
        restaurant.youtube_link.toString();
    mapOfLink[KEY.ADMIN_YOUTUBE_UPLOADED_AT]!.text =
        restaurant.youtube_uploadedAt.toString();
    mapOfLink[KEY.ADMIN_BAEMIN_LINK]!.text = restaurant.baemin_link.toString();
  }

  MRestaurant setRestaurantInfo(MRestaurant restaurant) {
    MRestaurant mRestaurant = MRestaurant(
      id: restaurant.id == '' ? '' : restaurant.id,
      address_sido: mapOfDropdown[KEY.ADMIN_SIDO]!.text,
      address_sigungu: mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text,
      address_eupmyeondong: mapOfAddress[KEY.ADMIN_EUPMYEONDONG]!.text,
      address_detail: mapOfAddress[KEY.ADMIN_DETAIL]!.text,
      label: mapOfRestaurant[KEY.ADMIN_LABEL]!.text,
      source: mapOfRestaurant[KEY.ADMIN_SOURCE]!.text,
      contact: mapOfRestaurant[KEY.ADMIN_CONTACT]!.text,
      representative_menu: mapOfRestaurant[KEY.ADMIN_REPRESENTATIVE_MENU]!.text,
      closed_days: mapOfRestaurant[KEY.ADMIN_CLOSED_DAYS]!.text,
      operation_time: mapOfRestaurant[KEY.ADMIN_OPERATION_TIME]!.text,
      sns_link: mapOfLink[KEY.ADMIN_SNS_LINK]!.text,
      naver_map_link: mapOfLink[KEY.ADMIN_NAVER_MAP_LINK]!.text,
      youtube_link: mapOfLink[KEY.ADMIN_YOUTUBE_LINK]!.text,
      youtube_uploadedAt: mapOfLink[KEY.ADMIN_YOUTUBE_UPLOADED_AT]!.text,
      baemin_link: mapOfLink[KEY.ADMIN_BAEMIN_LINK]!.text,
    );

    return mRestaurant;
  }

  @override
  void dispose() {
    GServiceRestaurant.$selectedRestaurant.sink$(MRestaurant());
    $selectedNewThumbnail.dispose();
    // TODO : 모든 textController dispose
    super.dispose();
  }
}
