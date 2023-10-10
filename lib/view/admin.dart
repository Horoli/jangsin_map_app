part of '../jangsin_map.dart';

class ViewAdmin extends StatefulWidget {
  const ViewAdmin({super.key});

  @override
  State<ViewAdmin> createState() => ViewAdminState();
}

class ViewAdminState extends State<ViewAdmin> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  final Map<String, TextEditingController> mapOfCtl = {
    KEY.ADMIN_SIDO: TextEditingController(),
    KEY.ADMIN_SIGUNGU: TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("admin"),
      ),
      body: Center(
        child: SizedBox(
          width: width * 0.3,
          height: height * 0.4,
          child: Card(
            child: Row(
              children: [
                buildSidoDropDownButton().expand(),
                const VerticalDivider(),
                buildSigunguDropDownButton().expand(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSidoDropDownButton() {
    return DropdownButton(
      value: mapOfCtl[KEY.ADMIN_SIDO]!.text,
      items: DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT.keys
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (dynamic value) {
        setState(() {
          mapOfCtl[KEY.ADMIN_SIDO]!.text = value;
          mapOfCtl[KEY.ADMIN_SIGUNGU]!.text = DISTRICT
              .KOREA_ADMINISTRAIVE_DISTRICT[mapOfCtl[KEY.ADMIN_SIDO]!.text]![0];
        });
      },
    );
  }

  Widget buildSigunguDropDownButton() {
    return DropdownButton(
      value: mapOfCtl[KEY.ADMIN_SIGUNGU]!.text,
      items: DISTRICT
          .KOREA_ADMINISTRAIVE_DISTRICT[mapOfCtl[KEY.ADMIN_SIDO]!.text]!
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (dynamic value) {
        setState(() {
          mapOfCtl[KEY.ADMIN_SIGUNGU]!.text = value;
        });
      },
    );
  }

  /// TODO : 입력 필드 추가
  /// sido : preset으로 관리
  /// sigungu : preset으로 관리
  /// eupmyeondong : 직접 입력
  /// detail : 직접 입력

  @override
  void initState() {
    String tokenFromLocalStorage =
        GSharedPreferences.getString(KEY.LOCAL_DB_TOKEN_KEY)!;
    // GServiceAdmin.createMapData(
    //   token: tokenFromLocalStorage,
    //   label: 'aaaaa',
    //   contact: 'aasdasd',
    //   info: 'asdasdasx',
    //   lat: 37,
    //   lng: 126,
    // );
    init();
    super.initState();
  }

  void init() {
    mapOfCtl[KEY.ADMIN_SIDO]!.text =
        DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT.keys.toList()[0];
    mapOfCtl[KEY.ADMIN_SIGUNGU]!.text =
        DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT['서울특별시']![0];
  }
}
