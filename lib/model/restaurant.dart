part of 'lib.dart';

class MRestaurant extends CommonModel {
  final String id;
  final String source;
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
  final int createdAt;
  final int updatedAt;

  MRestaurant({
    this.id = "",
    this.source = "",
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
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'source': source,
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
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  MRestaurant copyWith({
    String? id,
    String? source,
    String? label,
    String? contact,
    String? representative_menu,
    String? info,
    String? description,
    double? lat,
    double? lng,
    String? address_sido,
    String? address_sigungu,
    String? address_eupmyeondong,
    String? address_detail,
    String? address_street,
    String? closed_days,
    String? operation_time,
    String? sns_link,
    String? naver_map_link,
    String? youtube_uploadedAt,
    String? youtube_link,
    String? baemin_link,
    String? thumbnail,
    String? add_thumbnail,
    int? createdAt,
    int? updatedAt,
  }) =>
      MRestaurant(
        id: id ?? this.id,
        source: source ?? this.source,
        label: label ?? this.label,
        contact: contact ?? this.contact,
        representative_menu: representative_menu ?? this.representative_menu,
        info: info ?? this.info,
        description: description ?? this.description,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        address_sido: address_sido ?? this.address_sido,
        address_sigungu: address_sigungu ?? this.address_sigungu,
        address_eupmyeondong: address_eupmyeondong ?? this.address_eupmyeondong,
        address_detail: address_detail ?? this.address_detail,
        address_street: address_street ?? this.address_street,
        closed_days: closed_days ?? this.closed_days,
        operation_time: operation_time ?? this.operation_time,
        sns_link: sns_link ?? this.sns_link,
        naver_map_link: naver_map_link ?? this.naver_map_link,
        youtube_uploadedAt: youtube_uploadedAt ?? this.youtube_uploadedAt,
        youtube_link: youtube_link ?? this.youtube_link,
        baemin_link: baemin_link ?? this.baemin_link,
        thumbnail: thumbnail ?? this.thumbnail,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory MRestaurant.fromMap(Map item) {
    assert(item.containsKey('id'), 'MRestaurant.fromMap : id is null value');
    assert(item.containsKey('source'),
        'MRestaurant.fromMap : source is null value');
    assert(item.containsKey('label'),
        'MRestaurant.fromMap : labels is null value');
    assert(item.containsKey('contact'),
        'MRestaurant.fromMap : contacts is null value');
    assert(item.containsKey('representative_menu'),
        'MRestaurant.fromMap : representative_menus is null value');
    assert(
        item.containsKey('info'), 'MRestaurant.fromMap : infos is null value');
    assert(item.containsKey('description'),
        'MRestaurant.fromMap : descriptions is null value');
    assert(item.containsKey('lat'), 'MRestaurant.fromMap : lats is null value');
    assert(item.containsKey('lng'), 'MRestaurant.fromMap : lngs is null value');
    assert(item.containsKey('address_sido'),
        'MRestaurant.fromMap : address_sidos is null value');
    assert(item.containsKey('address_sigungu'),
        'MRestaurant.fromMap : address_sigungus is null value');
    assert(item.containsKey('address_eupmyeondong'),
        'MRestaurant.fromMap : address_eupmyeondongs is null value');
    assert(item.containsKey('address_detail'),
        'MRestaurant.fromMap : address_details is null value');
    assert(item.containsKey('address_street'),
        'MRestaurant.fromMap : address_streets is null value');
    assert(item.containsKey('closed_days'),
        'MRestaurant.fromMap : closed_dayss is null value');
    assert(item.containsKey('opertaion_time'),
        'MRestaurant.fromMap : opertaion_times is null value');
    assert(item.containsKey('sns_link'),
        'MRestaurant.fromMap : sns_links is null value');
    assert(item.containsKey('naver_map_link'),
        'MRestaurant.fromMap : naver_map_links is null value');
    assert(item.containsKey('youtube_uploadedAt'),
        'MRestaurant.fromMap : youtube_uploadedAts is null value');
    assert(item.containsKey('youtube_link'),
        'MRestaurant.fromMap : youtube_links is null value');
    assert(item.containsKey('baemin_link'),
        'MRestaurant.fromMap : baemin_links is null value');
    assert(item.containsKey('thumbnail'),
        'MRestaurant.fromMap : thumbnails is null value');
    assert(item.containsKey('createdAt'),
        'MRestaurant.fromMap : createdAt is null value');
    assert(item.containsKey('updatedAt'),
        'MRestaurant.fromMap : updatedAt is null value');

    // assert(item.containsKey('add_thumbnail'),
    //     'MRestaurant.fromMap : thumbnails is null value');

    return MRestaurant(
      id: item['id'],
      source: item['source'],
      label: item['label'],
      contact: item['contact'],
      representative_menu: item['representative_menu'],
      info: item['info'],
      description: item['description'],
      lat: item['lat'],
      lng: item['lng'],
      address_sido: item['address_sido'],
      address_sigungu: item['address_sigungu'],
      address_eupmyeondong: item['address_eupmyeondong'],
      address_detail: item['address_detail'],
      address_street: item['address_street'],
      closed_days: item['closed_days'],
      operation_time: item['opertaion_time'],
      sns_link: item['sns_link'],
      naver_map_link: item['naver_map_link'],
      youtube_uploadedAt: item['youtube_uploadedAt'],
      youtube_link: item['youtube_link'],
      baemin_link: item['baemin_link'],
      thumbnail: item['thumbnail'],
      createdAt: item['createdAt'],
      updatedAt: item['updatedAt'],

      // add_thumbnail: item['add_thumbnail'],
    );
  }
}
