import 'package:prevencionista/src/features/inspections/data/data_sources/sqlite_connection.dart';

class Opportunity {
  final int id;
  final String description;
  final String local;
  final String action;
  final String status;
  final String imagePathBefore;
  final int inspectionId;

  String? _pictureReport;
  String? _imagePathAfter;

  String build(int index) {
    return "*${index + 1} - ❌ $description*\n*Status*: $status\n*Ação*: $action\n*Local*: $local";
  }

  static Opportunity empty() {
    return Opportunity(id: -1, description: '', local: '', action: '', status: '', imagePathBefore: '', inspectionId: -1);
  }


  @override
  String toString() {
    return '$id - $description\nLocal: $local\nAction: $action\nStatus: $status\nBefore: $imagePathBefore\nAfter: $_imagePathAfter\nReport: $_pictureReport';
  }

  static Opportunity fromMap(Map<String, dynamic> map) {
    return Opportunity(
      id: int.parse(map[OpportunityTable.id].toString().trim()),
      description: map[OpportunityTable.description].toString().trim(),
      action: map[OpportunityTable.action].toString().trim(),
      local: map[OpportunityTable.local].toString().trim(),
      status: map[OpportunityTable.status].toString().trim(),
      imagePathBefore: map[OpportunityTable.imagePathBefore].toString().trim(),
      imagePathAfter: map[OpportunityTable.imagePathAfter].toString().trim(),
      pictureReport: map[OpportunityTable.reportPicture].runtimeType == null.runtimeType ? null : map[OpportunityTable.reportPicture].toString().trim(),
      inspectionId: map[OpportunityTable.inspectionId],
    );
  }

  String? get pictureReport {
    return _pictureReport;
  }

  String? get imagePathAfter => _imagePathAfter;

  set imagePathAfter (String? path) {
    if (path == '' || path == 'null') {
      return;
    }
    _imagePathAfter = path;
  }

  set pictureReport (String? path) {
    if (path == '' || path == 'null') {
      return;
    }
    _pictureReport = path;
  }

  Opportunity({
    required this.id,
    required this.description,
    required this.local,
    required this.action,
    required this.status,
    required this.imagePathBefore,
    required this.inspectionId,
    String? imagePathAfter,
    String? pictureReport,
  }) {
    _imagePathAfter = imagePathAfter;
    _pictureReport = pictureReport;
  }
}
