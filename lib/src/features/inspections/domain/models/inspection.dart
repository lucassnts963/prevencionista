import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';

class Inspection {
  final int id;
  final String name;
  final String date;

  static Inspection fromMap(Map<String, Object?> map) {
    return Inspection(id: int.parse(map[InspectionTable.id].toString()), name: map[InspectionTable.name].toString(), date: map[InspectionTable.date].toString());
  }

  Inspection({ required this.id, required this.name, required this.date });
}