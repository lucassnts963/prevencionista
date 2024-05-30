import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/opportunities_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/opportunities_repository.dart';
import 'package:sqflite/sqflite.dart';

class DeleteOpportunityUseCase {
  static Future<int> execute(int id) async {
    try {
      Database database = await Sqlite.getDatabase();
      OpportunityRepository repository = OpportunitiesSqliteRepository(database);
      await repository.delete(id);
      print('DeleteOpportunityUseCase() - id: $id - type: ${id.runtimeType}');

      return 1;

    } on Exception catch(error) {
      print('Erro ao DeleteOpportunityUseCase: $error');
      return -1;
    }
  }
}