import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/opportunities_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/opportunities_repository.dart';
import 'package:prevencionista/src/shared/dtos/opportunity_create_dto.dart';
import 'package:sqflite/sqflite.dart';

class AddOpportunityUseCase {
  static Future<Opportunity?> execute(OpportunityCreateDTO input) async {
    try {
      Database database = await Sqlite.getDatabase();
      OpportunityRepository repository = OpportunitiesSqliteRepository(database);
      int? id = await repository.create(input);
      print('AddOpportunityUseCase() - id: $id - type: ${id.runtimeType}');

      if (id != null) {
        return await repository.findById(id);
      }

      return null;

    } on Exception catch(error) {
      print('Erro ao AddOpportunityUseCase: $error');
      return null;
    }
  }
}