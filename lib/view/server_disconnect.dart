part of "../jangsin_map.dart";

class ViewServerDisconnect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red[100],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText('서버와의 연결이 끊어졌습니다.'),
              AutoSizeText('서버와의 연결이 끊어졌습니다.'),
              AutoSizeText('서버와의 연결이 끊어졌습니다.'),
            ],
          ),
        ),
      ),
    );
  }
}
