part of 'lib.dart';

Future<List<String>> selectImageFile({bool multiSelect = false}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    // 입력받을 파일 type
    allowedExtensions: ['jpg', 'png'],
    allowMultiple: multiSelect,
  );

  List<PlatformFile> platformFiles = result == null
      // result 값이 없으면 빈값 반환
      ? []
      // 유효한 파일만 가져옴(bytes가 있는 경우)
      : result.files.where((PlatformFile file) => file.bytes != null).toList();
  List<String> imageBase64 = platformFiles
      .map((PlatformFile file) => base64Encode(file.bytes!))
      .toList();
  // List<Uint8List> imageBytes =
  //     platformFiles.map((PlatformFile file) => file.bytes!).toList();

  ('imageBase64 ${imageBase64.length}');

  return imageBase64;
}

Future<List<List<dynamic>>> selectCSVFile({bool multiSelect = false}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    // 입력받을 파일 type
    allowedExtensions: ['csv'],
    allowMultiple: multiSelect,
  );

  List<PlatformFile> readFiles = result == null
      // result 값이 없으면 빈값 반환
      ? []
      // 유효한 파일만 가져옴(bytes가 있는 경우)
      : result.files.where((PlatformFile file) => file.bytes != null).toList();

  String decodeBytes =
      utf8.decode(readFiles.first.bytes!, allowMalformed: true);
  final List<List<dynamic>> getCsv =
      const CsvToListConverter().convert(decodeBytes);

  return getCsv;
}
