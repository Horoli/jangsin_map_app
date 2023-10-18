part of widget;

class ManagementImage extends StatelessWidget {
  BuildContext context;
  MRestaurant restaurant;
  TStream<List<String>> $selectedNewThumbnail;
  String token;
  ManagementImage({
    required this.context,
    required this.restaurant,
    required this.$selectedNewThumbnail,
    required this.token,
    super.key,
  });

  @override
  Widget build(context) {
    return Column(
      children: [
        ElevatedButton(
            child: Text('a'),
            onPressed: () async {
              await selectImageFile().then((image) {
                if (image.isEmpty) {
                  print('image empty');
                  return;
                }

                $selectedNewThumbnail.sink$(image);
                GServiceRestaurant.$selectedRestaurant
                    .sink$(restaurant.copyWith(add_thumbnail: image[0]));
              });
            }).expand(),
        FutureBuilder(
            initialData:
                RestfulResult(statusCode: 400, message: '', data: null),
            future: GServiceAdmin.getThumbnailAdmin(
                token: token, thumbnail: restaurant.thumbnail),
            builder:
                (BuildContext context, AsyncSnapshot<RestfulResult> snapshot) {
              if (snapshot.data!.data == null) {
                return const Text('empty');
              }

              if (snapshot.data!.data['thumbnail'] == null) {
                return const Center(child: Text("no image"));
              }

              return Column(
                children: [
                  Text('after'),
                  Image.memory(base64Decode(
                          snapshot.data!.data['thumbnail']['image']))
                      .expand(),
                ],
              );
            }).expand(),
        TStreamBuilder(
          stream: $selectedNewThumbnail.browse$,
          builder: (context, List<String> thumbnail) {
            return thumbnail[0] == ""
                ? const Text('empty')
                : Column(
                    children: [
                      Text('before'),
                      Image.memory(base64Decode(thumbnail[0])).expand(),
                    ],
                  );
          },
        ).expand(),
      ],
    );
  }
}
