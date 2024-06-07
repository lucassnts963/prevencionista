import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/inspections_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:sqflite/sqflite.dart';

class DeleteInspectionUseCase {
  static Future<int> execute(int id) async {
    try {
      Database database = await Sqlite.getDatabase();
      InspectionsRepository repository = InspectionsSqliteRepository(database);
      await repository.delete(id);
      print('DeleteInspectionUseCase() - id: $id - type: ${id.runtimeType}');

      return 1;

    } on Exception catch(error) {
      print('Erro ao DeleteOpportunityUseCase: $error');
      return -1;
    }
  }
}