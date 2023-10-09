part of '../jangsin_map.dart';

class ViewAdmin extends StatefulWidget {
  const ViewAdmin({super.key});

  @override
  State<ViewAdmin> createState() => ViewAdminState();
}

class ViewAdminState extends State<ViewAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("admin"),
      ),
    );
  }

  /// TODO : 입력 필드 추가
  /// sido : preset으로 관리
  /// sigungu : 직접 입력
  /// eupmyeondong : 직접 입력
  /// detail : 직접 입력

  @override
  void initState() {
    String tokenFromLocalStorage =
        GSharedPreferences.getString(LOCAL_TOKEN_KEY)!;
    // GServiceAdmin.createMapData(
    //   token: tokenFromLocalStorage,
    //   label: 'aaaaa',
    //   contact: 'aasdasd',
    //   info: 'asdasdasx',
    //   lat: 37,
    //   lng: 126,
    // );
    super.initState();
  }
}
