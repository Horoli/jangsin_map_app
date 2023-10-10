part of "../jangsin_map.dart";

class ServiceAdmin {
  static ServiceAdmin? _instance;
  factory ServiceAdmin.getInstance() => _instance ??= ServiceAdmin._internal();

  ServiceAdmin._internal();

  Future<RestfulResult> signIn({required String id, required String pw}) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      // "": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
    };

    String jsonBody = jsonEncode({"id": id, "pw": pw});

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_USERS_SIGN_IN)
        : Uri.http(PATH.FORIEGN_URL, PATH.API_USERS_SIGN_IN);

    http.post(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = json.decode(rep.body);

      RestfulResult result = RestfulResult(
        statusCode: 200,
        message: rawData['message'],
        data: rawData['data'],
      );

      completer.complete(result);
    });

    return completer.future;
  }

  Future<RestfulResult> createMapData({
    required String token,
    required String label,
    required String contact,
    required String info,
    required double lat,
    required double lng,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": token,
      // "": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
    };

    String jsonBody = jsonEncode({
      "label": label,
      "contact": contact,
      "info": info,
      "lat": lat,
      "lng": lng,
    });

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_MAP_CREATE)
        : Uri.http(PATH.FORIEGN_URL, PATH.API_MAP_CREATE);

    http.post(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = json.decode(rep.body);

      RestfulResult result = RestfulResult(
        statusCode: 200,
        message: rawData['message'],
        data: rawData['data'],
      );

      completer.complete(result);
    });

    return completer.future;
  }
}
