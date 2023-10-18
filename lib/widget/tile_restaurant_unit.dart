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
    return TextButton(
      onPressed: clickEvent,
      child: Stack(
        children: [
          TStreamBuilder(
              stream: $selectedRestaurant.browse$,
              builder: (context, MRestaurant selectedRestaurant) {
                return Container(
                  color: selectedRestaurant.id == restaurant.id
                      ? Colors.blue
                      : Colors.white,
                );
              }),
          Row(
            children: [
              FutureBuilder(
                initialData:
                    RestfulResult(statusCode: 400, message: '', data: null),
                future: GServiceRestaurant.getThumbnail(
                  thumbnail: restaurant.thumbnail,
                ),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<RestfulResult> snapshot,
                ) {
                  if (snapshot.data!.statusCode != 200) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.data['thumbnail'] == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

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
        ],
      ),
    );
  }
}
