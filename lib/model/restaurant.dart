part of 'lib.dart';

class MRestaurant extends CommonModel {
  final String id;
  final String label;
  final String contact;
  final String representative_menu;
  final String info;
  final String description;
  final double lat;
  final double lng;
  final String address_sido;
  final String address_sigungu;
  final String address_eupmyeondong;
  final String address_detail;
  final String address_street;
  final String closed_days;
  final String operation_time;
  final String sns_link;
  final String naver_map_link;
  final String youtube_uploadedAt;
  final String youtube_link;
  final String baemin_link;
  final String thumbnail;
  MRestaurant({
    this.id = "",
    this.label = "",
    this.contact = "",
    this.representative_menu = "",
    this.info = "",
    this.description = "",
    this.lat = 0,
    this.lng = 0,
    this.address_sido = "",
    this.address_sigungu = "",
    this.address_eupmyeondong = "",
    this.address_detail = "",
    this.address_street = "",
    this.closed_days = "",
    this.operation_time = "",
    this.sns_link = "",
    this.naver_map_link = "",
    this.youtube_uploadedAt = "",
    this.youtube_link = "",
    this.baemin_link = "",
    this.thumbnail = "",
  });

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'label': label,
        'contact': contact,
        'representative_menu': representative_menu,
        'info': info,
        'description': description,
        'lat': lat,
        'lng': lng,
        'address_sido': address_sido,
        'address_sigungu': address_sigungu,
        'address_eupmyeondong': address_eupmyeondong,
        'address_detail': address_detail,
        'address_street': address_street,
        'closed_days': closed_days,
        'opertaion_time': operation_time,
        'sns_link': sns_link,
        'naver_map_link': naver_map_link,
        'youtube_uploadedAt': youtube_uploadedAt,
        'youtube_link': youtube_link,
        'baemin_link': baemin_link,
        'thumbnail': thumbnail,
      };

  factory MRestaurant.fromMap(Map item) {
    String id = item['id'] ?? '';
    String label = item['label'] ?? '';
    String contact = item['contact'] ?? '';
    String representative_menu = item['representative_menu'] ?? '';
    String info = item['info'] ?? '';
    String description = item['description'] ?? '';
    double lat = item['lat'] ?? 0;
    double lng = item['lng'] ?? 0;
    String address_sido = item['address_sido'] ?? '';
    String address_sigungu = item['address_sigungu'] ?? '';
    String address_eupmyeondong = item['address_eupmyeondong'] ?? '';
    String address_detail = item['address_detail'] ?? '';
    String address_street = item['address_street'] ?? '';
    String closed_days = item['closed_days'] ?? '';
    String opertaion_time = item['opertaion_time'] ?? '';
    String sns_link = item['sns_link'] ?? '';
    String naver_map_link = item['naver_map_link'] ?? '';
    String youtube_uploadedAt = item['youtube_uploadedAt'] ?? '';
    String youtube_link = item['youtube_link'] ?? '';
    String baemin_link = item['baemin_link'] ?? '';
    String thumbnail = item['thumbnail'] ?? '';

    return MRestaurant(
      id: id,
      label: label,
      contact: contact,
      representative_menu: representative_menu,
      info: info,
      description: description,
      lat: lat,
      lng: lng,
      address_sido: address_sido,
      address_sigungu: address_sigungu,
      address_eupmyeondong: address_eupmyeondong,
      address_detail: address_detail,
      address_street: address_street,
      closed_days: closed_days,
      operation_time: opertaion_time,
      sns_link: sns_link,
      naver_map_link: naver_map_link,
      youtube_uploadedAt: youtube_uploadedAt,
      youtube_link: youtube_link,
      baemin_link: baemin_link,
      thumbnail: thumbnail,
    );
  }
}
