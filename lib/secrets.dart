import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppSecrets {
  static const String cookie =
      "s%3A7iD95SmR8-piN5bpQHU06n1RuyB1kqQ_.WT%2FUm0zOYDL0r7NOOnRwE0M5flqKnSBPtjJNulSdxMU";
  static const String currentProjectHandle = "ohnost-test-suite";

  Future<String?> _read() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/cookie.txt');
      String text = await file.readAsStringSync();
      return text;
    } catch (e) {
      return null;
    }
  }

  _save(String cookie) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/cookie.txt');
    await file.writeAsString(cookie);
  }
}
