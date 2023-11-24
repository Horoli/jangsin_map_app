part of 'lib.dart';

class HtmlNaverMapControl {
  Future<void> registerHtml(String key, String path) async {
    ui_web.platformViewRegistry.registerViewFactory(
      key,
      (int id) => html.IFrameElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
        ..src = path,
    );
  }

  Future<void> inputDataForHtml(
      {required String dataType, required dynamic data}) async {
    assert(
        dataType == KEY.DATATYPE_INIT_MARKER ||
            dataType == KEY.DATATYPE_SET_MARKER ||
            dataType == KEY.DATATYPE_INFO_WINDOW_SETUP,
        'inputDataForHtml exception : dataType is not init or set');
    Map<String, dynamic> mapOfData = {
      'type': dataType,
      'data': data,
    };

    String jsonData = jsonEncode(mapOfData);
    html.window.postMessage('@HTML$jsonData', '*');
  }

  List<Map<String, dynamic>> convertMarkerData(List<MRestaurant> datas) {
    return datas
        .map((MRestaurant restaurant) => {
              'label': restaurant.label,
              'lat': restaurant.lat,
              'lng': restaurant.lng,
              'info': createHtmlMarkerInfo(
                restaurant.label,
                restaurant.address_sido,
                restaurant.address_sigungu,
                restaurant.address_eupmyeondong,
                restaurant.address_detail,
              ),
            })
        .toList();
  }

  String createHtmlMarkerInfo(
    String label,
    String sido,
    String sigungu,
    String eupmyeondong,
    String detail,
  ) {
    return [
      '<div class="iw_inner" style="display: flex; flex-direction: column; background-color: #f5f5f5; border-style: solid; border-color: black; border-radius: 10px;">',
      '<h3 style="background-color: black; color: white; margin: 0; padding: 10px;"> $label</h3>',
      '<p style="margin: 0; padding: 0;"> $sido $sigungu<br>',
      '$eupmyeondong $detail </p>',
      "</div>",
    ].join('');
  }

  // void addEventListener(String message, event) {
  //   html.window.addEventListener(message, (Event event) {
  //     String _data = event.data.toString();
  //     if (!_data.startsWith('@APP')) return;

  //     String data = _data.substring(4);
  //     Map<String, dynamic> mapOfData = jsonDecode(data);

  //     print('mapOfData $mapOfData');
  //   });
  // }
}
