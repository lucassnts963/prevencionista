import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/user.dart';
import 'package:prevencionista/src/features/inspections/domain/repositories/users_repository.dart';
import 'package:sqflite/sqflite.dart';

class UsersSqliteRepository implements UserRepository {
  final Database database;

  UsersSqliteRepository(this.database);

  @override
  Future<int?> create(UserCreateDTO input) async {
    print(input.toMap());
    try {
      int id = await database.insert(Sqlite.USER_TABLE, input.toMap());
      return id;
    } on Exception catch (error) {
      print('Erro ao criar usuário! $error');
      return null;
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await database.delete(Sqlite.OPPORTUNITIES_TABLE, where: '${UserTable.id} = ?', whereArgs: [id]);
    } on Exception catch(error) {
      print('Erro ao tentar excluir um registro de usuário! $error');
    }
  }

  @override
  Future<List<User>?> findAll() async {
    try {
      var result = await database.query(Sqlite.USER_TABLE);
      print(result);

      List<User> opportunities = [];

      for (var e in result) {
        opportunities.add(User.fromMap(e));
      }

      return opportunities;
    } on Exception catch (error) {
      print('Erro ao consultar todas as usuários! $error');
      return null;
    }
  }

  @override
  Future<User?> findById(int id) async {
    try {
      var result = await database.query(Sqlite.OPPORTUNITIES_TABLE, where: '${UserTable.id} = ?', whereArgs: [id]);

      var rawData = result.first;

      print('findById() - $rawData');

      return User.fromMap(rawData);
    } on Exception catch (error) {
      print('Erro ao consultar usuário pelo id! $error');
      return null;
    }
  }

  @override
  Future<int> update(int id, Map<String, dynamic> map) async {
    try {
      var result = await database.update(Sqlite.OPPORTUNITIES_TABLE, map, where: '${UserTable.id} = ?', whereArgs: [id]);

      return result;
    } on Exception catch (error) {
      print('Erro ao atualizar usuário! $error');
      return -1;
    }
  }
}