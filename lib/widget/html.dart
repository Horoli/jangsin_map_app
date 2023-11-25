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
                mapUrl: restaurant.naver_map_link,
                youtubeUrl: restaurant.youtube_link,
                instagramUrl: restaurant.sns_link,
              ),
            })
        .toList();
  }

  String createHtmlMarkerInfo(
    String label,
    String sido,
    String sigungu,
    String eupmyeondong,
    String detail, {
    String? instagramUrl,
    String? mapUrl,
    String? youtubeUrl,
  }) {
    return [
      '<div class="iw_inner" style="display: flex; flex-direction: column; border-style: solid; border-color: #3b3b3b; border-radius: 10px;">',
      '<h3 class="header" style="display: flex; border"> <span>$label</span>',
      if (mapUrl != '')
        '<a href="$mapUrl" target="_blank" style="margin-inline: 8px;"><i class="fa fa-map"></i></a>',
      if (instagramUrl != '')
        '<a href="$instagramUrl" target="_blank" style="margin-inline: 8px;"><i class="fa fa-instagram"></i></a>',
      if (youtubeUrl != '')
        '<a href="$youtubeUrl" target="_blank" style="margin-inline: 8px;"><i class="fa fa-youtube"></i></a>',
      '</h3>',
      '<p style="margin: 10px; padding: 0;"> $sido $sigungu<br>',
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
