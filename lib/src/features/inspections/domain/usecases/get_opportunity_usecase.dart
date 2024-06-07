import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/opportunities_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/opportunities_repository.dart';
import 'package:sqflite/sqflite.dart';

class GetOpportunityUseCase {

  static Future<Opportunity> execute(int id) async {

    try {
      Database database = await Sqlite.getDatabase();
      OpportunityRepository repository = OpportunitiesSqliteRepository(database);
      Opportunity opportunity = await repository.findById(id);
      return opportunity;
    } on Exception catch (error) {
      rethrow;
    }

  }
}