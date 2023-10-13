part of widget;

class TileMapUnit extends StatelessWidget {
  final MRestaurant restaurant;
  final VoidCallback clickEvent;

  const TileMapUnit({
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
          Container(color: Colors.red).expand(),
          Container(color: Colors.red).expand(),
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
}
