part of "../jangsin_map.dart";

class ServiceRestaurant {
  static ServiceRestaurant? _instance;
  factory ServiceRestaurant.getInstance() =>
      _instance ??= ServiceRestaurant._internal();

  ServiceRestaurant._internal();

  TStream<MRestaurant> $selectedRestaurant = TStream<MRestaurant>()
    ..sink$(MRestaurant());

  TStream<RestfulResult> $pagination = TStream<RestfulResult>();
  TStream<RestfulResult> $latLng = TStream<RestfulResult>();

  Future<RestfulResult> getLatLng() async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "client-key": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
      "access-control-allow-origin": "*",
    };

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

      $latLng.sink$(RestfulResult(
          statusCode: rawData['statusCode'],
          message: 'get Data complete',
          data: rawData['data']));

      completer.complete(RestfulResult(
        statusCode: 200,
        message: 'get Data complete',
        data: rawData['data'],
      ));
    });

    return completer.future;
  }

  Future<RestfulResult> pagination({
    int page = 1,
    int limit = 10,
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

    ('queryByCondition $queryByCondition');

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

    // try {
    //   final Future<Response> request = http.get(query, headers: headers);

    //   request.timeout(const Duration(seconds: 3));

    //   request.then((rep) {
    //     Map rawData = json.decode(rep.body);

    //     if (rawData['statusCode'] != 200) {
    //       RestfulResult errorResult = RestfulResult(
    //         statusCode: rawData['statusCode'],
    //         message: rawData['message'],
    //       );
    //       completer.complete(errorResult);
    //       return errorResult;
    //     }

    //     List<MRestaurant> getRestaurant =
    //         List.from(rawData['data']['pagination_data'])
    //             .map((data) => MRestaurant.fromMap(data))
    //             .toList();

    //     RestfulResult restfulResult = RestfulResult(
    //       statusCode: 200,
    //       message: 'get Data complete',
    //       data: {
    //         "limit": rawData['data']['limit'],
    //         "dataCount": rawData['data']['dataCount'],
    //         "total_page": rawData['data']['total_page'],
    //         "current_page": page,
    //         "pagination_data": getRestaurant,
    //       },
    //     );

    //     $pagination.sink$(restfulResult);

    //     completer.complete(restfulResult);
    //   });
    // } on TimeoutException catch (timeout) {
    //   print('timeout $timeout');
    //   RestfulResult timeOutResult =
    //       RestfulResult(statusCode: 403, message: 'timeout');
    //   $pagination.sink$(timeOutResult);
    //   completer.complete(timeOutResult);
    // } catch (error) {
    //   print('error $error');
    // }

    // return completer.future;

    http.get(query, headers: headers).timeout(const Duration(seconds: 5),
        onTimeout: () async {
      RestfulResult timeOutResult =
          RestfulResult(statusCode: 403, message: 'timeout');
      $pagination.sink$(timeOutResult);
      completer.complete(timeOutResult);
      throw TimeoutException('Connection time out');
    }).then((rep) {
      Map rawData = json.decode(rep.body);

      if (rawData['statusCode'] != 200) {
        RestfulResult errorResult = RestfulResult(
          statusCode: rawData['statusCode'],
          message: rawData['message'],
        );
        completer.complete(errorResult);
        return errorResult;
      }

      List<MRestaurant> getRestaurant =
          List.from(rawData['data']['pagination_data'])
              .map((data) => MRestaurant.fromMap(data))
              .toList();

      RestfulResult restfulResult = RestfulResult(
        statusCode: 200,
        message: 'get Data complete',
        data: {
          "limit": rawData['data']['limit'],
          "dataCount": rawData['data']['dataCount'],
          "total_page": rawData['data']['total_page'],
          "current_page": page,
          "pagination_data": getRestaurant,
        },
      );

      $pagination.sink$(restfulResult);

      completer.complete(restfulResult);
    }).catchError((onError) {
      RestfulResult timeOutResult =
          RestfulResult(statusCode: 403, message: 'timeout');
      $pagination.sink$(timeOutResult);
      // completer.complete(timeOutResult);
      throw TimeoutException('Connection time out');
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
