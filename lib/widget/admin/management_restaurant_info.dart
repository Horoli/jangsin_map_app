part of widget;

class ManagementRestaurantInfo extends StatelessWidget {
  BuildContext context;
  MRestaurant restaurant;
  Map<String, Map<String, TextEditingController>> mapOfCtrl;
  ManagementRestaurantInfo({
    required this.context,
    required this.restaurant,
    required this.mapOfCtrl,
    super.key,
  });

  Map<String, TextEditingController> get mapOfDropdown =>
      mapOfCtrl[KEY.ADMIN_MAP_OF_CTRL_DROPDOWN]!;
  Map<String, TextEditingController> get mapOfAddress =>
      mapOfCtrl[KEY.ADMIN_MAP_OF_CTRL_ADDRESS]!;
  Map<String, TextEditingController> get mapOfRestaurant =>
      mapOfCtrl[KEY.ADMIN_MAP_OF_CTRL_RESTAURANT]!;
  Map<String, TextEditingController> get mapOfLink =>
      mapOfCtrl[KEY.ADMIN_MAP_OF_CTRL_LINK]!;

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  @override
  Widget build(context) {
    return Center(
      child: SizedBox(
        width: width * 0.7,
        height: height * 0.7,
        child: Card(
          child: Row(
            children: [
              Column(
                children: [
                  buildSidoDropdownButton().expand(),
                  buildSigunguDropdownButton().expand(),
                  for (int i = 0; i < mapOfAddress.keys.length; i++)
                    buildAdminTextField(
                      mapOfAddress.keys.toList()[i],
                      'address',
                    ).expand(),
                ],
              ).expand(),
              const VerticalDivider(),
              Column(
                children: [
                  for (int i = 0; i < mapOfRestaurant.keys.length; i++)
                    buildAdminTextField(
                      mapOfRestaurant.keys.toList()[i],
                      'restaurant',
                    ).expand(),
                ],
              ).expand(),
              const VerticalDivider(),
              Column(
                children: [
                  for (int i = 0; i < mapOfLink.keys.length; i++)
                    buildAdminTextField(
                      mapOfLink.keys.toList()[i],
                      'link',
                    ).expand(),
                ],
              ).expand(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSidoDropdownButton() {
    return DropdownButton(
      value: mapOfDropdown[KEY.ADMIN_SIDO]!.text,
      items: DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT.keys
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (dynamic value) {
        mapOfDropdown[KEY.ADMIN_SIDO]!.text = value;
        mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text =
            DISTRICT.KOREA_ADMINISTRAIVE_DISTRICT[
                mapOfDropdown[KEY.ADMIN_SIDO]!.text]![0];
        addDataIfNotSelected();
      },
    );
  }

  Widget buildSigunguDropdownButton() {
    return DropdownButton(
      value: mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text,
      items: DISTRICT
          .KOREA_ADMINISTRAIVE_DISTRICT[mapOfDropdown[KEY.ADMIN_SIDO]!.text]!
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (dynamic value) {
        mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text = value;
        addDataIfNotSelected();
      },
    );
  }

  Widget buildAdminTextField(String key, String flag) {
    late final TextEditingController ctrl;
    switch (flag) {
      case 'address':
        ctrl = mapOfAddress[key]!;
      case 'restaurant':
        ctrl = mapOfRestaurant[key]!;
      case 'link':
        ctrl = mapOfLink[key]!;
    }
    return Center(
      child: TextFormField(
          controller: ctrl,
          decoration: InputDecoration(
            labelText: key,
            hintText: key,
          ),
          onChanged: (value) => addDataIfNotSelected()),
    );
  }

  void addDataIfNotSelected() {
    double lat = mapOfAddress[KEY.ADMIN_LAT]!.text == ""
        ? 0
        : double.parse(mapOfAddress[KEY.ADMIN_LAT]!.text);
    double lng = mapOfAddress[KEY.ADMIN_LNG]!.text == ""
        ? 0
        : double.parse(mapOfAddress[KEY.ADMIN_LNG]!.text);

    MRestaurant mRestaurant = MRestaurant(
      id: restaurant.id == '' ? '' : restaurant.id,
      address_sido: mapOfDropdown[KEY.ADMIN_SIDO]!.text,
      address_sigungu: mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text,
      address_eupmyeondong: mapOfAddress[KEY.ADMIN_EUPMYEONDONG]!.text,
      address_detail: mapOfAddress[KEY.ADMIN_DETAIL]!.text,
      address_street: mapOfAddress[KEY.ADMIN_STREET]!.text,
      lat: lat,
      lng: lng,
      label: mapOfRestaurant[KEY.ADMIN_LABEL]!.text,
      contact: mapOfRestaurant[KEY.ADMIN_CONTACT]!.text,
      representative_menu: mapOfRestaurant[KEY.ADMIN_REPRESENTATIVE_MENU]!.text,
      closed_days: mapOfRestaurant[KEY.ADMIN_CLOSED_DAYS]!.text,
      operation_time: mapOfRestaurant[KEY.ADMIN_OPERATION_TIME]!.text,
      sns_link: mapOfLink[KEY.ADMIN_SNS_LINK]!.text,
      naver_map_link: mapOfLink[KEY.ADMIN_NAVER_MAP_LINK]!.text,
      youtube_link: mapOfLink[KEY.ADMIN_YOUTUBE_LINK]!.text,
      youtube_uploadedAt: mapOfLink[KEY.ADMIN_YOUTUBE_UPLOADED_AT]!.text,
      baemin_link: mapOfLink[KEY.ADMIN_BAEMIN_LINK]!.text,
    );

    GServiceRestaurant.$selectedRestaurant.sink$(mRestaurant);

    // return mRestaurant;
  }
}
