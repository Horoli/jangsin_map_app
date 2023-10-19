part of "../jangsin_map.dart";

class ServiceRestaurant {
  static ServiceRestaurant? _instance;
  factory ServiceRestaurant.getInstance() =>
      _instance ??= ServiceRestaurant._internal();

  ServiceRestaurant._internal();

  TStream<MRestaurant> $selectedRestaurant = TStream<MRestaurant>()
    ..sink$(MRestaurant());

  TStream<RestfulResult> $pagination = TStream<RestfulResult>();

  Future<RestfulResult> getLatLng() async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "client-key": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
      "access-control-allow-origin": "*",
    };

    print('get latlng $headers');

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_RESTAURANT_LATLNG)
        : Uri.https(PATH.FORIEGN_URL, PATH.API_RESTAURANT_LATLNG);

    http.get(query, headers: headers).then((rep) {
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

  // Future<RestfulResult> get() async {
  //   Completer<RestfulResult> completer = Completer<RestfulResult>();

  //   Map<String, String> headers = {
  //     "app_info": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
  //   };

  //   Uri query = PATH.IS_LOCAL
  //       ? Uri.http(PATH.LOCAL_URL, PATH.API_RESTAURANT_GET)
  //       : Uri.http(PATH.FORIEGN_URL);

  //   http.get(query, headers: headers).then((rep) {
  //     Map result = json.decode(rep.body);

  //     List<MRestaurant> getRestaurant = List.from(result['data'])
  //         .map((data) => MRestaurant.fromMap(data))
  //         .toList();

  //     completer.complete(RestfulResult(
  //       statusCode: 200,
  //       message: 'get Data complete',
  //       data: getRestaurant,
  //     ));
  //   });

  //   return completer.future;
  // }

  Future<RestfulResult> pagination({
    int page = 1,
    int limit = 5,
    String? sido,
    String? sigungu,
  }) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "client-key": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
      "access-control-allow-origin": "*",
    };

    Map<String, String> queryByCondition = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (sido != null) 'sido': sido,
      if (sido != null && sigungu != null) 'sigungu': sigungu,
    };

    print(queryByCondition);

    Uri query = PATH.IS_LOCAL
        ? Uri.http(
            PATH.LOCAL_URL,
            PATH.API_RESTAURANT_PAGINATION,
            queryByCondition,
          )
        : Uri.https(
            PATH.FORIEGN_URL,
            PATH.API_RESTAURANT_PAGINATION,
            queryByCondition,
          );

    http.get(query, headers: headers).then((rep) {
      Map rawData = json.decode(rep.body);
      // print(rawData);

      if (rawData['statusCode'] != 200) {
        RestfulResult errorResult = RestfulResult(
          statusCode: rawData['statusCode'],
          message: rawData['message'],
        );
        completer.complete(errorResult);
        return errorResult;
      }
      print('step 1');

      List<MRestaurant> getRestaurant =
          List.from(rawData['data']['pagination_data'])
              .map((data) => MRestaurant.fromMap(data))
              .toList();

      RestfulResult restfulResult = RestfulResult(
        statusCode: 200,
        message: 'get Data complete',
        data: {
          "total_page": rawData['data']['total_page'],
          "current_page": page,
          "pagination_data": getRestaurant,
        },
      );

      $pagination.sink$(restfulResult);

      completer.complete(restfulResult);
    });

    return completer.future;
  }

  Future<RestfulResult> getThumbnail({
    required String thumbnail,
  }) {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "access-control-allow-origin": "*",
      "client-key": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
    };

    String jsonBody = jsonEncode({"thumbnail": thumbnail});

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_IMAGE_THUMBNAIL)
        : Uri.https(PATH.FORIEGN_URL, PATH.API_IMAGE_THUMBNAIL);

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
