import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  String databasesPath  = await getDatabasesPath();
  String path = join(databasesPath, 'prevent.db');

  Database database = await openDatabase(path, onCreate: (db, version) async {
    await db.execute(
        'CREATE TABLE inspections (id INTEGER PRIMARY KEY, name TEXT, date TEXT)');

    await db.execute(
        'CREATE TABLE opportunities (id INTEGER PRIMARY KEY, description TEXT, status TEXT, local TEXT, image_path_before TEXT, image_path_after TEXT, inspection_id INTEGER, action TEXT, picture_report TEXT)');
  }, version: 1);

  return database;
}

Future<Inspection> addInspection(String name, String date) async {
  Database db = await getDatabase();

  int id = await db.insert('inspections', {
    'name': name,
    'date': date,
  });

  return Inspection(id: id, name: name, date: date);
}

Future<int> addOpportunity(String description, String status, String local, String imagePathBefore, String? imagePathAfter, String action, int inspectionId) async {
  Database db = await getDatabase();

  int id = await db.insert('opportunities', {
    'description': description,
    'status': status,
    'local': local,
    'action': action,
    'image_path_before': imagePathBefore,
    'image_path_after': imagePathAfter,
    'inspection_id': inspectionId,
  });

  return id;
}

Future<void> deleteOpportunity(int id) async {
  try {
    Database db = await getDatabase();

    await db.delete('opportunities', where: 'id = ?', whereArgs: [id]);
  } on Exception catch(error) {
    print(error);
  }
}

Future<List<Opportunity>?> findAllOpportunity(int inspectionId) async {
  try {
    Database db = await getDatabase();

    var result = await db.rawQuery('SELECT * FROM opportunities WHERE inspection_id = ?', [inspectionId]);

    List<Opportunity> opportunities = [];

    for (var e in result) {
      opportunities.add(Opportunity.fromMap(e));
    }

    return opportunities;
  } on Exception catch (error) {
    return null;
  }
}

Future<List<Inspection>?> findAllInspections() async {
  try {
    Database db = await getDatabase();

    var result = await db.rawQuery('SELECT * FROM inspections');

    List<Inspection> inspections = [];

    for (var e in result) {
      inspections.add(Inspection.fromMap(e));
    }

    return inspections;
  } on Exception catch (error) {
    return null;
  }
}

Future<Inspection?> findInspection(String date) async {

  try {
    Database db = await getDatabase();

    var result = await db.rawQuery('SELECT * FROM inspections WHERE date = ?', [date]);

    var rawData = result.first;

    return Inspection.fromMap(rawData);
  } on Exception catch (error) {
    print(error);
    return null;
  }
}
