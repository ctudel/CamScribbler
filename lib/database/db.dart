import 'package:cam_scribbler/models/models.dart';
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
          'CREATE TABLE drawings (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, date DATE, bg_path TEXT, drawing_path TEXT, drawables TEXT, rgb_enabled INTEGER)');
      print('Table created');
    },
    version: 1,
  );
  print(_database);
  print('finished');
}

getDrawings() async {
  final List<Map<String, dynamic>> query = await _database.query(
    'drawings',
  );

  // Iterate through query converting each map to a Drawing object and return
  return query
      .map<Drawing>(
        (Map<String, dynamic> map) => Drawing.fromMap(map),
      )
      .toList();
}

/// Insert an image object
Future<void> saveDrawing(Drawing drawing) async {
  await _database.insert(
    'drawings',
    drawing.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateDrawing(Drawing drawing, int id) async {
  await _database.update(
    'drawings',
    drawing.toMap(),
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<int> deleteDrawing(Drawing drawing) async {
  return await _database.delete(
    'drawings',
    where: 'id = ?',
    whereArgs: [drawing.id],
  );
}

// Debugging database only, uncomment if needed
// Future<void> deleteDatabase() async {
//   await _database.close();
//   final String dbPath = join(await getDatabasesPath(), 'drawings.db');
//   await databaseFactory.deleteDatabase(dbPath);
//   print('Database deleted');
// }
