import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';

class OpportunityCreateDTO {
  int? id;
  final String description;
  final String local;
  final String action;
  final String status;
  final String imagePathBefore;
  final String? imagePathAfter;
  final String? pictureReport;
  final int inspectionId;

  Map<String, dynamic> toMap() {
    return {
      OpportunityTable.description: description,
      OpportunityTable.local: local,
      OpportunityTable.action: action,
      OpportunityTable.status: status,
      OpportunityTable.imagePathBefore: imagePathBefore,
      OpportunityTable.imagePathAfter: imagePathAfter,
      OpportunityTable.reportPicture: pictureReport,
      OpportunityTable.inspectionId: inspectionId,
    };
  }

  @override
  String toString() {
    return '$id - $description\nLocal: $local\nAction: $action\nStatus: $status\nBefore: $imagePathBefore\nAfter: $imagePathAfter\nReport: $pictureReport\nInspectionId:$inspectionId';
  }

  OpportunityCreateDTO({
    this.id,
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
