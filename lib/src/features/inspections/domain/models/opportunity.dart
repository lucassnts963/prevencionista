import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';

class Opportunity {
  final int id;
  final String description;
  final String local;
  final String action;
  final String status;
  final String imagePathBefore;
  final String? imagePathAfter;
  final String? pictureReport;
  final int inspectionId;

  String build(int index) {
    return "${index + 1} - ❌ $description\nStatus: $status\nAção: $action\nLocal: $local";
  }

  @override
  String toString() {
    return '$id - $description\nLocal: $local\nAction: $action\nStatus: $status\nBefore: $imagePathBefore\nAfter: $imagePathAfter\nReport: $pictureReport';
  }

  static Opportunity fromMap(Map<String, dynamic> map) {
    return Opportunity(
      id: int.parse(map[OpportunityTable.id].toString()),
      description: map[OpportunityTable.description].toString(),
      action: map[OpportunityTable.action].toString(),
      local: map[OpportunityTable.local].toString(),
      status: map[OpportunityTable.status].toString(),
      imagePathBefore: map[OpportunityTable.imagePathBefore].toString(),
      imagePathAfter: map[OpportunityTable.imagePathAfter].toString(),
      pictureReport: map[OpportunityTable.reportPicture].runtimeType == null.runtimeType ? null : map[OpportunityTable.reportPicture].toString(),
      inspectionId: map[OpportunityTable.inspectionId],
    );
  }

  Opportunity({
    required this.id,
    required this.description,
    required this.local,
    required this.action,
    required this.status,
    required this.imagePathBefore,
    required this.inspectionId,
    this.imagePathAfter,
    this.pictureReport,
  });
}
