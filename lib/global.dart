part of 'jangsin_map.dart';

final Utility GUtility = Utility();

final HtmlNaverMapControl htmlControl = HtmlNaverMapControl();

late final ServiceRestaurant GServiceRestaurant;
late final ServiceAdmin GServiceAdmin;
late final ServiceInfo GServiceInfo;

late final SharedPreferences GSharedPreferences;

Widget buildExitButton(BuildContext context) {
  return TextButton(
    child: const Text('나가기'),
    onPressed: () => Navigator.pop(context),
  );
}
