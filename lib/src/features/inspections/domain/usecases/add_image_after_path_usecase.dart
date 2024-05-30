import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/opportunities_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/opportunities_repository.dart';
import 'package:sqflite/sqflite.dart';

class AddImageAfterPathUseCase {
  static Future<void> execute(int id, String path) async {
    try {
      Database database = await Sqlite.getDatabase();
      OpportunityRepository repository = OpportunitiesSqliteRepository(database);
      repository.update(id, { OpportunityTable.imagePathAfter: path });
    } on Exception catch (error) {
      print('Error ao AddImageAfterPathUseCase: $error');
    }
  }
}