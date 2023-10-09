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
          ElevatedButton(onPressed: () {}, child: Container()).expand(),
        ],
      ),
    );
  }
}
