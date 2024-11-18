import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

late final Database _database;

Future<void> init() async {
  print('Checking initialization');

  final String path = join(await getDatabasesPath(), 'drawings.db');

  _database = await openDatabase(
    path,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE drawings (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, date DATE, path TEXT)');
      print('Table created');
    },
    version: 1,
  );
  print(_database);
  print('finished');
}

/// Insert an image object
// Future<void> savePhoto(Photo photo) async {
//   _database.insert(
//     'photos',
//     photo.toMap(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }

// FIXME: Debugging databse only, delete once finished
Future<void> checkTableSchema() async {
  final List<Map<String, dynamic>> tableInfo =
      await _database.rawQuery('PRAGMA table_info(drawings)');
  print('Table schema: $tableInfo');
}

// FIXME: Debugging database only, delete once finished
Future<void> deleteDatabase() async {
  await _database.close();
  final String dbPath = join(await getDatabasesPath(), 'drawings.db');

// Delete the database
  await databaseFactory.deleteDatabase(dbPath);

  print('Database deleted');
}
