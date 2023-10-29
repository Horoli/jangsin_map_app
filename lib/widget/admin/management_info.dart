part of widget;

class ManagementInfo extends StatelessWidget {
  BuildContext context;
  MRestaurant restaurant;
  Map<String, Map<String, TextEditingController>> mapOfCtrl;
  ManagementInfo({
    required this.context,
    required this.restaurant,
    required this.mapOfCtrl,
    super.key,
  });

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
          child: Column(
            children: [
              Row(
                children: [
                  // const VerticalDivider(),
                  Column(
                    children: [
                      for (int i = 0; i < mapOfRestaurant.keys.length; i++)
                        buildAdminTextField(
                          mapOfRestaurant.keys.toList()[i],
                          LABEL.CTRL_RESTAURANT,
                        ).expand(),
                    ],
                  ).expand(),
                  const VerticalDivider(),
                  Column(
                    children: [
                      for (int i = 0; i < mapOfLink.keys.length; i++)
                        buildAdminTextField(
                          mapOfLink.keys.toList()[i],
                          LABEL.CTRL_LINK,
                        ).expand(),
                    ],
                  ).expand(),
                ],
              ).expand(),
              const Divider(),
              for (int i = 0; i < mapOfAddress.keys.length; i++)
                buildAdminTextField(
                  mapOfAddress.keys.toList()[i],
                  LABEL.CTRL_ADDRESS,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAdminTextField(String key, String flag) {
    late final TextEditingController ctrl;
    switch (flag) {
      case LABEL.CTRL_ADDRESS:
        ctrl = mapOfAddress[key]!;
      case LABEL.CTRL_RESTAURANT:
        ctrl = mapOfRestaurant[key]!;
      case LABEL.CTRL_LINK:
        ctrl = mapOfLink[key]!;
    }
    return Center(
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: key,
          hintText: key,
        ),
        // onChanged: (value) => addDataIfNotSelected()
      ),
    );
  }

  void setAddressForRestaurant() {
    MRestaurant mRestaurant = restaurant.copyWith(
      id: restaurant.id == '' ? '' : restaurant.id,
      // address_sido: mapOfDropdown[KEY.ADMIN_SIDO]!.text,
      // address_sigungu: mapOfDropdown[KEY.ADMIN_SIGUNGU]!.text,
    );

    GServiceRestaurant.$selectedRestaurant.sink$(mRestaurant);
  }
}
