import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';

class PathProvider {
  static Future<String> getExternalDocumentPath() async {
    final Directory _directory = await getExternalStorageDirectory();
    final exPath =
        _directory.path.split('0')[0] + "0/${CoreSettings.appName}/documents";
    print("Saved Path: $exPath");
    await Directory('$exPath').create(recursive: true);
    return exPath;
  }
}
