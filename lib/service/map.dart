part of '../common.dart';

class ServiceMap {
  static ServiceMap? _instance;
  factory ServiceMap.getInstance() => _instance ??= ServiceMap._internal();

  ServiceMap._internal();

  Future<RestfulResult> getLatLng() async {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    String detailPath = 'map/latlng';

    Uri query =
        IS_LOCAL ? Uri.http(LOCAL_URL, detailPath) : Uri.http(FORIEGN_URL);

    http.get(query).then((rep) {
      Map result = json.decode(rep.body);

      completer.complete(RestfulResult(
        statusCode: 200,
        message: 'get Data complete',
        data: result['data'],
      ));
    });

    return completer.future;
  }
}
