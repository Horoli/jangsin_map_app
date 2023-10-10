part of widget;

class ManagementRestaurant extends StatefulWidget {
  MRestaurant? restaurant;
  ManagementRestaurant({
    this.restaurant,
    super.key,
  });

  @override
  State<ManagementRestaurant> createState() => ManagementRestaurantState();
}

class ManagementRestaurantState extends State<ManagementRestaurant> {
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
      KEY.ADMIN_YOUTUBE_UPDATED_AT: TextEditingController(),
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
                    buildAdminTextField(mapOfAddress.keys.toList()[i]).expand(),
                ],
              ).expand(),
              const VerticalDivider(),
              Column(
                children: [
                  for (int i = 0; i < mapOfRestaurant.keys.length; i++)
                    buildAdminTextField(mapOfRestaurant.keys.toList()[i])
                        .expand(),
                ],
              ).expand(),
              const VerticalDivider(),
              Column(
                children: [
                  for (int i = 0; i < mapOfLink.keys.length; i++)
                    buildAdminTextField(mapOfLink.keys.toList()[i]).expand(),
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

  Widget buildAdminTextField(String key) {
    return Center(
      child: TextField(
        controller: mapOfDropdown[key],
        decoration: InputDecoration(
          labelText: key,
          hintText: key,
        ),
      ),
    );
  }

  @override
  void initState() {
    initController();
    super.initState();
  }

  // TODO : dropdown controller는 초기값이 있어야 함으로 초기화 해줌
  void initController() {
    mapOfDropdown[KEY.ADMIN_SIDO]!.text =
        DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT.keys.toList()[0];
    mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text =
        DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT['서울특별시']![0];
  }
}
