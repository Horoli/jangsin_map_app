part of widget;

class TileRestaurantUnit extends StatelessWidget {
  final MRestaurant restaurant;
  final TStream<MRestaurant> $selectedRestaurant;
  final VoidCallback onPressed;

  const TileRestaurantUnit({
    required this.restaurant,
    required this.$selectedRestaurant,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(50, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: COLOR.WHITE,
      ),
      onPressed: onPressed,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  initialData:
                      RestfulResult(statusCode: 400, message: '', data: null),
                  future: GServiceRestaurant.getThumbnail(
                      thumbnail: restaurant.thumbnail),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<RestfulResult> snapshot,
                  ) {
                    if (snapshot.data!.statusCode != 200) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.data['thumbnail'] == null ||
                        snapshot.data!.data['thumbnail']['image'] == "") {
                      return const Center(child: Text("no image"));
                    }

                    return Image.memory(base64Decode(
                        snapshot.data!.data['thumbnail']['image']));
                  },
                ),
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
        AutoSizeText(restaurant.menu_category),
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
              restaurant.address_street,
              textAlign: TextAlign.start,
            ).expand(),
          ],
        ).expand(),
        Row(
          children: [
            AutoSizeText(restaurant.operation_time),
            const VerticalDivider(),
            AutoSizeText('휴무일 : ${restaurant.closed_days}'),
          ],
        ).expand(),
      ],
    );
  }

  Widget buildLinkButtons() {
    return Row(
      children: [
        buildLinkIconButton(ICON.MAP, restaurant.naver_map_link).expand(),
        if (restaurant.sns_link != '')
          buildLinkIconButton(ICON.INSTA, restaurant.sns_link).expand(),
        // if (restaurant.baemin_link != '')
        //   buildLinkIconButton(ICON., restaurant.baemin_link)
        //       .expand(),
        if (restaurant.youtube_link != '')
          buildLinkIconButton(ICON.YOUTUBE, restaurant.youtube_link).expand(),
      ],
    );
  }

  Widget buildLinkIconButton(
    String imagePath,
    String link,
  ) {
    return TextButton(
      child: Image.asset(imagePath),
      onPressed: () => js.context.callMethod('open', [link]),
    );
  }
}
