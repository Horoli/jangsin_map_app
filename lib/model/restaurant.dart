part of 'lib.dart';

class MRestaurant extends CommonModel {
  final String type;
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
  final String opertaion_time;
  final String sns;
  final String youtube_uploadedAt;
  final String youtube_link;
  final String baemin_link;
  final String thumbnail;
  MRestaurant({
    required this.type,
    required this.label,
    required this.contact,
    required this.representative_menu,
    required this.info,
    required this.description,
    required this.lat,
    required this.lng,
    required this.address_sido,
    required this.address_sigungu,
    required this.address_eupmyeondong,
    required this.address_detail,
    required this.address_street,
    required this.closed_days,
    required this.opertaion_time,
    required this.sns,
    required this.youtube_uploadedAt,
    required this.youtube_link,
    required this.baemin_link,
    required this.thumbnail,
  });

  @override
  Map<String, dynamic> get map => {
        'type': type,
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
        'opertaion_time': opertaion_time,
        'sns': sns,
        'youtube_uploadedAt': youtube_uploadedAt,
        'youtube_link': youtube_link,
        'baemin_link': baemin_link,
        'thumbnail': thumbnail,
      };

  factory MRestaurant.fromMap(Map item) {
    String type = item['type'] ?? '';
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
    String sns = item['sns'] ?? '';
    String youtube_uploadedAt = item['youtube_uploadedAt'] ?? '';
    String youtube_link = item['youtube_link'] ?? '';
    String baemin_link = item['baemin_link'] ?? '';
    String thumbnail = item['thumbnail'] ?? '';

    return MRestaurant(
      type: type,
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
      opertaion_time: opertaion_time,
      sns: sns,
      youtube_uploadedAt: youtube_uploadedAt,
      youtube_link: youtube_link,
      baemin_link: baemin_link,
      thumbnail: thumbnail,
    );
  }
}
