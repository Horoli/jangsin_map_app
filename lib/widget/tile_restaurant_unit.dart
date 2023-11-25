part of widget;

class TileRestaurantUnit extends StatelessWidget {
  final int index;
  final MRestaurant restaurant;
  final TStream<MRestaurant> $selectedRestaurant;
  final VoidCallback onPressed;

  TileRestaurantUnit({
    required this.index,
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
        foregroundColor: COLOR.TILE_TEXT_COLOR,
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
              AutoSizeText(
                '${index + 1}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: COLOR.GREY),
              ).sizedBox(width: 40),
              FutureBuilder(
                initialData: null,
                future: GServiceRestaurant.getThumbnail(
                    thumbnailId: restaurant.thumbnail),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<Widget?> snapshot,
                ) {
                  return snapshot.data ?? const Center(child: Text("no image"));
                },
              ).expand(),
              //
              const Padding(padding: EdgeInsets.all(4)),
              Column(
                children: [
                  buildLabel().expand(),
                  buildAddress().expand(),
                  // buildLinkButtons().expand(),
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
            // fontSize: ,
            fontWeight: FontWeight.bold,
          ),
        ).expand(),
        const VerticalDivider(),
        AutoSizeText(restaurant.menu_category),
      ],
    );
  }

  Widget buildAddress() {
    String addressString =
        '${restaurant.address_sido} ${restaurant.address_sigungu} ${restaurant.address_eupmyeondong} ${restaurant.address_detail}';
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(addressString).expand(),
          AutoSizeText('영업시간 : ${restaurant.operation_time}').expand(),
          AutoSizeText('휴무일 : ${restaurant.closed_days}').expand(),
        ],
      ),
    );
  }

  // Widget buildLinkButtons() {
  //   return Row(
  //     children: [
  //       buildLinkIconButton(ICON.MAP, restaurant.naver_map_link).expand(),
  //       if (restaurant.sns_link != '')
  //         buildLinkIconButton(ICON.INSTA, restaurant.sns_link).expand(),
  //       // if (restaurant.baemin_link != '')
  //       //   buildLinkIconButton(ICON., restaurant.baemin_link)
  //       //       .expand(),
  //       if (restaurant.youtube_link != '')
  //         buildLinkIconButton(ICON.YOUTUBE, restaurant.youtube_link).expand(),
  //     ],
  //   );
  // }

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
