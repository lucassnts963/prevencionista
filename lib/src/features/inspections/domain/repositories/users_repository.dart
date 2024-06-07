import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/user.dart';

abstract class UserRepository {
  Future<List<User>?> findAll();
  Future<User?> findById(int id);
  Future<int?> create(UserCreateDTO input);
  Future<void> delete(int id);
  Future<int> update(int id, Map<String, dynamic> map);
}

class UserCreateDTO {
  int? id;
  String name;

  Map<String, dynamic> toMap() {
    return {
      UserTable.name: name,
    };
  }

  UserCreateDTO({ required this.name, this.id });
}