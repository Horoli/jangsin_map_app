part of '../jangsin_map.dart';

class ViewAdmin extends StatefulWidget {
  const ViewAdmin({super.key});

  @override
  State<ViewAdmin> createState() => ViewAdminState();
}

class ViewAdminState extends State<ViewAdmin> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  final Map<String, TextEditingController> mapOfDropdownCtrl = {
    KEY.ADMIN_SIDO: TextEditingController(),
    KEY.ADMIN_SIGUNGU: TextEditingController(),
  };

  final Map<String, TextEditingController> mapOfAddressCtrl = {
    KEY.ADMIN_EUPMYEONDONG: TextEditingController(),
    KEY.ADMIN_DETAIL: TextEditingController(),
    KEY.ADMIN_STREET: TextEditingController(),
    KEY.ADMIN_LAT: TextEditingController(),
    KEY.ADMIN_LNG: TextEditingController(),
  };

  final Map<String, TextEditingController> mapOfRestaurantCtrl = {
    KEY.ADMIN_LABEL: TextEditingController(),
    KEY.ADMIN_CONTACT: TextEditingController(),
    KEY.ADMIN_REPRESENTATIVE_MENU: TextEditingController(),
    KEY.ADMIN_CLOSED_DAYS: TextEditingController(),
    KEY.ADMIN_OPERATION_TIME: TextEditingController(),
  };

  final Map<String, TextEditingController> mapOfLinkCtrl = {
    KEY.ADMIN_SNS_LINK: TextEditingController(),
    KEY.ADMIN_NAVER_MAP_LINK: TextEditingController(),
    KEY.ADMIN_YOUTUBE_LINK: TextEditingController(),
    KEY.ADMIN_YOUTUBE_UPDATED_AT: TextEditingController(),
    KEY.ADMIN_BAEMIN_LINK: TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("admin"),
      ),
      body: Center(
        child: SizedBox(
          width: width * 0.5,
          height: height * 0.7,
          child: Card(
            child: Column(
              children: [
                Row(
                  children: [
                    buildSidoDropdownButton().expand(),
                    const VerticalDivider(),
                    buildSigunguDropdownButton().expand(),
                  ],
                ).expand(),
                // for (int i = 0; i < mapOfInputCtrl.length; i++)
                //   buildAdminTextField(mapOfInputCtrl.keys.toList()[i]).expand(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSidoDropdownButton() {
    return DropdownButton(
      value: mapOfDropdownCtrl[KEY.ADMIN_SIDO]!.text,
      items: DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT.keys
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (dynamic value) {
        setState(() {
          mapOfDropdownCtrl[KEY.ADMIN_SIDO]!.text = value;
          mapOfDropdownCtrl[KEY.ADMIN_SIGUNGU]!.text =
              DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT[
                  mapOfDropdownCtrl[KEY.ADMIN_SIDO]!.text]![0];
        });
      },
    );
  }

  Widget buildSigunguDropdownButton() {
    return DropdownButton(
      value: mapOfDropdownCtrl[KEY.ADMIN_SIGUNGU]!.text,
      items: DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT[
              mapOfDropdownCtrl[KEY.ADMIN_SIDO]!.text]!
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (dynamic value) {
        setState(() {
          mapOfDropdownCtrl[KEY.ADMIN_SIGUNGU]!.text = value;
        });
      },
    );
  }

  Widget buildAdminTextField(String key) {
    return TextField(
      controller: mapOfDropdownCtrl[key],
      decoration: InputDecoration(
        labelText: key,
        hintText: key,
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
    mapOfDropdownCtrl[KEY.ADMIN_SIDO]!.text =
        DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT.keys.toList()[0];
    mapOfDropdownCtrl[KEY.ADMIN_SIGUNGU]!.text =
        DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT['서울특별시']![0];
  }

  // TODO : 각 필드에 입력한 데이터를 서버로 전송하는 함수
  void createMapData() {
    String tokenFromLocalStorage =
        GSharedPreferences.getString(KEY.LOCAL_DB_TOKEN_KEY)!;
    GServiceAdmin.createMapData(
      token: tokenFromLocalStorage,
      label: 'aaaaa',
      contact: 'aasdasd',
      info: 'asdasdasx',
      lat: 37,
      lng: 126,
    );
  }
}
