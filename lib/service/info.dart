part of "../jangsin_map.dart";

class ServiceInfo {
  static ServiceInfo? _instance;
  factory ServiceInfo.getInstance() => _instance ??= ServiceInfo._internal();

  ServiceInfo._internal();

  Future<RestfulResult> visitorUpdate() {
    Completer<RestfulResult> completer = Completer<RestfulResult>();

    Map<String, String> headers = {
      "client-key": dotenv.get("JANGSIN_APP_CLIENT_KEY"),
      "access-control-allow-origin": "*",
    };

    Uri query = PATH.IS_LOCAL
        ? Uri.http(
            PATH.LOCAL_URL,
            PATH.API_INFO_VISITOR_UPDATE,
          )
        : Uri.https(
            PATH.FORIEGN_URL,
            PATH.API_INFO_VISITOR_UPDATE,
          );

    http.get(query, headers: headers).then((rep) {
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
}
