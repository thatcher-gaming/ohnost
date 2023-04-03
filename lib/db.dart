import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late final Database database;

Future<void> setup() async {
  database = await openDb();
}

Future<Database> openDb() async {
  return await openDatabase(
    join(await getDatabasesPath(), 'ohnost.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE settings(key STRING PRIMARY KEY, value STRING)',
      );
    },
    version: 12,
  );
}

class Setting {
  Setting(this.key, this.value);
  // Setting.fromMap(Map<String, Object?> map) {
  //   key = map['columnKey'] as String;
  // }

  String key;
  String value;

  static Future<Setting> get(String key) async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'settings',
        where: 'key = ?',
        whereArgs: [key],
      );
      if (maps.isEmpty) return Setting(key, "");
      return maps.first[1];
    } catch (e) {
      return Setting(key, "");
    }
  }
}
