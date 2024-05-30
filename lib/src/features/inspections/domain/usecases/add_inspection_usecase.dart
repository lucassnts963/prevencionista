import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/inspections_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:sqflite/sqflite.dart';

class AddInspectionUseCase {
  static Future<Inspection?> execute(Map<String, dynamic> map) async {
    try {
      Database database = await Sqlite.getDatabase();
      InspectionsRepository repository = InspectionsSqliteRepository(database);
      int? id = await repository.create(map);

      if (id != null) {
        return await repository.findById(id);
      }

      return null;
    } on Exception catch (error) {
      print('Erro ao AddInspectionUseCase: $error');
      return null;
    }

  }
}