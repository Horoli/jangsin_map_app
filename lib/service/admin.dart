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
    required MRestaurant restaurant,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": token,
    };

    String jsonBody = jsonEncode(restaurant.map);

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_RESTAURANT_CREATE)
        : Uri.http(PATH.FORIEGN_URL, PATH.API_RESTAURANT_CREATE);

    print(jsonBody);
    print(query);

    http.post(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = json.decode(rep.body);

      print(rawData);

      RestfulResult result = RestfulResult(
        statusCode: rawData['status'],
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
    required MRestaurant restaurant,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": token,
    };

    String jsonBody = jsonEncode(restaurant.map);

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_RESTAURANT_PATCH)
        : Uri.http(PATH.FORIEGN_URL, PATH.API_RESTAURANT_PATCH);

    print(jsonBody);
    print(query);

    http.post(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = json.decode(rep.body);
      print(rawData);

      RestfulResult result = RestfulResult(
        statusCode: rawData['status'],
        message: rawData['message'],
        data: rawData['data'],
      );

      completer.complete(result);
    });

    return completer.future;
  }

  Future<RestfulResult> getThumbnail({
    required String token,
    required String thumbnailId,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": token,
    };

    String jsonBody = jsonEncode({"thumbnail_id": thumbnailId});

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_IMAGE_THUMBNAIL)
        : Uri.http(PATH.FORIEGN_URL, PATH.API_IMAGE_THUMBNAIL);

    http.post(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = jsonDecode(rep.body);

      if (rawData['status'] != 200) {
        return RestfulResult(
          statusCode: rawData['status'],
          message: rawData['message'],
        );
      }

      print(rawData);
      RestfulResult result = RestfulResult(
        statusCode: rawData['status'],
        message: rawData['message'],
        data: rawData['data'],
      );

      completer.complete(result);
    });

    return completer.future;
  }
}
