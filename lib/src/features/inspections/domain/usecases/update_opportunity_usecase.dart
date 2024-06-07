import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/opportunities_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/opportunities_repository.dart';
import 'package:prevencionista/src/shared/dtos/opportunity_create_dto.dart';
import 'package:sqflite/sqflite.dart';

class UpdateOpportunityUseCase {
  static Future<Opportunity> execute(OpportunityCreateDTO input) async {
    try {
      int? id = input.id;
      if (id == null) {
        throw Exception('Precisa ser informado o id da oportunidade!');
      }

      Database database = await Sqlite.getDatabase();
      OpportunityRepository repository = OpportunitiesSqliteRepository(database);
      await repository.update(id, input.toMap());
      print('UpdateOpportunityUseCase() - id: $id - type: ${id.runtimeType}');

      return await repository.findById(id);
    } on Exception catch(error) {
      print('Erro ao UpdateOpportunityUseCase: $error');
      rethrow;
    }
  }
}