import 'package:qrunner/repository/db_connection.dart';
import 'package:sqflite/sqflite.dart';

class DbRepository {
    late DatabaseConnection _dbConnection;
    static Database? _database;

    DbRepository(){
     _dbConnection = DatabaseConnection();
    }

  Future<Database> get database async{
        if (_database != null) return _database!;
        _database = await _dbConnection.setDatabase();
        return _database!;
    }

    insertData(String table,Map<String, dynamic> data) async {
        final connection = await database;
        return await connection.insert(table, data);
    }

    Future<int> deleteData(String table) async {
      final connection = await database;
      return connection.delete(table);
    }

    Future<List<Map<String, Object?>>> readDataScannedCodesByTrackId(String trackId) async {
      final connection = await database;
      return await
      connection.query('CODE_SCAN_DATA',columns: ['trackId', 'code','pointIndex', 'scanTimestamp'], where: 'trackId = ?', whereArgs: [trackId]);
    }
}