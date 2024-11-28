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
          'CREATE TABLE drawings (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, date DATE, path TEXT, drawables TEXT)');
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
  _database.insert(
    'drawings',
    drawing.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateDrawing(Drawing drawing, int id) async {
  _database.update(
    'drawings',
    drawing.toMap(),
    where: 'id = ?',
    whereArgs: [id],
  );
}

// FIXME: Debugging database only, delete once finished
Future<void> deleteDatabase() async {
  await _database.close();
  final String dbPath = join(await getDatabasesPath(), 'drawings.db');

// Delete the database
  await databaseFactory.deleteDatabase(dbPath);

  print('Database deleted');
}
