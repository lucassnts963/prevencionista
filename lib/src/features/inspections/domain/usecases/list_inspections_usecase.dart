import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/inspections_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:sqflite/sqflite.dart';

class ListInspectionsUseCase {

  static Future<List<Inspection>> execute() async {

    try {
      Database database = await Sqlite.getDatabase();
      InspectionsRepository repository = InspectionsSqliteRepository(database);
      List<Inspection> inspections = await repository.findAll();
      return inspections;
    } on Exception catch (error) {
      rethrow;
    }

  }
}