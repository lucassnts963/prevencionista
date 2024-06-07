import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';

class Inspection {
  final int id;
  final String name;
  final String date;
  List<Opportunity> opportunities = [];

  static Inspection fromMap(Map<String, dynamic> map) {
    return Inspection(
      id: int.parse(map[InspectionTable.id].toString().trim()),
      name: map[InspectionTable.name].toString().trim(),
      date: map[InspectionTable.date].toString().trim(),
    );
  }

  static Inspection empty() {
    return Inspection(id: -1, name: '', date: '');
  }

  Inspection({required this.id, required this.name, required this.date});
}
