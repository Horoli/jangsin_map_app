part of 'lib.dart';

class AppendScrollListView extends StatefulWidget {
  final bool isLoading;
  final AsyncCallback onRefreshStart;
  final AsyncCallback onRefreshEnd;
  final ScrollController controller;
  final List<Widget> children;
  // final IndexedWidgetBuilder itemBuilder;
  // final int itemCount;

  const AppendScrollListView({
    required this.isLoading,
    required this.onRefreshStart,
    required this.onRefreshEnd,
    required this.controller,
    required this.children,
    // required this.itemBuilder,
    // required this.itemCount,
    super.key,
  });

  @override
  State<AppendScrollListView> createState() => AppendScrollListViewState();
}

class AppendScrollListViewState extends State<AppendScrollListView> {
  ScrollController get ctrlScroll => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ListView.separated(
        //   controller: ctrlScroll,
        //   separatorBuilder: (context, index) => const Divider(),
        //   itemCount: widget.itemCount,
        //   itemBuilder: widget.itemBuilder,
        // ),

        ListView(
          controller: ctrlScroll,
          children: widget.children,
        ),
        /*

          중복 데이터 추가를 방지하기 위해 isLoading이 true일 때만 인터셉터를 추가

        */
        if (widget.isLoading)
          PointerInterceptor(
              child: const Center(child: CircularProgressIndicator()))
      ],
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
    /*

      mobile web Debug시 maxScroll이 갑자기 변경되는 경우가 있음

    */
    if (maxScroll == currentScroll) {
      debugPrint(
          'onScroll : maxScroll: $maxScroll, currentScroll: $currentScroll');

      await widget.onRefreshStart();
      await widget.onRefreshEnd();
    }
  }

  @override
  void dispose() {
    ctrlScroll.removeListener(onScroll);
    super.dispose();
  }
}
