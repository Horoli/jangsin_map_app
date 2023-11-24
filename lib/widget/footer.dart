part of 'lib.dart';

class FooterBar extends StatelessWidget {
  Color? barColor;
  List<Map<String, dynamic>> mapOfData;
  BuildContext context;
  FooterBar({
    this.barColor,
    required this.mapOfData,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: barColor,
      width: double.infinity,
      child: Row(
        children: generateButtons(),
      ),
    );
  }

  List<Widget> generateButtons() {
    List<Widget> footer = [
      const Padding(padding: EdgeInsets.all(4)),
      const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '사이트맵',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: COLOR.WHITE,
            ),
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.all(4)),
    ];

    List<Widget> footerButtons = mapOfData
        .map((Map<String, dynamic> data) =>
            buildIconButtons(child: data['child'], url: data['url']))
        .toList();

    footerButtons.add(buildAboutButton());
    footer.addAll(footerButtons);

    return footer;
  }

  Widget buildIconButtons({
    required Widget child,
    required String url,
  }) {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: COLOR.WHITE),
      child: child,
      onPressed: () => js.context.callMethod('open', [url]),
    );
  }

  Widget buildAboutButton() {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: COLOR.WHITE),
      child: const SizedBox(
        height: double.infinity,
        child: Center(child: Text('About')),
      ),
      onPressed: () async {
        aboutPop();
      },
    );
  }

  Future<void> aboutPop() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PointerInterceptor(
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: 400,
              height: 200,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: buildToAdminLoginButton(),
                  ),
                  const Center(child: Text(LABEL.FOOTER_EMAIL)).expand(),
                  const Center(child: Text(LABEL.FOOTER_COPYRIGHT)).expand(),
                  buildExitButton(context).expand(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildToAdminLoginButton() {
    return TextButton(
      child: const Text(''),
      onPressed: () {},
      onLongPress: () {
        Navigator.of(context).pushNamed(PATH.ROUTE_ADMIN_LOGIN);
      },
    );
  }
}
