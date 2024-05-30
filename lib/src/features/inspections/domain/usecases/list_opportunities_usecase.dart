import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/opportunities_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/opportunities_repository.dart';
import 'package:sqflite/sqflite.dart';

class ListOpportunitiesUseCase {

  static Future<List<Opportunity>?> execute(int inspectionId) async {
    Database database = await Sqlite.getDatabase();
    OpportunityRepository repository = OpportunitiesSqliteRepository(database);
    List<Opportunity>? opportunities = await repository.findAll(inspectionId);
    return opportunities;
  }
}