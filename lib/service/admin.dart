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

  Future<RestfulResult> createRestaurant({
    required String token,
    required Map<String, dynamic> mapOfRestaurant,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": token,
    };

    String jsonBody = jsonEncode(mapOfRestaurant);

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_RESTAURANT_CREATE)
        : Uri.http(PATH.FORIEGN_URL, PATH.API_RESTAURANT_CREATE);

    http.post(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = json.decode(rep.body);

      RestfulResult result = RestfulResult(
        statusCode: rawData['statusCode'],
        message: rawData['message'],
        data: rawData['data'],
      );

      completer.complete(result);
    });

    return completer.future;
  }

  // TODO : updateRestaurant 생성

  Future<RestfulResult> patchRestaurant({
    required String token,
    required Map<String, dynamic> mapOfRestaurant,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": token,
    };

    String jsonBody = jsonEncode(mapOfRestaurant);

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_RESTAURANT_PATCH)
        : Uri.http(PATH.FORIEGN_URL, PATH.API_RESTAURANT_PATCH);

    print(jsonBody);
    print(query);

    http.post(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = json.decode(rep.body);
      print(rawData);

      RestfulResult result = RestfulResult(
        statusCode: rawData['statusCode'],
        message: rawData['message'],
        data: rawData['data'],
      );

      completer.complete(result);
    });

    return completer.future;
  }

  Future<RestfulResult> getThumbnailAdmin({
    required String token,
    required String thumbnail,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": token,
    };

    String jsonBody = jsonEncode({"thumbnail": thumbnail});

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_IMAGE_THUMBNAIL_ADMIN)
        : Uri.http(PATH.FORIEGN_URL, PATH.API_IMAGE_THUMBNAIL_ADMIN);

    http.post(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = jsonDecode(rep.body);

      if (rawData['statusCode'] != 200) {
        RestfulResult errorResult = RestfulResult(
          statusCode: rawData['statusCode'],
          message: rawData['message'],
        );
        completer.complete(errorResult);
        return errorResult;
      }

      RestfulResult result = RestfulResult(
        statusCode: rawData['statusCode'],
        message: rawData['message'],
        data: rawData['data'],
      );

      completer.complete(result);
    });

    return completer.future;
  }
}
