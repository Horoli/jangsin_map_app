part of '../jangsin_map.dart';

class ViewAdmin extends StatefulWidget {
  const ViewAdmin({super.key});

  @override
  State<ViewAdmin> createState() => ViewAdminState();
}

class ViewAdminState extends State<ViewAdmin> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  final Map<String, TextEditingController> mapOfCtrl = {
    KEY.ADMIN_SIDO: TextEditingController(),
    KEY.ADMIN_SIGUNGU: TextEditingController(),
  };

  final Map<String, TextEditingController> mapOfInputCtrl = {
    KEY.ADMIN_EUPMYEONDONG: TextEditingController(),
    KEY.ADMIN_DETAIL: TextEditingController(),
    KEY.ADMIN_STREET: TextEditingController(),
    KEY.ADMIN_LABEL: TextEditingController(),
    KEY.ADMIN_CONTACT: TextEditingController(),
    KEY.ADMIN_MENU: TextEditingController(),
    KEY.ADMIN_LAT: TextEditingController(),
    KEY.ADMIN_LNG: TextEditingController(),
    KEY.ADMIN_CLOSED_DAYS: TextEditingController(),
    KEY.ADMIN_OPERATION_TIME: TextEditingController(),
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
                    buildSidoDropDownButton().expand(),
                    const VerticalDivider(),
                    buildSigunguDropDownButton().expand(),
                  ],
                ).expand(),
                for (int i = 0; i < mapOfInputCtrl.length; i++)
                  buildAdminTextField(mapOfInputCtrl.keys.toList()[i]).expand(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSidoDropDownButton() {
    return DropdownButton(
      value: mapOfCtrl[KEY.ADMIN_SIDO]!.text,
      items: DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT.keys
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (dynamic value) {
        setState(() {
          mapOfCtrl[KEY.ADMIN_SIDO]!.text = value;
          mapOfCtrl[KEY.ADMIN_SIGUNGU]!.text =
              DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT[
                  mapOfCtrl[KEY.ADMIN_SIDO]!.text]![0];
        });
      },
    );
  }

  Widget buildSigunguDropDownButton() {
    return DropdownButton(
      value: mapOfCtrl[KEY.ADMIN_SIGUNGU]!.text,
      items: DISTRICT
          .KOREA_ADMINISTRAIVE_DISTRICT[mapOfCtrl[KEY.ADMIN_SIDO]!.text]!
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (dynamic value) {
        setState(() {
          mapOfCtrl[KEY.ADMIN_SIGUNGU]!.text = value;
        });
      },
    );
  }

  Widget buildAdminTextField(String key) {
    return TextField(
      controller: mapOfCtrl[key],
      decoration: InputDecoration(
        labelText: key,
        hintText: key,
      ),
    );
  }

  /// TODO : 입력 필드 추가
  /// sido : preset으로 관리
  /// sigungu : preset으로 관리
  /// eupmyeondong : 직접 입력
  /// detail : 직접 입력

  @override
  void initState() {
    initController();
    super.initState();
  }

  void initController() {
    mapOfCtrl[KEY.ADMIN_SIDO]!.text =
        DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT.keys.toList()[0];
    mapOfCtrl[KEY.ADMIN_SIGUNGU]!.text =
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
