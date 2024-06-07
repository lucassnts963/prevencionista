import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/data/repositories/users_sqlite_repository.dart';
import 'package:prevencionista/src/features/inspections/domain/models/user.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/users_repository.dart';
import 'package:sqflite/sqflite.dart';

class SignUpUseCase {
  static Future<User?> execute(String name) async {
    Database database = await Sqlite.getDatabase();
    UserRepository repository = UsersSqliteRepository(database);

    int? id = await repository.create(UserCreateDTO(name: name));

    if (id != null) {
      return User(id: id, name: name);
    }

    return null;
  }
}