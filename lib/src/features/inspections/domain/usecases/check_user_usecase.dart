import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/users_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/models/user.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/users_repository.dart';
import 'package:sqflite/sqflite.dart';

class CheckUserUseCase {
  static Future<bool> execute() async {
    Database database = await Sqlite.getDatabase();
    UserRepository repository = UsersSqliteRepository(database);

    List<User>? users = await repository.findAll();
    print(users);

    if (users != null && users.isNotEmpty) {
      return true;
    }

    return false;
  }
}