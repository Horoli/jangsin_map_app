part of 'jangsin_map.dart';

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, Widget Function(BuildContext)> routes = {
      PATH.MAP: (BuildContext context) => const ViewMap(),
      PATH.ADMIN: (BuildContext context) => const ViewAdmin(),
      PATH.ADMIN_LOGIN: (BuildContext context) => const ViewAdminLogin(),
    };
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: PATH.MAP,
      routes: routes,
    );
  }
}
