part of "../jangsin_map.dart";

class ViewSplash extends StatefulWidget {
  const ViewSplash({
    super.key,
  });

  @override
  State<ViewSplash> createState() => ViewSplashState();
}

class ViewSplashState extends State<ViewSplash>
    with SingleTickerProviderStateMixin {
  Timer? navigationTimer;

  final TStream<bool> $splash = TStream<bool>();
  final int splashDuration = 2000;

  @override
  Widget build(BuildContext context) {
    return TStreamBuilder(
      initialData: true,
      stream: $splash.browse$,
      builder: (contet, bool splash) {
        return AnimatedOpacity(
          opacity: splash ? 1 : 0,
          duration: Duration(milliseconds: splashDuration),
          child: Container(
            color: Colors.red[300],
            // color: COLOR.BASE_GREEN,
            // child: const Image(
            //   // image: AssetImage(IMAGE.SPLASH),
            //   width: double.infinity,
            //   height: double.infinity,
            // ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // RestfulResult latLng = await GServiceRestaurant.getLatLng();
    // print('latLng ${latLng.isSuccess}');

    // if (latLng.isSuccess == true) {
    //   $splash.sink$(false);
    //   print('splash ${$splash.lastValue}');
    //   if ($splash.lastValue == false) {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, PATH.ROUTE_MAP, (route) => false);
    //   }
    // navigationTimer = Timer(const Duration(milliseconds: 2000), () async {
    // });
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
