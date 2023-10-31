part of 'jangsin_map.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  @override
  State<AppRoot> createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  Map<String, Widget Function(BuildContext)> routes = {
    // PATH.ROUTE_SPLASH: (BuildContext context) => const ViewSplash(),
    PATH.ROUTE_MAP: (BuildContext context) => const ViewMap(),
    PATH.ROUTE_ADMIN: (BuildContext context) => const ViewAdmin(),
    PATH.ROUTE_ADMIN_LOGIN: (BuildContext context) => const ViewAdminLogin(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LABEL.APP_TITLE,
      theme: ThemeData.dark(),
      initialRoute: PATH.ROUTE_MAP,
      routes: routes,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}





// class AppRoot extends StatelessWidget  mixin ApplifecycleMixin{
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, Widget Function(BuildContext)> routes = {
//       // PATH.ROUTE_SPLASH: (BuildContext context) => const ViewSplash(),
//       PATH.ROUTE_MAP: (BuildContext context) => const ViewMap(),
//       PATH.ROUTE_ADMIN: (BuildContext context) => const ViewAdmin(),
//       PATH.ROUTE_ADMIN_LOGIN: (BuildContext context) => const ViewAdminLogin(),
//     };
//     return MaterialApp(
//       title: '장사의 신 - Jangsin Map',
//       theme: ThemeData.dark(),
//       initialRoute: PATH.ROUTE_MAP,
//       routes: routes,
//     );
//   }
// }
