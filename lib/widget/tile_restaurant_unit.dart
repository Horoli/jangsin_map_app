part of widget;

class TileRestaurantUnit extends StatelessWidget {
  final MRestaurant restaurant;
  final TStream<MRestaurant> $selectedRestaurant;
  final VoidCallback clickEvent;

  const TileRestaurantUnit({
    required this.restaurant,
    required this.$selectedRestaurant,
    required this.clickEvent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // style: TextButton.styleFrom(
      //   foregroundColor: COLOR.WHITE,
      //   iconColor: COLOR.WHITE,
      // ),
      onTap: clickEvent,
      // onPressed: clickEvent,
      child: Stack(
        children: [
          TStreamBuilder(
              stream: $selectedRestaurant.browse$,
              builder: (context, MRestaurant selectedRestaurant) {
                return Container(
                  color: selectedRestaurant.id == restaurant.id
                      ? COLOR.BLUE.withOpacity(0.3)
                      : COLOR.WHITE.withOpacity(0.3),
                );
              }),
          Row(
            children: [
              FutureBuilder(
                initialData:
                    RestfulResult(statusCode: 400, message: '', data: null),
                future: GServiceRestaurant.getThumbnail(
                    thumbnail: restaurant.thumbnail),
                builder: (BuildContext context,
                    AsyncSnapshot<RestfulResult> snapshot) {
                  if (snapshot.data!.statusCode != 200) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.data['thumbnail'] == null) {
                    return const Center(child: Text("no image"));
                  }

                  return Image.memory(
                      base64Decode(snapshot.data!.data['thumbnail']['image']));
                },
              ).expand(),
              //
              const Padding(padding: EdgeInsets.all(4)),
              Column(
                children: [
                  buildLabel().expand(),
                  buildAddress().expand(),
                  buildLinkButtons().expand(),
                ],
              ).expand(flex: 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLabel() {
    return Row(
      children: [
        AutoSizeText(
          restaurant.label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ).expand(),
        const VerticalDivider(),
        AutoSizeText(restaurant.operation_time),
        const VerticalDivider(),
        AutoSizeText(restaurant.closed_days),
      ],
    );
  }

  Widget buildAddress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AutoSizeText(
              "${restaurant.address_sido} ${restaurant.address_sigungu} ${restaurant.address_eupmyeondong} ${restaurant.address_detail}",
              // textAlign: TextAlign.start,
            ).expand(),
          ],
        ).expand(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AutoSizeText(
              restaurant.address_street,
              textAlign: TextAlign.start,
            ).expand(),
          ],
        ).expand(),
      ],
    );
  }

  Widget buildLinkButtons() {
    return Row(
      children: [
        buildLinkIconButton(Icons.map, restaurant.naver_map_link).expand(),
        buildLinkIconButton(Icons.restaurant_menu, restaurant.sns_link)
            .expand(),
        buildLinkIconButton(Icons.delivery_dining, restaurant.baemin_link)
            .expand(),
        buildLinkIconButton(
                Icons.slow_motion_video_rounded, restaurant.youtube_link)
            .expand(),
      ],
    );
  }

  Widget buildLinkIconButton(IconData icon, String link) {
    return IconButton(
        onPressed: () => js.context.callMethod('open', [link]),
        icon: Icon(icon));
  }
}
