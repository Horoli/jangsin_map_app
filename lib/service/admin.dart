part of "../jangsin_map.dart";

class ServiceAdmin {
  static ServiceAdmin? _instance;
  factory ServiceAdmin.getInstance() => _instance ??= ServiceAdmin._internal();

  ServiceAdmin._internal();

  Future<RestfulResult> signIn({required String id, required String pw}) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "access-control-allow-origin": "*",
      // "": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
    };

    String jsonBody = jsonEncode({"id": id, "pw": pw});

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_USERS_SIGN_IN)
        : Uri.https(PATH.FORIEGN_URL, PATH.API_USERS_SIGN_IN);

    http.post(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = json.decode(rep.body);
      if (rawData['statusCode'] != 200) {
        RestfulResult result = RestfulResult(
          statusCode: rawData['statusCode'],
          message: rawData['message'],
          data: rawData['data'],
        );
        return completer.complete(result);
      }

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
      "access-control-allow-origin": "*",
      "token": token,
    };

    String jsonBody = jsonEncode(mapOfRestaurant);

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_RESTAURANT_CREATE)
        : Uri.https(PATH.FORIEGN_URL, PATH.API_RESTAURANT_CREATE);

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
        : Uri.https(PATH.FORIEGN_URL, PATH.API_RESTAURANT_PATCH);

    (jsonBody);
    (query);

    http.post(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = json.decode(rep.body);
      (rawData);

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
        : Uri.https(PATH.FORIEGN_URL, PATH.API_IMAGE_THUMBNAIL_ADMIN);

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

  Future<RestfulResult> delete({
    required String token,
    required String id,
  }) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      // "client-key": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
      "token": token,
      "access-control-allow-origin": "*",
    };

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_RESTAURANT_DELETE)
        : Uri.https(PATH.FORIEGN_URL, PATH.API_RESTAURANT_DELETE);

    String jsonBody = jsonEncode({"id": id});
    ('jsonBody $jsonBody');

    http.delete(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = json.decode(rep.body);

      if (rawData['statusCode'] != 200) {
        RestfulResult errorResult = RestfulResult(
          statusCode: rawData['statusCode'],
          message: rawData['message'],
        );
        completer.complete(errorResult);
        return errorResult;
      }

      completer.complete(RestfulResult(
        statusCode: 200,
        message: 'get Data complete',
        data: rawData['data'],
      ));
    });

    return completer.future;
  }

  final TStream<List<List<dynamic>>> $testImage =
      TStream<List<List<dynamic>>>();

  Future<RestfulResult> csvUpload({
    required String token,
    required List<List<dynamic>> csv,
  }) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "access-control-allow-origin": "*",
      "token": token,
    };

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_RESTAURANT_CSV_UPLOAD)
        : Uri.https(PATH.FORIEGN_URL, PATH.API_RESTAURANT_CSV_UPLOAD);

    String jsonBody = jsonEncode({"csv": csv});

    http
        .post(query, headers: headers, body: jsonBody)
        .timeout(const Duration(seconds: 30))
        .then((rep) {
      Map rawData = json.decode(rep.body);

      if (rawData['statusCode'] != 200) {
        RestfulResult errorResult = RestfulResult(
          statusCode: rawData['statusCode'],
          message: rawData['message'],
        );
        completer.complete(errorResult);

        return errorResult;
      }

      completer.complete(RestfulResult(
        statusCode: rawData['statusCode'],
        message: rawData['message'],
        data: rawData['data'],
      ));
    });

    return completer.future;
  }
}
