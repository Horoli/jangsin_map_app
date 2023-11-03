part of 'jangsin_map.dart';

final Utility GUtility = Utility();

late final ServiceRestaurant GServiceRestaurant;
late final ServiceAdmin GServiceAdmin;
late final SharedPreferences GSharedPreferences;

Widget buildExitButton(BuildContext context) {
  return TextButton(
    child: const Text('나가기'),
    onPressed: () => Navigator.pop(context),
  );
}
