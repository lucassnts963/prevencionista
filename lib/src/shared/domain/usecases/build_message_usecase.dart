import 'package:flutter/services.dart';
import 'package:prevencionista/src/features/inspections/domain/models/inspection.dart';
import 'package:prevencionista/src/features/inspections/domain/models/opportunity.dart';

class BuildMessageUseCase {
  static Future<String> execute (Inspection inspection) async {
    String message = await rootBundle.loadString('assets/report_model.txt');

    List<Opportunity> opportunities = inspection.opportunities;

    message = message.replaceAll("#date", inspection.date);
    message = message.replaceAll("#name", inspection.name);

    for (int i = 0; i < opportunities.length; i++) {
      message =
      "$message${opportunities[i].build(i)}${i + 1 == opportunities.length ? "" : "\n\n"}";
    }

    return message;
  }
}