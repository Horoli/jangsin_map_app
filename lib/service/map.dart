part of "../jangsin_map.dart";

class ServiceMap {
  static ServiceMap? _instance;
  factory ServiceMap.getInstance() => _instance ??= ServiceMap._internal();

  ServiceMap._internal();

  Future<RestfulResult> getLatLng() async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "app_info": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
    };

    String detailPath = 'map/latlng';

    Uri query =
        IS_LOCAL ? Uri.http(LOCAL_URL, detailPath) : Uri.http(FORIEGN_URL);

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

    String detailPath = 'map/get';

    Uri query =
        IS_LOCAL ? Uri.http(LOCAL_URL, detailPath) : Uri.http(FORIEGN_URL);

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
