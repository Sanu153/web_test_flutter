import 'package:open_file/open_file.dart';

class SMOpenFile {
  static Future<bool> open(String path) async {
    try {
      final OpenResult _openResult = await OpenFile.open(path);
      print("Open result Type: ${_openResult.type}");
      print("Open result Message: ${_openResult.message}");
    } catch (e) {
      return false;
    }
    return true;
  }
}
