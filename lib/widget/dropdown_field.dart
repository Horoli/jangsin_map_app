part of 'lib.dart';

class CustomDropdownField extends StatelessWidget {
  String value;
  List<DropdownMenuItem> items;
  void Function(dynamic) onChanged;
  CustomDropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            // TODO : add theme
            decoration: InputDecoration(
              errorStyle:
                  const TextStyle(color: Colors.redAccent, fontSize: 16.0),
              // hintText: 'Please select expense',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: value, items: items, onChanged: onChanged),
            ),
          );
        },
      ),
    );
  }
}
