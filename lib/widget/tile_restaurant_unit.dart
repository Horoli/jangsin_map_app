part of widget;

class TileRestaurantUnit extends StatelessWidget {
  final MRestaurant restaurant;
  final VoidCallback clickEvent;

  const TileRestaurantUnit({
    required this.restaurant,
    required this.clickEvent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: clickEvent,
      child: Row(
        children: [
          // Text('${restaurant.thumbnail}').expand(),
          FutureBuilder(
            future: GServiceRestaurant.getThumbnail(
              thumbnailId: restaurant.thumbnail,
            ),
            builder: (
              BuildContext context,
              AsyncSnapshot<RestfulResult> snapshot,
            ) {
              print(snapshot.data!.data['thumbnail']['image']);
              // return Container();
              return Image.memory(
                  base64Decode(snapshot.data!.data['thumbnail']['image']));
            },
          ).expand(),
          Container().expand(),
          Container().expand(),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () {
              js.context.callMethod('open', [restaurant.naver_map_link]);
            },
          ).expand(),
        ],
      ),
    );
  }

  void asd() {}
}
