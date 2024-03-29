part of "../jangsin_map.dart";

class ServiceRestaurant {
  static ServiceRestaurant? _instance;
  factory ServiceRestaurant.getInstance() =>
      _instance ??= ServiceRestaurant._internal();

  ServiceRestaurant._internal();

  final TStream<MRestaurant> $selectedRestaurant = TStream<MRestaurant>()
    ..sink$(MRestaurant());

  final TStream<RestfulResult> $pagination = TStream<RestfulResult>();
  final TStream<RestfulResult> $latLng = TStream<RestfulResult>();
  final TStream<RestfulResult> $districtSido = TStream<RestfulResult>();
  final TStream<RestfulResult> $districtSigungu = TStream<RestfulResult>();

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

  Future<RestfulResult> getDistrict({
    String? sido,
    required bool isYoutube,
  }) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "client-key": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
      "access-control-allow-origin": "*",
    };

    Map<String, String> queryByCondition = {
      'source': isYoutube ? 'youtube' : 'cafe',
      if (sido != null) 'sido': sido,
    };

    Uri query = PATH.IS_LOCAL
        ? Uri.http(
            PATH.LOCAL_URL,
            PATH.API_RESTAURANT_DISTRICT,
            queryByCondition,
          )
        : Uri.https(
            PATH.FORIEGN_URL,
            PATH.API_RESTAURANT_DISTRICT,
            queryByCondition,
          );

    http.get(query, headers: headers).then((rep) {
      Map rawData = json.decode(rep.body);
      (rawData);

      if (rawData['statusCode'] != 200) {
        RestfulResult errorResult = RestfulResult(
          statusCode: rawData['statusCode'],
          message: rawData['message'],
        );
        completer.complete(errorResult);
        return errorResult;
      }

      List<String> convertSido = List<String>.from(rawData['data']['sido']);

      // sido가 입력됐으면
      List<String> convertSigungu = [];
      if (sido != null) {
        convertSigungu = List<String>.from(rawData['data']['sigungu']);
        $districtSigungu.sink$(RestfulResult(
          statusCode: rawData['statusCode'],
          message: 'get district sigungu complete',
          data: convertSigungu,
        ));
      }

      $districtSido.sink$(RestfulResult(
        statusCode: rawData['statusCode'],
        message: 'get district sido complete',
        data: convertSido,
      ));

      completer.complete(RestfulResult(
        statusCode: 200,
        message: 'get Data complete',
        data: convertSido,
      ));
    });

    return completer.future;
  }

  Future<RestfulResult> pagination({
    int page = 1,
    int limit = 30,
    String? sido,
    String? sigungu,
    required bool isYoutube,
  }) async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "client-key": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
      "access-control-allow-origin": "*",
    };

    // sido와 sigungu가 있으면 쿼리에 추가
    Map<String, String> queryByCondition = {
      'page': page.toString(),
      'limit': limit.toString(),
      'source': isYoutube ? 'youtube' : 'cafe',
      if (sido != null) 'sido': sido,
      if (sido != null && sigungu != null) 'sigungu': sigungu,
    };

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

  final Map<String, Widget> thumbnailCache = {};

  Future<Widget?> getThumbnail({
    required String thumbnailId,
  }) {
    Completer<Widget?> completer = Completer<Widget?>();

    if (thumbnailCache.containsKey(thumbnailId)) {
      completer.complete(thumbnailCache[thumbnailId]!);
      return completer.future;
    }

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "access-control-allow-origin": "*",
      "client-key": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
    };

    String jsonBody = jsonEncode({"thumbnail": thumbnailId});

    Uri query = PATH.IS_LOCAL
        ? Uri.http(PATH.LOCAL_URL, PATH.API_IMAGE_THUMBNAIL)
        : Uri.https(PATH.FORIEGN_URL, PATH.API_IMAGE_THUMBNAIL);

    http.post(query, headers: headers, body: jsonBody).then((rep) {
      Map rawData = jsonDecode(rep.body);
      Map data = rawData['data'];

      if (rawData['statusCode'] == 200 &&
          data['thumbnail'] != null &&
          data['thumbnail']['image'] != null &&
          data['thumbnail']['image'].isNotEmpty) {
        String imageBase64 = data['thumbnail']['image'];
        Widget convertImage;
        if (imageBase64.length < 100) {
          convertImage = const Center(
              child: Text(
            'crashed image',
            textAlign: TextAlign.center,
          ));
        } else {
          convertImage = Image.memory(
            base64Decode(imageBase64),
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('crashed image'));
            },
          );
        }
        completer.complete(thumbnailCache[thumbnailId] = convertImage);
        return completer.future;
      }

      completer.complete();
    });

    return completer.future;
  }

  void clearThumbnailCache() {
    thumbnailCache.clear();
  }
}
