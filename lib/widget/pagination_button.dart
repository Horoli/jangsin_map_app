part of 'lib.dart';

// ignore: must_be_immutable
class PaginationButton extends StatelessWidget {
  int currentPage;
  int totalPage;
  void Function(int) onPressed;
  PaginationButton({
    required this.currentPage,
    required this.totalPage,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int displayStartIndex = max(1, min(currentPage - 1, totalPage - 2));

    List<int> displayPages = [
      for (int i = 0; i < min(3, totalPage); i++) displayStartIndex + i
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: displayPages
          .map((page) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                    // TODO : add them
                    style: ButtonStyle(
                      backgroundColor: page == currentPage
                          ? MaterialStateProperty.all(COLOR.RED)
                          : MaterialStateProperty.all(COLOR.BLUE),
                    ),
                    onPressed: () {
                      onPressed(page);
                    },
                    child: Text('$page')),
              ))
          .toList(),
    );
  }
}
