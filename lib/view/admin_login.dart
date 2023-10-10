part of '../jangsin_map.dart';

class ViewAdminLogin extends StatefulWidget {
  const ViewAdminLogin({super.key});

  @override
  State<ViewAdminLogin> createState() => ViewAdminLoginState();
}

class ViewAdminLoginState extends State<ViewAdminLogin> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  final Map<String, TextEditingController> mapOfCtl = {
    "id": TextEditingController(),
    "pw": TextEditingController(),
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("admin login"),
      ),
      body: Center(
        child: SizedBox(
          width: width * 0.2,
          height: height * 0.3,
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    buildIdField().expand(),
                    buildPasswordField().expand(),
                    ElevatedButton(
                      child: const Text('login'),
                      onPressed: () async {
                        RestfulResult result = await GServiceAdmin.signIn(
                          id: "aaaaa",
                          pw: "asd",
                        );

                        if (result.statusCode != 200) return;

                        GSharedPreferences.setString(
                          KEY.LOCAL_DB_TOKEN_KEY,
                          result.data['token'],
                        );

                        Navigator.of(context)
                            .pushReplacementNamed(PATH.ROUTE_ADMIN);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIdField() {
    String id = "id";
    return TextFormField(
      controller: mapOfCtl[id],
      decoration: InputDecoration(
        hintText: id,
        labelText: id,
      ),
    );
  }

  Widget buildPasswordField() {
    String pw = "pw";
    return TextFormField(
      controller: mapOfCtl[pw],
      obscureText: true,
      decoration: InputDecoration(
        hintText: pw,
        labelText: pw,
      ),
    );
  }
}
