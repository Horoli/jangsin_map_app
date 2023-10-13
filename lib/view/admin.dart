part of '../jangsin_map.dart';

class ViewAdmin extends StatefulWidget {
  const ViewAdmin({super.key});

  @override
  State<ViewAdmin> createState() => ViewAdminState();
}

class ViewAdminState extends State<ViewAdmin> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  final Map<String, Map<String, TextEditingController>> mapOfCtrl = {
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
      mapOfCtrl[KEY.ADMIN_MAP_OF_CTRL_DROPDOWN]!;
  Map<String, TextEditingController> get mapOfAddress =>
      mapOfCtrl[KEY.ADMIN_MAP_OF_CTRL_ADDRESS]!;
  Map<String, TextEditingController> get mapOfRestaurant =>
      mapOfCtrl[KEY.ADMIN_MAP_OF_CTRL_RESTAURANT]!;
  Map<String, TextEditingController> get mapOfLink =>
      mapOfCtrl[KEY.ADMIN_MAP_OF_CTRL_LINK]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("admin"),
      ),
      body: TStreamBuilder(
        stream: GServiceRestaurant.$selectedRestaurant.browse$,
        builder: (context, MRestaurant restaurant) {
          print('restaurant.id ${restaurant.id}');
          return Center(
            child: SizedBox(
              width: width * 0.8,
              height: height * 0.5,
              child: Column(
                children: [
                  Row(
                    children: [
                      buildRestaurantList(restaurant).expand(),
                      const VerticalDivider(),
                      buildManagementField().expand(),
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
            onPressed: () {
              // TODO : mapOfCtrl에 저장된 controller들을 MRestaurant에 저장
              MRestaurant mRestaurant = MRestaurant(
                address_sido: mapOfDropdown[KEY.ADMIN_SIDO]!.text,
                address_sigungu: mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text,
                address_eupmyeondong:
                    mapOfAddress[KEY.ADMIN_EUPMYEONDONG]!.text,
                address_detail: mapOfAddress[KEY.ADMIN_DETAIL]!.text,
                address_street: mapOfAddress[KEY.ADMIN_STREET]!.text,
                lat: double.parse(mapOfAddress[KEY.ADMIN_LAT]!.text),
                lng: double.parse(mapOfAddress[KEY.ADMIN_LNG]!.text),
                label: mapOfRestaurant[KEY.ADMIN_LABEL]!.text,
                contact: mapOfRestaurant[KEY.ADMIN_CONTACT]!.text,
                representative_menu:
                    mapOfRestaurant[KEY.ADMIN_REPRESENTATIVE_MENU]!.text,
                closed_days: mapOfRestaurant[KEY.ADMIN_CLOSED_DAYS]!.text,
                operation_time: mapOfRestaurant[KEY.ADMIN_OPERATION_TIME]!.text,
                sns_link: mapOfLink[KEY.ADMIN_SNS_LINK]!.text,
                naver_map_link: mapOfLink[KEY.ADMIN_NAVER_MAP_LINK]!.text,
                youtube_link: mapOfLink[KEY.ADMIN_YOUTUBE_LINK]!.text,
                youtube_uploadedAt:
                    mapOfLink[KEY.ADMIN_YOUTUBE_UPLOADED_AT]!.text,
                baemin_link: mapOfLink[KEY.ADMIN_BAEMIN_LINK]!.text,
              );

              print(mRestaurant);
              print(mRestaurant.map);
            },
          )
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(COLOR.RED),
            ),
            child: const Text(LABEL.UPDATE_MODIFY),
            onPressed: () {},
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

  Widget buildManagementField() {
    return Center(
      child: SizedBox(
        width: width * 0.7,
        height: height * 0.7,
        child: Card(
          child: Row(
            children: [
              Column(
                children: [
                  buildSidoDropdownButton().expand(),
                  buildSigunguDropdownButton().expand(),
                  for (int i = 0; i < mapOfAddress.keys.length; i++)
                    buildAdminTextField(
                      mapOfAddress.keys.toList()[i],
                      'address',
                    ).expand(),
                ],
              ).expand(),
              const VerticalDivider(),
              Column(
                children: [
                  for (int i = 0; i < mapOfRestaurant.keys.length; i++)
                    buildAdminTextField(
                      mapOfRestaurant.keys.toList()[i],
                      'restaurant',
                    ).expand(),
                ],
              ).expand(),
              const VerticalDivider(),
              Column(
                children: [
                  for (int i = 0; i < mapOfLink.keys.length; i++)
                    buildAdminTextField(
                      mapOfLink.keys.toList()[i],
                      'link',
                    ).expand(),
                ],
              ).expand(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSidoDropdownButton() {
    return DropdownButton(
      value: mapOfDropdown[KEY.ADMIN_SIDO]!.text,
      items: DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT.keys
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (dynamic value) {
        setState(() {
          mapOfDropdown[KEY.ADMIN_SIDO]!.text = value;
          mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text =
              DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT[
                  mapOfDropdown[KEY.ADMIN_SIDO]!.text]![0];
        });
      },
    );
  }

  Widget buildSigunguDropdownButton() {
    return DropdownButton(
      value: mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text,
      items: DISTRICT
          .KOREA_ADMINISTRAIVE_DISTRICT[mapOfDropdown[KEY.ADMIN_SIDO]!.text]!
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (dynamic value) {
        setState(() {
          mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text = value;
        });
      },
    );
  }

  Widget buildAdminTextField(String key, String flag) {
    late final TextEditingController ctrl;
    switch (flag) {
      case 'address':
        ctrl = mapOfAddress[key]!;
      case 'restaurant':
        ctrl = mapOfRestaurant[key]!;
      case 'link':
        ctrl = mapOfLink[key]!;
    }
    return Center(
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: key,
          hintText: key,
        ),
      ),
    );
  }

  @override
  void initState() {
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
    mapOfAddress[KEY.ADMIN_LAT]!.text = '';
    mapOfAddress[KEY.ADMIN_LNG]!.text = '';
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
  }

  @override
  void dispose() {
    GServiceRestaurant.$selectedRestaurant.sink$(MRestaurant());
    // TODO : 모든 textController dispose
    super.dispose();
  }
}
