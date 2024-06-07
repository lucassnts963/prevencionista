import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/opportunities_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/opportunities_repository.dart';
import 'package:sqflite/sqflite.dart';

class DeleteOpportunitiesFromInspectionUseCase {
  static Future<int> execute(int inspectionId) async {
    try {
      Database database = await Sqlite.getDatabase();
      OpportunityRepository repository = OpportunitiesSqliteRepository(database);
      await repository.deleteByInspectionId(inspectionId);
      print('DeleteOpportunitiesFromInspectionUseCase() - id: $inspectionId - type: ${inspectionId.runtimeType}');

      return 1;

    } on Exception catch(error) {
      print('Erro ao DeleteOpportunitiesFromInspectionUseCase: $error');
      return -1;
    }
  }
}