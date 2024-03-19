import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {

  setDatabase() async {
    var database = await openDatabase(
      join(await getDatabasesPath(), 'qrunner_database.db'),
      onCreate: (db, version) async {
        return await db.execute('CREATE TABLE CODE_SCAN_DATA(userId INTEGER, trackId INTEGER, code TEXT, pointIndex INTEGER, '
            ' scanTimestamp TEXT, PRIMARY KEY(trackId, code));');
      },
      version: 1,
    );
    return database;
  }
}