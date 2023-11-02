part of 'lib.dart';

class InfinityScrollList extends StatefulWidget {
  final AsyncCallback onRefresh;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollController controller;
  final int itemCount;
  // final List<T> data;

  const InfinityScrollList({
    required this.onRefresh,
    required this.itemBuilder,
    required this.controller,
    required this.itemCount,
    // required this.data,
    super.key,
  });

  @override
  State<InfinityScrollList> createState() => InfinityScrollListState();
}

class InfinityScrollListState extends State<InfinityScrollList> {
  ScrollController get ctrlScroll => widget.controller;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: ctrlScroll,
      separatorBuilder: (context, index) => const Divider(),
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
    );
  }

  @override
  void initState() {
    widget.controller.addListener(onScroll);
    super.initState();
  }

  Future<void> onScroll() async {
    final double maxScroll = ctrlScroll.position.maxScrollExtent;
    final double currentScroll = ctrlScroll.position.pixels;
    if (maxScroll - currentScroll <= 10) {
      print('onScroll max : ${maxScroll}, current : ${currentScroll}');
      widget.onRefresh();
    }
  }

  @override
  void dispose() {
    ctrlScroll.removeListener(onScroll);
    super.dispose();
  }
}
