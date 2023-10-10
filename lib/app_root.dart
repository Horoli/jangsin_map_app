part of 'jangsin_map.dart';

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, Widget Function(BuildContext)> routes = {
      PATH.ROUTE_MAP: (BuildContext context) => const ViewMap(),
      PATH.ROUTE_ADMIN: (BuildContext context) => const ViewAdmin(),
      PATH.ROUTE_ADMIN_LOGIN: (BuildContext context) => const ViewAdminLogin(),
    };
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: PATH.ROUTE_MAP,
      routes: routes,
    );
  }
}
