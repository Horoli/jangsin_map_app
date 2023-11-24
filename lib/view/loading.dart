part of "../jangsin_map.dart";

class ViewDataLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PointerInterceptor(
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Padding(padding: EdgeInsets.all(8)),
              AutoSizeText('데이터를 불러오는 중입니다...'),
            ],
          ),
        ),
      ),
    );
  }
}
