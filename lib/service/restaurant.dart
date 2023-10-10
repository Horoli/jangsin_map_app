part of "../jangsin_map.dart";

class ServiceRestaurant {
  static ServiceRestaurant? _instance;
  factory ServiceRestaurant.getInstance() =>
      _instance ??= ServiceRestaurant._internal();

  ServiceRestaurant._internal();

  TStream<MRestaurant> $selectedRestaurant = TStream<MRestaurant>()
    ..sink$(MRestaurant());

  Future<RestfulResult> getLatLng() async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "app_info": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
    };

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.APT_RESTAURANT_LATLNG)
        : Uri.http(PATH.FORIEGN_URL);

    http.get(query, headers: headers).then((rep) {
      Map result = json.decode(rep.body);

      completer.complete(RestfulResult(
        statusCode: 200,
        message: 'get Data complete',
        data: result['data'],
      ));
    });

    return completer.future;
  }

  Future<RestfulResult> get() async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "app_info": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
    };

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_RESTAURANT_GET)
        : Uri.http(PATH.FORIEGN_URL);

    http.get(query, headers: headers).then((rep) {
      Map result = json.decode(rep.body);

      List<MRestaurant> getRestaurant = List.from(result['data'])
          .map((data) => MRestaurant.fromMap(data))
          .toList();

      completer.complete(RestfulResult(
        statusCode: 200,
        message: 'get Data complete',
        data: getRestaurant,
      ));
    });

    return completer.future;
  }
}
