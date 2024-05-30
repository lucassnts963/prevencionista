import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqlite {
  static String DATABASE_NAME = 'inspection.db';
  static String INSPECTIONS_TABLE = 'inspections';
  static String OPPORTUNITIES_TABLE = 'opportunity';

  static Future<Database> getDatabase() async {
    String databasesPath  = await getDatabasesPath();
    String path = join(databasesPath, DATABASE_NAME);

    Database database = await openDatabase(path, onCreate: (db, version) async {
      try {
        await db.execute("""
          CREATE TABLE $INSPECTIONS_TABLE (
            ${InspectionTable.id} INTEGER PRIMARY KEY, 
            ${InspectionTable.name} TEXT, 
            ${InspectionTable.date} TEXT
          )          
          """);
      } on Exception catch (error) {
        print('Erro ao criar tabela $INSPECTIONS_TABLE: ${error.toString()}');
      }

      try {
        await db.execute("""
          CREATE TABLE $OPPORTUNITIES_TABLE (
            ${OpportunityTable.id} INTEGER PRIMARY KEY, 
            ${OpportunityTable.description} TEXT, 
            ${OpportunityTable.status} TEXT, 
            ${OpportunityTable.local} TEXT,
            ${OpportunityTable.action} TEXT, 
            ${OpportunityTable.imagePathBefore} TEXT, 
            ${OpportunityTable.imagePathAfter} TEXT, 
            ${OpportunityTable.reportPicture} TEXT,
            ${OpportunityTable.inspectionId} INTEGER
          )
      """);
      } on Exception catch (error) {
        print('Erro ao criar tabela $OPPORTUNITIES_TABLE: ${error.toString()}');
      }
    }, version: 1);

    return database;
  }
}

class InspectionTable {
  static String id = '_id';
  static String name = 'name';
  static String date = 'date';
}

class OpportunityTable {
  static String id = '_id';
  static String description = 'description';
  static String status = 'status';
  static String local = 'local';
  static String action = 'action';
  static String imagePathBefore = 'image_path_before';
  static String imagePathAfter = 'image_path_after';
  static String reportPicture = 'report_picture';
  static String inspectionId = 'inspection_id';
}