import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';

class User {
  final int id;
  final String name;

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: int.parse(map[UserTable.id].toString()),
      name: map[UserTable.name].toString(),
    );
  }

  User({ required this.id, required this.name });
}